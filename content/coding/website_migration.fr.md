---
author: "Laluka"
title: "Migration de ThinkLoveShare"
slug: "website_migration"
date: 2018-12-08
status: "traduit"
description: "Brève introduction aux technologies utilisées pour créer et maintenir ce site web et quelques mots sur les raisons pour lesquelles j'ai changé. "
---


## Pourquoi changer ?

J'écrivais de temps en temps sur [thinkloveshare.blogspot.com](https://thinkloveshare.blogspot.com) qui sera bientôt mis hors ligne, remplacé par [thinkloveshare.com](https://thinkloveshare.com). J'ai décidé de changer pour plusieurs raisons, en voici l'histoire :

 * Format du code

 Il n'y avait pas de moyen facile d'afficher des extraits de code. J'aurais pu ajouter quelques pretty printers, mais je manquais de temps, donc au lieu de cela, je mettais juste des captures d'écran, ce qui est... Probablement le pire choix possible... =]

 * Hébergement de fichiers divers

 Pour la série sur le pwn, je voulais héberger les binaires vulnérables mais je n'ai pas pu les stocker sur le blog directement. L'utilisation de liens externes signifie qu'un jour ils peuvent (vont) expirer, et je n'aime pas trop ça. J'ai déjà perdu des jours à chercher *ce bon vieil outil / sample* qui n'est plus disponible sur internet, et tout ce qui reste trouvable est une poignée de liens morts.\
 **GRLANKHJDAKNKBJAFHLIFAJK** :@

 * Flexibilité et Gestionnaire de contenu

 Le gestionnaire de contenu n'était pas si mauvais, mais ce n'était pas vraiment agréable à utiliser non plus. De plus, il n'y avait que quelques fonctionnalités de base sur l'interface web... La structure du site n'était pas facilement personnalisable, donc toute cette solution était potable, mais seulement temporaire.


## Nouvelles technologies

 * [OVH](https://www.ovh.com) - nom de domaine

Première étape, enregistrer le nom de domaine `thinkloveshare.com` chez OVH et le configurer pour qu'il pointe sur `thinkloveshare.github.io`, puis utiliser les serveurs github pour résoudre le nom de domaine.

<img class="img_full" src="/coding/website_migration/dns_ovh.png" alt="dns_ovh">

 * [Github Pages](https://pages.github.com/) - hébergement

Ensuite, créer un nouveau compte github (`thinkloveshare`, vu que le nom sera utilisé dans l'URL du site par défaut) qui contiendra les sources et le contenu du site. Le site Web est alors servi à `thinkloveshare.github.io` et `thinkloveshare.com` mais n'a pas encore de contenu.

<img class="img_full" src="/coding/website_migration/github_pages.png" alt="github_pages">

 * [Hugo](https://gohugo.io/) - générateur de site web

Troisième étape, utilisez les templates, les règles et le contenu (ici [toml](https://github.com/toml-lang/toml) et [markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)) pour générer un site Web statique fonctionnel (html5, css3, js, ...) avec Hugo.

<img class="img_big" src="/coding/website_migration/hugo.png" alt="hugo">

 * [Hyde-Hyde](https://github.com/htr3n/hyde-hyde) - thème du site web

Quatrième étape, passer du temps à ajuster le thème Hyde-Hyde qui est vraiment clean et fonctionnel, prêt à l'emploi out of the box. Leur team a vraiment fait un super taff !

 * [Bash](https://www.gnu.org/software/bash/) - automatisation

Cinquième étape, créer deux scripts bash afin d'automatiser le processus de débug et de publication. Je ne suis pas un 'bon' développeur, mais ils font le taff !
[hugo_server.sh](https://github.com/ThinkLoveShare/sources/blob/master/hugo_server.sh) &
[hugo_publish.sh](https://github.com/ThinkLoveShare/sources/blob/master/hugo_publish.sh)

 * [Deepl](https://deepl.com/translator) - traductions

Et enfin, l'ingrédient magique, un super traducteur pour accéléter la traduction, car j'avais beaucoup de contenu à traduire et peu de temps pour le faire. Les articles sont toujours corrigés après la traduction automatique parce que Deepl n'est pas infaillible, mais il fait **vraiment** un taff incroyable.

Petite info, les articles sont rédigés en français ou en anglais selon le sujet et traduits par la suite. La plupart des articles informatique en anglais, le reste en français.


## Exemple pratique

Voici les étapes à suivre pour publier un nouvel article

 * Créer / Modifier le contenu
 * Débug en local

<img class="img_full" src="/coding/website_migration/workflow.png" alt="workflow">

 * Commit et publier

<img class="img_full" src="/coding/website_migration/publish.png" alt="publish">

## Derniers mots

Ce sont des technologies vraiment bien faites et agréables à utiliser, donc plus de fun et de contenu à venir ! ;)\
Si vous avez des questions ou des remarques, n'hésitez pas à utiliser le système de commentaires proposé par [disqus](https://disqus.com/)!\
Au fait, je vous traque en utilisant [Google analytics](https://analytics.google.com/)...\
Désolé ! `¯\_(ツ)_/¯`
