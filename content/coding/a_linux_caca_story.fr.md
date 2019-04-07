---
author: "Laluka"
title: "Une histoire de linux et de caca"
slug: "a_linux_caca_story"
date: 2019-04-06
status: "traduit"
description: "Il y a quelques jours, j'ai réalisé qu'un fichier 'libcaca.so' était présent dans mon système de fichiers linux. Comme je suis resté un gamin dans ma tête, j'ai voulu enquêter. Ce que j'ai trouvé, est... Magnifique. "
---


## La cause initiale

Here's the thing, I was doing some cleaning in my computer's home directory after solving some hacking challenge. To see what kind of files where still present I ran the command `ta`, which is aliased (in my system) to the following function.

Voilà l'idée, je faisais un peu de nettoyage dans le répertoire home de mon ordinateur après avoir résolu un challenge de hacking. Pour voir quels types de fichiers étaient encore présents, j'ai utilisé la commande `ta`, qui est aliasée (dans mon système) à la fonction suivante.


```bash
ta () {
  tree -ah "$@" | lolcat;
}
```

Elle liste mes fichiers de manière récursive, montrant également les fichiers cachés et mettant quelques jolies couleurs arc-en-ciel au passage.

<img class="img_big" src="/coding/a_linux_caca_story/cacache.png" alt="cacache">

J'ai jeté un coup d'oeil au résultat et j'ai trouvé le mot `_cacache`. Je suis encore un gamin, je lis "caca", je rigole... Bon... Du caca caché ? Mode curieux activé ! Ais-je vraiment de la merde dans mon ordinateur ? Si oui, en quelle quantité ? Quel genre de caca mon système d'exploitation actuel possède-t-il ?

<img class="img_med" src="/coding/a_linux_caca_story/hmm.jpg" alt="hmm">

J'ai donc exécuté la commande suivante pour inspecter mon système. Pour la comprendre, vous pouvez parcourir le manuel en utilisant `man find`, mais bon, je sais que vous n'êtes pas là pour ça alors voilà l'explication !

- sudo - SuperUserDo, exécuter la commande en super utilisateur
- find - Assez explicite, chercher des fichiers
- / - A partir de la racine du système de fichier, donc chercher 'partout'
- xdev - Parcourir seulement ce système et pas les fs attachés / montés
- iname - Chercher par nom, insensible à la casse
- "\*caca\*" - Qui contient le mot caca, pas de contrainte sur le début ou la fin

```bash
sudo find / -xdev -iname "*caca*"
```

J'ai enlevé certains résultats qui n'étaient pas très intéressants, voici le résumé :

```
/DRIVE/perso/2015/arthur/caca_papillon.jpg
/root/.npm/_cacache
/home/laluka/.npm/_cacache
/home/laluka/.atom/.apm/_cacache
/usr/share/licenses/libcaca
/usr/share/libcaca
/usr/share/libcaca/caca.txt
/usr/include/caca_conio.h
/usr/include/cacard
/usr/include/cacard/libcacard.h
/usr/include/caca.h
/usr/include/caca_types.h
/usr/include/caca0.h
/usr/lib/libcaca.so
/usr/lib/gstreamer-1.0/libgstcacasink.so
/usr/lib/pkgconfig/libcacard.pc
/usr/lib/pkgconfig/caca.pc
/usr/lib/libcacard.so
/usr/lib/libcaca.so.0
/usr/lib/vlc/plugins/video_output/libcaca_plugin.so
/usr/lib/libcaca.so.0.99.19
/usr/lib/libcacard.so.0.0.0
/usr/lib/node_modules/npm/node_modules/cacache
/usr/lib/libcacard.so.0
/usr/bin/cacafire
/usr/bin/cacaview
/usr/bin/caca-config
/usr/bin/cacaclock
/usr/bin/cacaplay
/usr/bin/cacaserver
/usr/bin/cacademo
```

## Première trouvaille

La première ligne montre mon dossier google drive. L'extension du fichier nous dit que c'est une image, alors utilisons eog (eye of gnome) !

```bash
eog /DRIVE/perso/2015/arthur/caca_papillon.jpg
```

<img class="img_big" src="/coding/a_linux_caca_story/caca_papillon.jpg" alt="caca_papillon">

C'est l'un de mes précédent colocataires, clairemnt pas un caca. Il était très fatigué après une fête, alors j'ai profité de la situation pour me moquer un peu de lui ! `è.é`


## Autres trouvailles

- `_cacache` - Fichiers mis en cache dans différents répertoires home. Il s'agit d'un cache spécifique à chaque utilisateur qui permet aux logiciels de démarrer / s'exécuter plus vite en conservant certaines ressources localement.
- `/usr/share/` - Principalement des données en lecture seule, des exemples de configuration et de code. Meh meh.
- `/usr/include/` - Code et headers. C'est un type de fichier que l'on peut _inclure_ dans d'autres programmes pour les compiler.
- `/usr/lib/` - Bibliothèques dynamiques compilées qui peuvent être soit _linkées_ pendant la compilation, soit _chargées_ au moment de l'exécution. Egalement quelques fichiers de configuration spécifiques par package.
- `/usr/bin/` - Programmes linux spécifiques par distribution... C'est notre mine d'or !


## Exploitation de notre mine d'or

Nous avons des jouets (binaires), il est donc temps de faire joujou !

### cacafire

<video  class="img_big" controls>
  <source src="/coding/a_linux_caca_story/cacafire.mp4" type="video/mp4">
Désolé, votre navigateur ne supporte pas la balise vidéo... Peut-être est-il temps de passer à une nouvelle version ? Chrome / Firefox / ...
</video>

<img class="img_big" src="/coding/a_linux_caca_story/edna_mode.gif" alt="edna_mode">


### cacaview

```bash
cacaview /DRIVE/perso/2018/Louka/avatar_square.png
```

<img class="img_big" src="/coding/a_linux_caca_story/cacaview.png" alt="cacaview">

Encore une fois, un grand merci à _Simon Martineau_ qui a dessiné mon avatar ! `^_^`


### caca-config

Coup d'oeil rapide au manuel et le programme, probablement utile pour les développeurs, mais pas très amusant pour nous... *Soupir*

```
$ man caca-config
caca-config - script to get information about the installed version of libcaca

$ caca-config --help
Usage: caca-config [OPTIONS] [LIBRARIES]
Options:
   [--prefix[=DIR]]
   [--exec-prefix[=DIR]]
   [--version]
   [--libs]
   [--ldflags]
   [--cflags]

$ caca-config --version
0.99.beta19
```

### cacaclock

RTFM (Reat The _Fancy_ Manual) -> Trouver les bonnes polices à utiliser -> Boom, une horloges live avec des polices fun!\
J'ai été un peu trop flemmard pour créer un gif mais croyez-moi, c'est animé ! ;)

<img class="img_big" src="/coding/a_linux_caca_story/cacaclock.png" alt="cacaclock">


### cacaplay & cacaserver

Le premier outil peut être utilisé pour lire des fichiers .caca. Je ne l'utiliserai ici mais n'hésitez pas à parcourir le web et à m'envoyer votre meilleur .caca!\
S'il vous plaît, pas de photos de caca. Vraiment, non.

Le second est destiné à servir des animations de caca. Différents clients peuvent s'y connecter à l'aide de `telnet` ou `netcat` et profiter de ces animations sans avoir ce logiciel !


### cacademo

Le dernier mais pas des moindres, le programme démo pour les meilleures animations .caca !

<video  class="img_big" controls>
  <source src="/coding/a_linux_caca_story/cacademo.mp4" type="video/mp4">
Désolé, votre navigateur ne supporte pas la balise vidéo... Peut-être est-il temps de passer à une nouvelle version ? Chrome / Firefox / ...
</video>


## La licence

Une fois de plus, le manuel nous dit:

> cacademo  is  covered  by  the  Do What the Fuck You Want to Public License ([WTFPL](https://fr.wikipedia.org/wiki/WTFPL)). cacafire is covered by  the  GNU  Lesser  General  Public  License ([LGPL](https://fr.wikipedia.org/wiki/Licence_publique_g%C3%A9n%C3%A9rale_limit%C3%A9e_GNU)).

Sympa comme nom de licence hein?\
Eh bien ce sont tout de même des licences tout à fait valides !

Plus d'informations sur la façon de choisir la vôtre [ici](https://choosealicense.com/)

Comme toujours, j'espère que vous avez apprécié lire cet article. Personnellement, je suis toujours étonné de constater que les gens très futés passent `beaucoup` de temps à écrire ce genre de logiciels complexes et _"inutiles"_, à les documenter, à y contribuer, à les rendre publics, à les licencier et... Les inclure dans nos distributions !

La prochaine fois que vous trouverez quelque chose d'un peu étrange, de bizarre, consacrez-y un peu de temps, qui sait ce que vous pourriez finir par trouver ! ツ

> Je suis venu pour chercher la merde, mais je n'ai malheureusement trouvé que de l'or ! - Laluka 2019
