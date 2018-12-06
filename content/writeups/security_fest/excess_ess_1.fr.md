---
author: "Laluka"
title: "Excess ess 1"
slug: "excess_ess_1"
date: 2018-06-04
status: "traduit"
description: "Un challnge web sur a sur une XSS, résolu pendant le SecurityFest CTF 2018. Il s'agit de trouver un bypass pour exécuter la fonction alert après qu'elle ait été supprimée."
---

Ce défi intitulé "Excess Ess 1" est un jeu de mot (phonétique) pour désigner XSS. C'est une attaque qui consiste à forcer le navigateur de notre victime à exécuter du code (la plupart du temps du javascript) sans son consentement. Ce défi a été proposé par l'édition 2018 du SecurityFest CTF.

## L'objectif
La plupart du temps, pour prouver qu'une XSS est possible, le hacker utilise une payload qui appelle la fonction alert. C'est ici exactement ce qu'on nous demande de faire. Nous commençons donc par introduire un simple texte pour voir s'il est reflété dans la page Web. On réalise vite que le mot-clé est reflété comme une variable dans du javascript, utilisé dans notre page.

<img class="img_full" src="/writeups/security_fest/recon.png" alt="recon" >

L'étape suivante est de forcer la page à exécuter notre code. On essaye dans un premier temps avec la fonction console.log après avoir fermé la première affectation de variable, et en commentant ce qui vient après. On essaye (cf l'URL), et PAF ! Le navigateur log 3, donc nous pouvons exécuter du javascript !

<img class="img_full" src="/writeups/security_fest/inject.png" alt="inject" >

## La protection
Ensuite, nous essayons d'utiliser la payload alert(1) pour valider le défi, mais... Oopsy !

<img class="img_full" src="/writeups/security_fest/prompt.png" alt="prompt" >

Tout ce qu'on a en retour, c'est un prompt. La raison de ce comportement est qu'un script est chargé et exécuté avant notre notre payload. En récupérerant son contenu on comprend que la fonction alert a été remplacée par la fonction prompt.....

<img class="img_full" src="/writeups/security_fest/ascii_art.png" alt="ascii_art" >

Donc... Nous ne l'avons plus ? Comment l'utiliser en ce cas ?

## Le bypass
J'ai vu il y a quelques mois une vidéo de LiveOverflow à ce sujet. Il s'agissait de reverser d'un module de pop-under javascript qui aide des b*t*rds à faire apparaître des publicités sous notre fenêtre actuelle, pour que cela nous prenne plus de temps à réaliser et  fermer, leuf faisant ainsi gagner plus d'argent. Meh.

Plusieurs des fonctions nécessaire aux attaquants pour faire apparaître la fenêtre en dessous de celle en cours d'utilisation étaient blacklistées, ils ont donc crée une iframe (En gros, une nouveau page web dans la fenêtre actuelle). La création de l'iframe offre un nouveau contexte, récupère toutes les fonctions principales pour être sûr que le site qui sera chargé dans ce cadre sera fonctionnel. Gràce à cela, nous retrouvons aussi la fonction alert. Nous pouvons alors soit réassigner notre fonction d'alerte, soit simplement l'appeler depuis l'iframe ! N'est-ce pas magnifique ? =D


## La solution
```html
/?xss='; <!-- Echapper notre payload -->
```
```javascript
i = document.createElement("iframe");
i.onload=function(){
    i.contentWindow.alert(1);
};
document.getElementsByClassName('container')[0].appendChild(i);//
```

La payload finale à envoyer est donc :
```html
http://xss1.alieni.se:2999/?xss=';i=document.createElement("iframe");i.onload=function(){i.contentWindow.alert(1);};document.getElementsByClassName('container')[0].appendChild(i);//
```

<img class="img_full" src="/writeups/security_fest/alert.png" alt="alert" >

## Conclusion
Utiliser un système de blacklist est (la plupart du temps) une mauvaise idée, en particulier avec javascipt / python / SQL / .... parce qu'il y a tellement de façons de contourner les mots-clés bloqués, éditer ou recréer des objets et fonctions facilement, que ce type de sandboxing / protection n'est pas assez efficace.

Même si ce trick n'est pas nouveau pour moi, je n'ai jamais eu l'occasion de l'utiliser avant, donc c'était plutôt cool de l'essayer par moi-même et de réaliser qu'il est efficace, facile à utiliser et amusant !

Plus tard au cours de ce CTF, une deuxième version de ce défi a été publiée, "Excess Ess 2". J'y ai passé quelques heures. Nous contrôlions les champs dans une balise meta, mais pas leur contenu. Si vous connaissez un moyen d'exploiter un XSS dans une balise meta, avec un contrôle partiel, sans utiliser `<>` pour créer une nouvelle entity, et sans écraser l'attribut content, dites-le moi, je serai ravi de le savoir !

En espérant que vous ayiez aimé ce write-up,\
Passez une bonne journée ! ^.^
