---
author: "Laluka"
title: "CSAW - Short Circuit"
slug: "short_circuit"
date: 2018-09-16
status: "traduit"
description: "Challenge hardware sur papier ! Cette épreuve consiste à récupérer l'état interne d'un (simple) cirtuit imprimé (dessiné), bit par bit, puis d'encoder le résultat en ascii. "
---


### Description

> Commencez à la patte du singe et descendez la ligne à haute tension,
pour chaque fil branché a un élément, prenez une valeur on ou off. Ignorez la première partie. Format de flag standard.

> -Elyk


### TL;DR

Ce challenge consiste en l'analyse d'un superbe schéma électronique. \
Il est composé de diodes, de fils, de fils, de fils, de fils et de fils. \
Le but est d'extraire des bits de données du circuit.

Cette épreuve n'était pas très complexe, mais si vous avez une mauvaise vue, vous allez passer un mauvais quart d'heure.


### Methologie

Peu de choses à savoir, voici les clés :

  - Si une diode est fixée au VCC sur son côté plat et 0 (aka GND) sur son côté pointu, elle sera __ON__.
  - Si c'est le contraire, elle sera __OFF__ (ouep, le sense compte !)
  - Si l'entrée et la sortie sont reliées au même fil, elle est __OFF__.

<img class="img_full" src="/writeups/csaw_2018/short_circuit/paper.png" alt="paper" >

En utilisant ces règles, on extrait les bits un par un, avec nos yeux en galère, et on obtient finalement :

`01100110 01101100 01100001 01100111 01111011 01101111 01110111 01101101 01111001 01101000 01100001 01101110 01100100 01111101`

Une fois décodé : __flag{owmyhand}__
