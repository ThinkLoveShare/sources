---
author: "Laluka"
title: "PWN 3/4 : SaperliROPette !"
date: 2018-05-09
---

Route du pwn, troisième et avant dernière escale, bienvenue à bord !

Hier, le simple buffer overflow et le ret2libc, aujourd'hui, le ROP, ou Return Oriented Programming, et demain... Demain la conquête du monde !!!

Je vous ai laissé hier sur le ret2libc, qui, vu de loin, consiste à piocher dans la libc les fonctions qui nous intéressent. Sauf que cette attaque n'est pas possible dans le cas où le programme est compilé en statique, et difficilement faisable si l'ASLR est activé. Nous allons aujourd'hui découvrir le ROP qui nous permet de contourner ces protections.

Ca ressemble de plus en plus au jeu du chat et de la souris, so... Follow the guide cat !

1. Précisions ASLR et PIC :
Avant de commencer, un petit retour sur ces protections parfois floues.

La configuration de l'ASLR est présente dans /proc/sys/kernel/randomize_va_space. Elle peut être à 0=désactivée, 1=activée (stack et heap), 2=activée (1 + data). La valeur 2 étant la nouvelle norme en cours d'adoption par les différents systèmes, déjà effective pour la plupart.

L'ASLR laisse donc toute une surface d'attaque non randomisée. Arriva donc ce qu'il devait arriver : des attaques utilisant les sections .data, .got, .plt, ...

Plus d'informations sur les différentes sections et la structure d'un ELF ici : https://www.cs.stevens.edu/~jschauma/631A/elf.html

L'ASLR ne suffisant pas, de nouvelles protections ont été mises en place : PIC / PIE (Position Indépendant Code / Exécutable). N'ayant pas encore suffisamment étudié son fonctionnement, je ne vais pas la présenter en détail. Mais l'idée est simple... Et si on randomisait.... TOUT ?!?!?!

Le ROP fonctionne avec un ASLR partiel ou total, mais est contré par cette dernière mesure...

Suite à la prochaine contre contre-mesure ! è.é

2. Présentation de la technique :
Return... Oriented... Programming...

Hum hum... Programmer... Avec des return ? °^°'

On va profiter du fait que la section .text du programme soit toujours au même emplacement pour piocher plein de petits bouts de code appelés gadgets, et les assembler pour faire notre exploit. L'exploit est donc une suite d'adresses pointant sur de l'assembleur, donc dans l'absolu, on peut tout faire avec. La limite ? Les gadgets qui sont à notre disposition dans le programme...

Même si on "peut tout faire", la stratégie la plus commune reste de faire comme dans l'article 1 où l'on génère un shellcode qui, via un syscall, permet d'exécuter un programme de notre choix.

Une chose importante à relever ici : On a besoin de gadgets. Les gadgets, c'est du code qui ne bouge pas. Les librairies, ca bouge. Donc un programme qui se base sur les librairies aura bien moins de surface d'attaque qu'un programme compilé en statique, qui, lui, contient tout le code qu'il utilise. De même, plus un programme va être volumineux et faire des actions complexes, plus vous avez de chance qu'il y ait des gadgets intéressants. Capich ? Noice !

Maintenant, abordons plus en détail les gadgets voulez-vous ?

Ils doivent tous répondre à un critère majeur : Se terminer par une instruction ret.

C'est ce critère qui rend l'attaque possible. En effet, lorsque l'on va contrôler le pointer d'instructions, on va faire en sorte que le programme exécute un premier gadget, que l'instruction ret finale indique la fin de l'exécution du premier gadget, et fasse revenir sur notre point de départ (la stack, qu'on vient d'overflow), mais une adresse plus loin. Cette adresse sera celle du second gadget et ainsi de suite.

Méfiance tout de même, si votre gadget se termine par un ret, mais contient des instructions qui modifient le flot d'exécution du programme, il risque de casser votre exploit. Donc pas de call, pas de leave, pas de "double ret", pas de bras, et surtout : pas de chocolat.

De nombreux outils permettent de lister les gadgets d'un exécutable, comme ROPgadget, Ropper, XRop, ...

3. Elaboration de l'exploit :
Avant toute chose, on regarde un peu à quoi on s'attaque : x64, compilé en statique, full ASLR. Ok !

Vous avez l'habitude maintenant, le classique :

Comprendre le fonctionnement du programme, trouver le point de crash, puis l'offset !

Ici encore, on voit que l'on crash sur un ret... Contrôlons-nous RSP ? Oui ! Offset ? 264 !

Petit rappel, ret a pour effet de placer ce vers quoi pointe RSP (donc le dernier élément de la stack), dans RIP. Nous avons donc RIP sous notre contrôle. Donc... RIP !

On utilise ensuite l'outil ropgadget qui nous offre une superbe ropchain faite à partir de notre programme vulnérable : $ ropgadget --binary vuln --ropchain

L'output est long (verbeux), je n'en mets qu'une partie :

On en fait donc un fichier python, notre exploit est donc :

C'est pas beau toute cette automatisation ? Bon, ca ne marche pas à tous les coups, mais quand ca marche, le gain de temps est énorme, surtout en CTF... ;)

On va maintenant l'exploiter :

TADA, one more shell ! :D

Petit détail qui tue, on voit ici que $0 (le nom du programme exécuté) vaut "bash", alors que dans notre ropchain, on avait /bin//sh (qui est compris comme /bin/sh). Mais c'est normal, car sur ma machine, /bin/sh est un lien symbolique qui pointe vers bash ! Mon vrai sh est /usr/bin/sh.

"Mais... Ca ne concorde pas avec les exploits précédents ?!"

Wouah ! Un qui suit ! Oui, en effet...

Plus d'informations sur ce micmac ici (très bon blog du poto Pixis) : https://beta.hackndo.com/sh-vs-bash/

C'est tout pour cette courte introduction au ROP, j'espère qu'elle vous a mindblown comme il se doit.

Vous avez désormais quelques cartes en main : BOF / shellcode / ret2libc / ROP / cerveau / ...

C'est pourquoi notre prochaine rencontre se fera autour de l'analyse d'un programme un peu plus complet. Nous allons donc conclure cette série et...

Tout faire péterrrrr !

A très vite,

-Laluka
