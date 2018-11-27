---
author: "Laluka"
title: "Raisonner sans prise de tête "
slug: "raisonner_sans_prise_de_tete"
date: 2017-03-07
description: "Raisonner n'est pas simple et mène souvent à se prendre la tête voir bloquer. Voici donc quelques méthodes personnelles et conseils qui vous permettront je l'espère de mieux vivre ces phases de recherche. "
---

Alors aujourd'hui, je vous propose une petite prise de recul sur la manière d'aborder un problème, une recherche, ou encore... La vie de manière générale ?


## Prologue

Ce que je vais vous dire ici est à mes yeux du "bon sens", mais j'ai quand même galéré un bonnn moment avant d'adopter ces quelques méthodes, et encore, parfois j'oublie de les utiliser et me mélange les pinceaux / regrette amèrement.

Ces quelques méthodes pourront vous servir dans vos études (coucou les maths et la physique qui piquent !), dans votre boulot (coucou l'administration, la comm', la recherche, ...), ou encore dans votre passion (coucou les challenges de hacking qui prennent des jourssss <3 ).

<img class="img_med" src="/the_rest/thinking/head.png" alt="head">

## HowTo

Ce que j'ai, ce que je veux, ce dont j'ai besoin entre les deux
Le nom de ce premier point est assez explicite, un nouveau problème ? Une nouvelle question ?

Reflex !

-Je prends de quoi écrire, je marque toutes les informations, les moyens dont je dispose en premier lieu.

-Je marque en bas de feuille (papier, word, .txt, whatever...) ce à quoi je veux parvenir.

-Je marque les possibles étapes intermédiaires qui peuvent servir de 'point de sauvegarde', pour savoir ce qui a été validé ou non, et par quels chemins l'on peut passer pour accéder au même résultat.

Tout écrire, classer, trier, conclure
Assez clair également mais au cas où...

Cette étape consiste à noter chaque tentative, succintement, pour savoir ce qui a été fait ou non, ce qui a pu fonctionner ou non. Une fois ces informations receuillies, les trier par petits groupes, et essayer d'en tirer des conclusions, des généralisations, mais en gardant toutes les informations.

Descendre d'un niveau d'abstraction, comprendre, remonter
Oui ! Wait... What ?

Celle-ci est un peu cachée, peut être expliquée, mais on la comprend bien mieux avec un exemple.

Prenons des maths, mais des gentils, comme ça on ne fâche personne, ok ?

Je donnais souvent des cours à des élèves du collège au lycée, et une question qui revenait très souvent était la suivante : Comment ça marche les puissances ?

Je posais alors une simple ligne au tableau :

x^2*x^3 = ?

"Mais justement, je veux savoir comment ça marche moi, pas échouer au tableau...

-Mais... Tu le sais déjà, comment ça marche, crois-moi ! x^2, c'est quoi ?

-x*x

-Oui, et x^3, c'est quoi ?

-x*x*x

-Très bien, maintenant, et si tu remplaçais ce que tu ne connais pas par ce que tu connais ? "

Apparait alors au tableau : x*x*x*x*x

"Et ça... Tu sais ce que c'est non ?

-Oui... C'est x^5...

-Bien ouej maggle, mtn vas faire ce que tu veux de ta vie sans te prendre la tête avec ça ! =D "

Et c'est exactement ce que veut dire cette première phrase barbare. Prendre ce que je ne connais pas, retourner voir les définitions, le comprendre, et assembler les petits morceaux jusqu'à comprendre le fonctionnement des objets de départ. Et ce qui est bien avec cette technique, c'est qu'elle marche avec absolument tout ! Notre monde étant fait de plein de petites briques empilées les unes sur les autres, que ce soit en science, philo, socio, ...

Sa seule faiblesse, c'est les dépendances circulaires, où quand la définition de A envoie à B et celle de B renvoie à A... Et dans ces cas-là...

Program received signal SIGSEGV, Segmentation fault.

Faire des schémas
Les schémas, ça sauve des vies.

Chaque jour, chaque heure, chaque minute de votre vie que vous passez à ne pas faire un schéma, des extrémistes (religieux comme athées tkt...) tuent des chatons pour vous faire comprendre à quel point c'est mal.

Faire des schémas, c'est se donner une chance de visualiser ce qu'il se passe, repérer facilement une erreur de raisonnement, mesure, logique, ...

Un petit tour sur la chaine youtube ThreeBlueOneBrown vous permettra de voir que c'est beau, utile, et souvent nécessaire à une bonne compréhension (surtout en math, physique, info, ...)

On ne peut pas tout connaître, mais on peut tout chercher
Eh oui, on vit dans un monde ou une multitude de gens cherchent (et trouvent) dans tous les sens depuis déjà très longtemps. Donc partir du principe que l'on peut tout savoir, tout trouver, c'est irréaliste, prétentieux même. Donc pour chaque projet, chaque nouveau défi, la phase de recherche d'informations, de ce qui a été fait, de ce qui est faisable ou non est crucial.

Petite citation d'OWASP (free and open security community) :

"The first phase in security assessment is focused on collecting as much information as possible about a target application. Information Gathering is the most critical step of an application security test. The security test should endeavour to test as much of the code base as possible. Thus mapping all possible paths through the code to facilitate thorough testing is paramount."

Back-check et auto feedback
Back-check : Vérifier que le résultat obtenu est cohérent, suivant les cas, cela peut être :

- "Est-ce que mon résultat est bien l'objectif de départ ? "

- "Ais-je un résultat dans la bonne unité ? Bon ordre de grandeur ? Bon type ? Réaliste ? "

Ceci permettra aux étudiants de faire une petite conclusion annonçant fièrement : "J'ai fait ça, mais j'ai assez de recul pour savoir que c'est faux ! Quelques points s'iouplai ! °^° "

Et aux autres de revoir leur démarche avant de se lancer dans la suite des opérations avec un départ bancal, donc gain de temps, énergie, etc etc...

Auto feedback : Une fois le raisonnement arrivé à son terme, prendre des notes sur ce qu'on a pu bien ou mal faire, les petits détails qui nous ont échappé pour y porter plus attention au prochain coup.

Exemple : Durant un CTF, lorsqu'un challenge me fait télécharger des fichiers à analyser / exploiter, j'ai tendance à foncer sur le contenu du fichier, et j'ai déjà perdu des jours et des jours dans une fausse piste alors que l'indice était tout bêtement dans le nom, ou la date de création du fichier. Je me suis fait avoir deux fois sur ce point avant de me dire "Oops, l'auto feedback... :x "

Maintenant, je sais que j'ai ce problème régulièrement, donc c'est ce que je vérifie en premier... ^.^

Savoir demander de l'aide
Eh oui, parfois, même avec toutes ces bonnes pratiques, quand ça veut pas, ça >veut< pas. Donc savoir demander de l'aide est essentiel, mais pas toujours facile. Déjà, il faut oser. Mais même en osant, il y a plein de points à vérifier avant de faire sa demande.

MUST :

- Expliquer le problème avec précision en précisant ce qui est bloquant ou non

- Faire attention à ce qui est divulgable ou non (projet confidentiel, spoil de challenges, ...)

- Expliquer ce qui a été tenté ou non, et ce que les tentatives ont donné comme résultat

- Donner le contexte des tests (OS ? Logiciel ? Lieu ? Axiomes de départ ? Tout ce qui peut affecter la recherche ou le résultat en fait... Cas insoupçonné : l'heure ! :D)

- Rester poli et courtois, toujours, et remercier du temps consacré, que l'aide ait été utile ou non... :)

MUST NOT :

- "Sa march pa, de tt fason je compren pa. "

- "Tu peux me donner la réponse ? "

- "Tu peux le faire pour moi ? "

- "J'ai tout tenté, donc c'est que c'est l'exo qui est faux" -> Du vécu... Oops partiel de Java... :<

- Spammer quelqu'un en attente d'aide, il faut savoir se raisonner, bloquer un moment avant de demander... (Coucou Cyril, once again, sorry... :> )

Epilogue :

Voilà, avec ces quelques méthodes, vous voilà un peu mieux armé(e) pour la suite !

L'idée, ce n'est pas de les appliquer à la lettre, mais de les avoir comme 'guide' et de pouvoir s'appuyer dessus quand on patine, en sautant de l'une à l'autre jusqu'à ce que le problème se débloque de lui-même, et le plus souvent, ça marche !

Je ne dis en aucun cas que c'est l'unique approche à utiliser, car il y a bien des cas où elle ne peut ou ne doit s'appliquer, mais elle m'a tellement servie que je ne peux que vous conseiller de la garder en tête pour le moment propice ou elle vous permettra de ne pas vous noyer devant une tache un peu ardue.

En vous souhaitant de donnes non-prises de tête,
