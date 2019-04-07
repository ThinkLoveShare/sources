---
author: "Laluka"
title: "PWN 2/4 : Retour case libc, piochez un shell ! "
slug: "pwn_2of4_ret2libc"
date: 2018-05-08
status: "original"
description: "Introcution au Return to libc (ret2libc) et exemple pratique."
---

 > Petit ajout après la publication des articles :

 > Ces quatres articles ont donné lieu à une conférence d'introduction au pwn à la HitchHack 2018. Elle résume les 3 premiers articles mais rentre moins dans le détail. Si ce format vous convient mieux, les slides sont téléchargables [ici](/hacking/pwn_1of4_buffer_overflow/slides_conf_123_pwned.pdf) et la vidéo (francais uniquement) ici :

{{< youtube hmt8M9YLwTg >}}

Bienvenue pour ce 2ème article consacré au pwn d'exécutables linux !

Au programme, le ret2libc, ou retour à la lib C. Toujours dans la famille des exploits type buffer overflow, et toujours avec les sources du collègue : https://cyrilbresch.fr/

Je ne repasse pas par la liste des définitions, celle-ci ayant été bien dégrossie dans le premier article.


## Le ret2libc... Pourquoi ?

Dans le premier article, nous avons injecté un shellcode dans la stack, et nous avons utilisé le buffer overflow pour rediriger le flot d'exécution sur notre shellcode, ceci nous permettant de spawn un shell. C'était bien, c'était un peu tricky, mais c'était... Fonctionnel ? Ce n'est malheureusement plus aussi facilement réalisable de nos jours. Triste n'est-il pas ?

En effet, à chaque faille de sécurité, de nouvelles protections sont élaborées et ajoutées aux systèmes. L'une des protections trouvée contre cette attaque est l'usage d'un flag NX placé sur la pile. Cela rend la stack non exécutable. Damnit !

<img class="img_med" src="/hacking/pwn_2of4_ret2libc/mince.jpg" alt="mince" >

Heureusement pour nous, des barbus (ou imberbes, qui suis-je pour juger ?) ont trouvé des solutions pour pouvoir quand même s'amuser. L'une d'entre elles, le ret2libc !


## Le ret2libc... Wut ?

Un programme en C ne sait pas faire grand-chose, très peu en fait. Nous faisons dans un programme appel à des fonctions qui "font de la magie", et ce sans trop réfléchir à ce qu'il y a dessous.

Par exemple, la fonction printf qui nous permet d'afficher du texte. La fonction getc qui nous permet de lire un caractère saisi par l'utilisateur. Ou encore... La fonction system, qui nous permet d'exécuter un programme externe au notre. Toutes ces fonctions sont accessibles dans notre programme, nous les utilisons sans jamais avoir eu la curiosité (ni même l'envie ? ) de regarder leur contenu ou de les recoder. Tant mieux, elles sont déjà faites, et placées dans la... \
*roulement de tambours...*\ **libc** !

Petite ref au man : http://man7.org/linux/man-pages/man7/libc.7.html

<img class="img_med" src="/hacking/pwn_2of4_ret2libc/rtfm.jpg" alt="rtfm" >

En bref, c'est la librairie standard C, l'endroit où sont stockées toutes les fonctions les plus habituelles / utilisées.

Un programme utilisant la libc en dynamique se verra, à son lancement, donné un accès à la libc via son offset (comprendre "là où il peut trouver la trouver" / sa position, en nb de byte, dans la stack).

La manière dont il trouve les différentes fonctions dans la libc est assez complexe, je n'en parlerai donc pas dans cet article, mais pour les plus curieux / courageux : [plt_got_ld_so](https://www.segmentationfault.fr/linux/role-plt-got-ld-so/)

L'idée générale est la suivante :

La stack n'est pas exécutable ? Duh... La libc, elle, est présente, contient des fonctions intéressantes, et est exécutable. Plus qu'à sauter dessus, sens propre comme figuré !

On va donc placer dans la stack les arguments qui nous intéressent (les passages d'arguments se font ici par la stack, x86-64 conventions) ainsi que détourner à nouveau le flot d'exécution du programme pour lui faire exécuter la fonction system (il y a pleinnnnn de variantes, mais ca reste le plus classique).

Remarque :

Un programme compilé en statique (gcc : option -static) n'est pas exploitable de cette manière, car les fonctions utilisées de la libc auront été incorporées au programme, elle ne sera donc pas attachée au lancement. Il n'aura donc pas accès à la fonction system. Mais heureusement pour vous... Article 3 ? è_é


## Le ret2libc... Comment ?

Les bases sont posées, maintenant, le walkthrough !

Le binaire étudié est téléchargable [ici](/hacking/pwn_2of4_ret2libc/vuln)

On commence par comprendre comment le programme fonctionne (ou ne fonctionne pas...), trouver le point de crash :

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/recon.png" alt="recon" >

Remarque :

 - `$(cmd)` : permet de faire exécuter en priorité la commande cmd.

 - `python -c "code"` : permet d'exécuter du code python via bash. Donc afficher facilement plein de caractères.

On crash. Bien ca, excellent ! Maintenant, l'offset, avec le tool `pattern` dans gdb-peda :

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/pattern_create.png" alt="pattern_create" >

Je vais expliquer un peu mieux le prochain screenshot, car il vous a pas mal embêté (cf vos retours, merciii !)

Le terminal est découpé en trois parties :

 * Registers : Ce que contiennent les différents registres au moment où le programme s'arrête, ici par un crash.

 * Code : Là où pointe EIP (Instruction Pointer), c'est à dire là où on en est dans l'exécution et les instructions à suivre.

 * Stack : Le contenu de notre pile, avec les adresses, leur format, références, ...

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/pattern_search.png" alt="pattern_search" >

Puis on cherche le pattern utilisé précédemment pour trouver l'offset. Ici, miracle, on contrôle directement EIP, ce qui est en réalité assez rare... Tant mieux pour nous !

L'offset affiché pour EIP est donc de 268 bytes.

Maintenant, la partie ret2libc :

Un payload simple aura la structure suivante :

-> "A" * offset\
-> Là où on veut sauter (system)\
-> Là où le programme retournera après l'appel de fonction\
-> Argument(s) de la fonction utilisée

Il nous manque donc l'adresse de system, et de notre paramètre.

Il y a plein de manière permettant de récupérer ces informations, je vais vous en donner deux.

Attention, on travaille ici sans l'ASLR, une fois de plus pour rendre l'exploit plus compréhensible. Pour le désactiver :

```shell
$ # En tant que root :
$ echo 0 > /proc/sys/kernel/randomize_va_space
```

La première, plus simple mais aussi pas toujours fiable, via gdb / peda (attention, gdb désactive par défaut l'ASLR lors du débuggage) :

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/break_main.png" alt="break_main" >

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/print_system.png" alt="print_system" >

Il est important de mettre un breakpoint (point d'arrêt logiciel, une manière de mettre le programme en pause pour voir par exemple l'état de ses registres, puis continuer son exécution ultérieurement) en début de programme et de le lancer avant de faire notre recherche, car il est nécessaire que la libc ait été résolue (attachée / linkée). Dans le cas contraire, on ne voit rien, ni system, ni "/bin/sh", ce string étant gentiment placée dans la libc.

Deuxième solution, un peu moins simple mais tellement plus fiable / évolutive :

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/ldd.png" alt="ldd" >

Je vais vous la détailler, car ces outils sont puissants mais pas forcément faciles à utiliser quand on les découvre.

 * Etape 1 :

 ldd affiche les dépendances partagées d'un programme. Ici, (entre autre), la libc et son offset. Sans ASLR il ne change pas, avec, il changera à chaque commande.

 * Etape 2 :

 readelf, nous permet d'analyser le contenu de la libc, qui est un ELF, mais aussi une librairie partagée. Option `-a` pour lire tout le contenu, et mettre à l'aide d'un pipe `|` toute les lignes analysées dans grep, qui va rechercher les lignes contenant le mot system. On récupère celle qui nous intéresse : 0x0003c7d0, donc l'offset de system dans la libc.

 * Etape 3 :

 On cherche `/bin/sh\x00` dans la libc. `-b` pour avoir l'offset en byte, `-o` pour n'avoir que le mot recherché et non la ligne, et `-a` pour activer l'analyse en mode binaire. On obtient donc en décimal l'offset de `/bin/sh` dans la libc.

 * Etape 4 :

 Un coup de python pour avoir la somme de l'offset de la libc et de ce qui nous intéresse, et BIM, on a tout. Un peu plus long, mais pour des exploits plus compliqués, cette manière de faire est à privilégier, croyez-moi ! :')

<img class="img_med" src="/hacking/pwn_2of4_ret2libc/mind_blown.gif" alt="mind_blown" >

On a donc récupéré les adresses de system et de `/bin/sh` pour faire exécuter un shell. Nickel ! :D

Maintenant qu'on a tout ce qu'il nous faut, on écrit notre exploit :

```python
#!/usr/bin/en python2

from pwn import *

offset = 268
payload = "A" * offset
payload += p32(0xf7dfa7d0) # @system
payload += p32(0x42424242) # @retour - foo
payload += p32(0xf7f3688a) # @"/bin/bash\x00"

r = process(["./vuln", payload])
r.interactive()
```

Remarque :

Ici, j'ai mis 0x42424242 car la valeur ne nous importe peu, où se rend le programme en sortant de la fonction attaquée, ici ca n'a pas d'importance. Mais si vous voulez éviter que le programme crash une dois que vous fermez votre shell, il est possible de mettre à cet emplacement l'adresse de la fonction exit, qui fermera proprement le programme, ne laissant ainsi pas de trace dans les logs... ;)

Ici, une fois le shell fermé, le programme sautera à l'adresse 0x4242424 et mourra d'un douloureux segfault... Sauvez des vies, placez des exit... Ou pas.

Puis on le lance :

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/run_exploit.png" alt="run_exploit" >

Et BIM, on pop notre shell via un ret2libc bien basique !

<img class="img_med" src="/hacking/pwn_2of4_ret2libc/like_a_boss.jpg" alt="like_a_boss" >

## Bonus : Cartographie de la mémoire !

A supposer que l'ASLR soit activé, cette solution est quand même exploitable sous une condition : Arriver à trouver la libc. Il existe de nombreuses techniques pour arriver à faire fuiter l'endroit où elle a été placée, mais une fois que vous l'avez (une fois le programme lancé, car rappelez-vous, elle change à chaque fois), il n'y a qu'à ajouter l'offset pour avoir votre exploit.

Mais coup de chance, dans votre système, il y a un endroit magique, lisible par tous l'utilisateur qui a lancé le programme (merci Geluchat pour la réctification, site du poto ici : https://www.dailysecurity.fr/), qui vous indique où sont placés les différents objets liés à son exécution : `/proc/self/maps` !

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/maps.png" alt="maps" >

Un petit tour par ici, ou par /proc/PID/maps (le PID étant l'identifiant du programme à analyser) vous permettra de voir où sont placés les différentes parties. Si vous arrivez à mettre votre programme en pause et lire cet endroit, l'ASLR n'a plus aucune utilité ! :)

Je m'arrête ici pour cette brève introduction au ret2libc. Sachez tout de même que c'est un exemple de base, qu'il est courant de "chaîner" les ret2libc afin de faire appel à plusieurs fonctions au sein d'un unique exploit. Prochain article, le ROP !

A bientôt pour le troisième article et merci pour vos nombreux retours ! `^_^`

Et pour ceux de ma promo qui me lisent...\
Bonne suite de révisions pour les rattrapajjjj !
