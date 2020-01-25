---
author: "Laluka"
title: "New York, Datadog et moi - Semaine 1"
slug: "new_york_datadog_et_moi_semaine_1"
date: 2019-02-09
status: "translated"
description: "Premier article sur mon voyage à New-York. Pourquoi, où, quand, avec qui, ce qui m'a surpris, comment ca se passe... Et photos !"
---

# Avant de commencer...

Vous avez été beaucoup (je ne m'attendais pas à tant pour être honnête) à me demander des nouvelles. J'aimerais vraiment passer des heures à parler avec chacun d'entre vous, mais avec tout ce que j'ai à gérer pendant la première semaine (inscriptions à l'administration, ouverture de compte bancaire, trouver des repères, commencer à travailler, me socialiser un peu, récupérer un peu de sommeil, ...) et le fait que je n'ai pas encore le bon forfait téléphonique. Plussss le __petit__ laps de temps où nous sommes éveillés en même temps, je ne peux pas, c'est 'un peu' trop pour l'instant.

C'est pourquoi je vais tout écrire ici pour que vous puissiez le lire quand vous en aurez le temps, et qu'il nous reste du temps pour parler de choses et d'autres, et pas seulement pour que je répète la même chose encore et encore.

Makes sense ? Cool !

Si vous lisez cela, il y a de fortes chances que vous soyez quelqu'un à qui je tiens beaucoup, alors des bisous, passez une bonne journée, et souvenez-vous que je vous aime très fort même si je suis loin ! ;)


# Datadog à New-York, pourquoi et comment

Donc, comme vous le savez _peut-être_, je suis dans le hacking depuis juillet 2017. J'y ai trouvé une vraie passion et j'ai passé __beaucoup__ de temps à apprendre et pratiquer. \
Durant ce voyage initiatique, j'ai rencontré beaucoup de gens formidables avec qui j'ai pu partager des sessions de hack, des idées, demander de l'aide ou encore en donner. L'un des hackers les plus bad-ass que je connaisse est [Geluchat](https://twitter.com/Geluchat). Il est vraiment très bon quand il s'agit de casser des choses, et aime aussi partager ses connaissances, principalement sur son site web [DailySecurity](https://www.dailysecurity.fr/). \
Il a entendu parler de ces possibilités de travail à Datadog (grâce à ses amis) et comme il savait que je cherchais un stage, m'a contacté et....

Le processus de recrutement a pris un peu plus d'un mois.

- Entretien : Ressources humaines et explications
- Entretien : Présentation de l'entreprise + questions techniques sur la cybersécurité / exercices de prog
- Entretien : Questions techniques de cybersécurité / exercices de prog
- Test d'intrusion en boîte noire d'une application web
- Entretien : Sujet du stage avec le chef d'équipe de sécurité
- Entretien : "Vous avez été engagé !"


# Le voyage

Datadog a des points de présence dans le monde entier, mais j'ai postulé à New-York, parce qu'un ami de Geluchat y était déjà, et aussi parce que j'étais vraiment curieux de découvrir cette ville, du mode de vie américain etc. Alors.... Me voilà, en route pour Manhattan !

<img class="img_big" src="/travels/new_york_01/bags.jpg" alt="bags">

Pour y aller, j'avais deux jours entre la fin de mes examens et le début du stage. Deux jours pour déménager toutes mes affaires de Valence (FRANCE) vers un endroit sûr et rejoindre Manhattan (USA). C'était assez rude... Mais surtout parce que nous avons dû faire face à des chutes de neige, à des manifestations des gilets jaunes en France et à des malentendus entre mon hôte sur NYC et moi.

<img class="img_big" src="/travels/new_york_01/airport.jpg" alt="airport">

J'ai pu passer quelques heures avec ma tante pendant mon séjour à Paris, et comme je vais aussi utiliser ces articles comme souvenir, je vais y déposer des photos au hasard de temps en temps. Enjoy ma fatigue ! :p

<img class="img_big" src="/travels/new_york_01/aunt.jpg" alt="aunt">

Voici une photo de la première personne  à qui j'ai parlé aux Etats-Unis, il m'a aidé à trouver un wifi gratuit, à réserver un Uber et à trouver où je devais le rejoindre (l'aéroport d'EWR est assez grand... Oopsy !).

<img class="img_big" src="/travels/new_york_01/first_guy.jpg" alt="first_guy">


# Le taff

La description du poste est la suivante :

 > Tout d'abord, vous apprendrez l'application Datadog et vous vous familiariserez avec les différents workflows utilisés par les équipes de développement et sécurité. Vous participerez ensuite aux revues de code et de conception, en travaillant en étroite collaboration avec les équipes de développement pour vous assurer que la sécurité est incluse dans le cycle de vie du développement logiciel. Vous continuerez à créer et à maintenir des logiciels d'analyse de code et des frameworks de test automatisés ainsi qu'à contribuer directement au code des serveurs de production pour détecter ou bloquer les attaques au niveau des applications. Les technologies que vous utiliserez pendant cette période incluent (mais ne sont pas limitées à) AWS, GCP, Kubernetes, Docker, Terraform, Python, Go, Github, Gitlab, Serverless.


TL;DR : Revoir leur code et leur processus de développement afin d'éviter de se faire pwn. Les technologies utilisées sont des technos que je connais déjà ou que j'avais l'intention d'apprendre. La meilleure partie ? Ils fonctionnent tous sur des ordinateurs Apple. Bon, ce n'est pas un pur LINUX, mais au moins nous n'utilisons pas de Windows toute la journée, donc c'est __COOL__.


# Jour 1

Des tonnes de conférences :

<img class="img_big" src="/travels/new_york_01/meeting.jpg" alt="meeting">

- Présentation de l'historique de Datadog, pourquoi ils l'ont créé, quel est son taux de croissance etc... Quelle est l'essence de cette entreprise, le mode de vie. (Entreprise très tolérante, assez flexible avec le code vestimentaire, l'horaire, ... Tant que c'est en accord avec notre manager (qui est quasiment toujours quelqu'un de génial !))
- Mesures de sécurité, ce qu'il faut faire et éviter pour rester en sécurité, ...
- Intégration informatique : Réception d'un macbooks pro et configuration du __vaste__ écosystème qu'ils utilisent. C'est principalement l'ensemble de la suite   de Google (drive, docs/sheet/slide, agenda, et bien d'autres (50+ applications) mais ne sachant pas exactement ce que je peux partager ou non... L'idée générale est d'utiliser le compte google comme compte principal pour du SSO, et d'y lier tout ce qui est possible pour le rendre complet.
- Salaires et avantages sociaux -> Pas d'avantages sociaux pour les stagiaires, mais j'y suis quand même allé pour voir ce dont nous pourrions profiter en tant qu'employé à temps plein et... C'est plutôt énorme !

Chose amusante : il y a des distributeurs automatiques gratuits pour les appareils informatiques, comme les câbles, les claviers, la souris, les Yubikey, etc...

<img class="img_big" src="/travels/new_york_01/vending.jpg" alt="vending">

Nous avons aussi eu l'occasion de visiter les lieux et de rencontrer notre buddy (quelqu'un qui n'est pas dans la même équipe que nous, pour améliorer la communication au sein de l'entreprise, et aussi pour avoir un visage amical à proximité). Voici mon buddy, Piotr, qui est aussi Francais. Il est super sympa, which is nice ! On a des petites choses en vue, comme... Un saut en parachute ! :D

<img class="img_big" src="/travels/new_york_01/buddy.jpg" alt="buddy">


# Jour 2 & 3

Se familiariser avec ce beau lieu et setup des tonnes de logiciels et de comptes. J'ai aussi eu l'occasion de parler avec mon manager et son manager. Chaque réunion équivaut à une belle rencontre, une nouvelle amitié. Suis-je...  au paradis ?

<img class="img_big" src="/travels/new_york_01/place_0.jpg" alt="place_0">
<img class="img_big" src="/travels/new_york_01/place_1.jpg" alt="place_1">
<img class="img_big" src="/travels/new_york_01/place_2.jpg" alt="place_2">
<img class="img_big" src="/travels/new_york_01/place_3.jpg" alt="place_3">
<img class="img_big" src="/travels/new_york_01/place_4.jpg" alt="place_4">


# Pensées diverses

Les avenues new-yorkaises sont si grandes, et si larges, que même lorsqu'elles sont bondées, pleines de voitures, elles demeurent bien moins oppressantes ou stressantes que celles de Paris. C'est très agréable de s'y promener, les bâtiments sont __vraiment__ hauts, mais ce n'est pas non plus un problème car nous avons beaucoup de lumière et de soleil grâce aux larges avenues. J'aime vraiment bien cet endroit ! =]


<img class="img_big" src="/travels/new_york_01/avenue.jpg" alt="avenue">


Nous avons marché un peu jusqu'à Central Park le dimanche après-midi, un petit lac était complètement gelé !

<img class="img_big" src="/travels/new_york_01/frozen_lake.jpg" alt="frozen_lake">


En parlant avec Mateo (colocataire) et Nora (amie de France), nous parlions des sentiments et de la façon dont le sexe est vu par les hommes ou femmes. Du point de vue de l'homme, c'était considéré comme un gun, un coup de feu et c'est terminé, et du point de vue féminin, plus comme un volcan, l'énergie s'accumule avec le temps, puis éruption. Petite perle au cours de la discussion :

> "Ever tried to shoot a volcano with a gun? It wouldn't do shit!"

> "Vous avez déjà essayé de tirer sur un volcan avec une arme à feu ? Ça ferait que dalle !"


<img class="img_big" src="/travels/new_york_01/friends.jpg" alt="friends">


Dernier fait amusant de cet article : Chez Datadog, nous pouvons utiliser cet endroit "comme bon nous semble" 24/7. Cela signifie qu'à tout moment, de jour comme de nuit, en semaine comme le week-end, si je le souhaite, je peux amener des amis ou de la famille prendre un snack ou partager quelques bières en profitant de cette vue magnifique. Elle est pas belle la vie ?!

<img class="img_big" src="/travels/new_york_01/sight_1.jpg" alt="sight_1">
<img class="img_big" src="/travels/new_york_01/sight_2.jpg" alt="sight_2">


# Derniers mots

Comme vous pouvez l'[imaginer](https://www.youtube.com/watch?v=YkgkThdzX-8), j'aime beaucoup la vie ici. Mais vous me manquez tous beaucoup. J'essaierai de donner des nouvelles ici (peut-être un peu plus court quand même) chaque semaine.

Nouvelle vie, nouveau taff, nouveau matériel.... Même équipe ! \
❤ Aperi'Kube ❤

<img class="img_big" src="/travels/new_york_01/gear.jpg" alt="gear">

Passez une bonne jounée, soirée, ou ce que vous voulez, et à bientôt !

<img class="img_big" src="/travels/new_york_01/sunset.jpg" alt="sunset">
