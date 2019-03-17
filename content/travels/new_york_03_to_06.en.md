---
author: "Laluka"
title: "New York, Datadog and I - Week 3 to 6"
slug: "new_york_datadog_and_i_week_3_to_6"
date: 2019-03-16
status: "original"
description: "Third article about my trip to New-York. Datadog parties, cool rooftop, visiting with Marine, api endpoints sanitization, vagrant and ansible, finding a home AGAIN... And pics!"
---


# Datadog parties

A few times a month, parties are organized either at work, or in cool places nearby by the company.
So fare, I joined three times. Once to taste some whiskey, once to build our own terrarium and eat hand-made sushis, and once to go to a big-games bar. And every event was a huge success! :D

<img class="img_big" src="/travels/new_york_03_to_06/sushi.jpg", alt="sushi">
<img class="img_big" src="/travels/new_york_03_to_06/plant.jpg", alt="plant">

There are many interns, and the vibes are always chill / funny. I used to make fun of corporate culture, but in the end... It's not that bad when it's done the right way!

<img class="img_big" src="/travels/new_york_03_to_06/party_pics.jpg", alt="party_pics">

The games were pretty cool and so was the music (house / EDM), but damn, playing ping-pong midly drunk is hard!

<img class="img_big" src="/travels/new_york_03_to_06/party_pup_ping_ping.jpg", alt="party_pup_ping_ping">
<img class="img_big" src="/travels/new_york_03_to_06/party_pup_connect_four.jpg", alt="party_pup_connect_four">


# Game-night and rooftop

I've been invited by a friend to have a video-games night with her friends. We played a bit, enjoyer the -delicious- cocktails done by her boyfriend, and then went to a rooftop bar. It was entertaining, classy, but sadly, WAY TOO COLD outside to stay for long.

<img class="img_big" src="/travels/new_york_03_to_06/rooftop_mirror.jpg", alt="rooftop_mirror">
<img class="img_big" src="/travels/new_york_03_to_06/rooftop_outdoor.jpg", alt="rooftop_outdoor">

But the best part was... The urinals! You're in a good mood, had a few drinks, need to take a break, and you go in the restroom to find this super-cute candle-lighted place. How cute and unexpected is that? :')

<img class="img_big" src="/travels/new_york_03_to_06/rooftop_urinal.jpg", alt="rooftop_urinal">


# Visiting with Marine

It's all in the title: Marine came from the 1st to 10th of March. We visited many places and walked quite a lot even tho it was freezing outside. Every tourist take the same pictures, it's quite lame, don't you think? Well, I do. But hey who cares, here are ours! `¯\_(ツ)_/¯`

<img class="img_big" src="/travels/new_york_03_to_06/liberty_cliche.jpg", alt="liberty_cliche">
<img class="img_big" src="/travels/new_york_03_to_06/liberty_hug.jpg", alt="liberty_hug">

A few months ago, we saw this cool Netflix show 'Atypical' about an autistic teenager trying to figure out how life and relations work. There's a scene where he smiles, and someone explains him calmly and seriously that his smile should be only 70% of his current one to look great. In the show, he smiles... A bit like us (sadly, we're not as good as this actor). So this became our thing: If you don't look good enough, smile as hard as you can and hopefully you'll look weird enough to make the picture great again!

Anyway, if you haven't seen this show, you should give it a try! ;)

<img class="img_big" src="/travels/new_york_03_to_06/autistic_smile.jpg", alt="autistic_smile">

We went to times square, and also to the Top Of The Rock (mid-high building in front of Central Park). If was freezing in the street but once up there, there was no wind because of the glass panels, and the sun was hitting hard so it was really pleasant to stay for a while. And if you zoom a bit you'll notice... SMILE! :D

<img class="img_big" src="/travels/new_york_03_to_06/times_square.jpg", alt="times_square">
<img class="img_big" src="/travels/new_york_03_to_06/totr_smile.jpg", alt="totr_smile">

While going to the One World Trade Center (building constructed after the fall of the twin towers), we saw this gigantic monster, which is a shops + metro station place. Its looks crazy, it's huge outside, and even bigger inside!

<img class="img_big" src="/travels/new_york_03_to_06/monster_out.jpg", alt="monster_out">
<img class="img_big" src="/travels/new_york_03_to_06/monster_in.jpg", alt="monster_in">

Then we took a break to go to a Korean SPA. We were a bit sick because of the weather, so the warmth was more than welcome. The view we had on New-York while in the extra hot swimming pool was super nice, but we were really shocked to realize that most of the folks in here were only posing and taking pictures. I mean, we took a bunch of pics for the memories, but some stayed for hours just taking the same picture over and over of themselves in the same pose, they seemed to not even care about the pool / sight, just the social-media fame, and it was... Strange...

<img class="img_big" src="/travels/new_york_03_to_06/spa_her.jpg", alt="spa_her">
<img class="img_big" src="/travels/new_york_03_to_06/spa_him.jpg", alt="spa_him">

A friend of mine joined us to visit the Natural Museum of History. We were a bit tired but really happy to follow him and see how amazed he was. I think that I liked the most this day was him and his happiness and not the museum itself! Julien, if you read this, don't change a thing, stay the grown-up child that you are, you rock! `^.^`

<img class="img_big" src="/travels/new_york_03_to_06/carayol.jpg", alt="carayol">
<img class="img_big" src="/travels/new_york_03_to_06/badass_tree.jpg", alt="badass_tree">

Last but not least, here's an extra-classy picture of New-York she took the first day:

<img class="img_big" src="/travels/new_york_03_to_06/black_white_nyc.jpg", alt="black_white_nyc">


# Work related

Weeeeell, life's cool, but work matters too... Right?
I've been working on two main things:

### API endpoints input sanitization

Input sanitization is something important wherever you go, whatever you do. It basically means "Check that no one gives you erroneous nor malicious data". In life, we care: not eating rocks instead of fruits, not letting random people come in your house, or even wearing a condom. What comes inside needs to be whitelisted. It's exactly the same idea in security. Every time someone submits data to us, we sanitize it to be sure everything will be fine and that we're not attacked. To do so, we mainly use (in this project, as far as I know) a json schema that describes the expected inputs, and then we match the request data against it. If the request is malformed, we reject it.

While checking how some checks were done, I realized that the email validation only consisted in dummy checks.

```python
def validate_email(email):
    return isinstance(email, str) and "@" in str
```

I really felt like "WTF, this isn't enough AT ALL" and tried to create a pull request to improve that, but while digging in this github repository, I saw a closed issue on this topic, and this is what I found: A mind-blowing 5mn read! Have fun, it's gold-certified material.

https://hackernoon.com/the-100-correct-way-to-validate-email-addresses-7c4818f24643


### Automated deployment of a vulnerable web-application

The work done here implies many pre-existing private repositories used in Datadog, so I can't explain everything, but it basically implies terraform scripts that will setup AWS accounts for us. The part I worked on was mainly using Ansible and Vagrant for cookbooks and local testing.

Vagrant is a virtualization software that one can use for many things:

- Have a coding / hacking environment setup on any OS
- Have a VM that you can crash and trash anytime
- Do some infrastructure testing with many hosts
- So much more, honeypot, software behavior analysis, ...

Ansible is a super cool tool that helps you provision automatically different services and files on a local or remote system using cookbooks. Cookbooks contains just the description of what needs to be done, ansible does the rest, so it feels like "Configuration File As An Infra". It's super convenient and the code-base is pretty clean as it's developed by RedHat.

Here are some useful / interesting resources about them:

- https://www.vagrantup.com/
- https://www.ansible.com/
- https://sysadmincasts.com/episodes/43-19-minutes-with-ansible-part-1-4
- https://sysadmincasts.com/episodes/45-learning-ansible-with-vagrant-part-2-4
- https://sysadmincasts.com/episodes/46-configuration-management-with-ansible-part-3-4
- https://sysadmincasts.com/episodes/47-zero-downtime-deployments-with-ansible-part-4-4


# Finding a home AGAIN

My roommate boss had money. A lot of it, but it seems that he lost most of it in stock exchanges. So he `had` money. Thus his private pilot, cook and probably others employee has been fired. Adrian seems to be OK with that as he really likes nature, and New-York definitely isn't a great place for him, so he's on the road again, soon traveling around the world!

But this means for me that I have to either find a new roommate as soon as possible or leave the apartment by 1st of April. This sucks, I want to keep this place, so... If you know anyone looking for a peaceful and beautiful place to say near New-York... Let them know... M'okay?


# Random thoughts

Wherever you are, visio-conferences can and will fail at some point. It's super funny to have 30 engineers trying to fix a TV all together with live tips and laughs from remote workers!

<img class="img_big" src="/travels/new_york_03_to_06/video_conf.jpg", alt="video_conf">

While traveling to White plaines, I missed my train stop and arrived right to Valhalla. It felt really strange to miss a stop and reach valkyries paradise just like that in 5 minutes!

<img class="img_big" src="/travels/new_york_03_to_06/valhalla.jpg", alt="valhalla">

Later that day, we went by a painting course where some gems were waiting for us.

<img class="img_big" src="/travels/new_york_03_to_06/art.jpg", alt="art">
<img class="img_big" src="/travels/new_york_03_to_06/bob_ross.jpg", alt="bob_ross">

I hope that you had a great day / week / month, and if you did not, remember that for at least one people in earth,

<img class="img_big" src="/travels/new_york_03_to_06/one_in_a_melon.jpg", alt="one_in_a_melon">

See you soon and take care! ;)
