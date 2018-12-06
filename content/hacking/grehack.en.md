---
author: "Laluka"
title: "GreHack 2018"
slug: "grehack_2018"
date: 2018-11-16
status: "original"
description: "GreHack 2018 is an hacking event (conferences and CTF) that takes place each year at Grenoble in France. Last year was the first time I went to an event like that, this year, I bring you in !"
---

## Before I start...

One year ago was my first on-site hacking event : GreHack 2017 !

The conferences were great, I met a few cool people there, and the CaptureTheFlag was awesome, even tho I had almost no knowledge, there's always a starting point huh ? \
I spent the whole year doing my best to gain hacking knowledge, meet people into infosec, solve challenges, join events, conferences, CTFs, ...\
Some were great, but I still had the memories of this awesome event, and thought that the conference were the best (no marketing bullshit, only precise knowledge shared by interesting people). And this year again, the conferences were pretty
neat, and the CTF was great !

A big thank you to the organizers, you rock ! ❤

<img class="img_big" src="/hacking/grehack/chartreuse.jpg", alt="chartreuse" >


## 1st conference : Return of the Gand Crab Ransomware

This ransomware is kind of special because its lifecycle is Agile-like. It contains multiple exploits, 0days, updates, ...\
It is considered as a MaAS (Malware-as-a-Serice) as it provides an easy to use GUI for the customer, the developers take a small cut of the malware profit.
It's spread via maaany ways : js / .doc / macro / vb / fake encrypted CV / open RDP bruteforce via shodan / exploits kits / browser exploits, ...\
It also avoids detection in VMs usning obfuscation techniques, and uses long time execution functions or the VM to close itself before it gets malicious. It uses a custom packer (won in a custom packer contest, that's fun and original !)\
The communication part interacts (in most versions) with a C2 server via TOR.

The last fun thing here is that the developers added the code of "0day" in the code, without using it, just saying (bragging) : "We found a crash, probably something critical, bla bla bla, you are bad and should feel bad."

The reverse engineers that found that laught a lot because : The code triggers the antiviruses even if it's useless and unused, and they're quite sure that this PoC isn't good enough to be turned into an RCE. So... That's a fail ! =]

https://twitter.com/tamas_boczan


## 2nd conference : ROPGenerator - Quarkslab

If you don't know what ROP is, you may want to read this previous article : [PWN 3of4 : SaperliROPette](https://thinkloveshare.com/en/hacking/pwn_3of4_saperliropette/)

The software presented has two main functionnalities : Find ROP gadget that will respond to the constraints you give, and chain gadgets in order to have a fully functionnal ROPchain.

Finding the right gadget can be done in two different ways : \
Syntactic (fast & limited) Vs Semantic (slow & powerful)

* Features

 - Gadget Searching :
Gadgets are used to construct a dependency graphs, the semantic is then extracted, sorted and then stored in a database.

 - Gadget Chaining :
The database previously created is then queried, and strategies are used (aka using temporary registers, computing numbers, ...) to store the right values at the right places. intermediate strategies can be used, this increases the computing time but it still reasonable (few minutes on binaries like bash).

* Demo

 - *downloads a root-me.org binary*
 - *starts the tool : "plz pwn that"*
 - *60 points, less than 5 minutes, done.*

This tool is POWERFUL AF !!!\
Thank you for this gem, I'll definitely use it !

https://github.com/Boyan-MILANOV/ropgenerator


## 3rd conference : Pwning an SAP, then what ?

*_sorry_but_I_hate_sap.* \
*_sorry_but_I_hate_sap.* \
*_sorry_but_I_hate_sap.* \
*_sorry_but_I_hate_sap.* \
*_sorry_but_I_hate_sap.* \

Long story short, SAP are soooo huge that the attack surface is insanely wide. If you plane on pentesting one, get your tools ready, because you'll get through a lot of data. The exploitation isn't that hard tho...

The conference was interesting, but because of some personal issues with SAP softwares... I won't... I won't. Never ever again.


## 4th conference : Abusing privileged file manipulation

Short introduction about the concept of race conditions and examples. Introduces windows specific tricks and softwares to monitor privileges and child processes needed to detect this kind of race conditions.

*Trash talking about antiviruses ! `\o/`*

Awesome presentation pwning AVs, the core idea is that an antivirus uses high privileges to monitor the whole system, and most of the time, isn't sandboxed. Many of them are exploitable by changing the file while they are analysing or removing it. Using links / restore functionnalities, files can acquire full SYSTEM privileges allowing the hacker to take own the system.


## 5th conference : Screaming Channels, when Electromagnetic Side Channels Meet Radio Transceiver

Basically, this guy can hear your cpu scream through his bluetooth antena while doing some crypto encryption. The noise is then used to leaks your AES private key up to 10 meters away. Also he is a good looking metal-head, which is nice ! =]

https://twitter.com/nSinusR


## 6th conference : Trap your Keyboard 101

Attacking a Corsair strace RGB, as it is programmable and has memory... Why not ?\
The firware is updated by downloading the new version in a temp folder. So we can hijack it and reverse it : arm binary with IDA + miasm : \

*[ Quite long and technical talk ]*

Demo time, the crowd is sceptical...

*GOSH MY FUCKING WHAT ?!*

The keyboard has been turned into a record and replay independent device (aka an expensive and good looking Rubber Ducky). \
What this means, is that you can just lend your keyboard to a friend, propose him to test it for few days. And when your keyboard comes back, it contains your friend's password, and the best part : It can type it, with colors, for you !

This talk was tedious (good effort on the english tho), but the work done is VERY clever.\
If you ever read this, you rock !

https://twitter.com/marilafo19


## 7th conference : Analyzing Ultrasound-based Physical Tracking Systems

TL;DR : This apk will decode ultrasound played without you knowing it to sell you useless stuff you don't need. \
An classic smartphone application can scan the audio spectrum continuously waiting for a particular signal using infra sound. This sound will trigger the application, revealing this way your location to the vendor. He will then use your phone to interact with you... In a commercial way... Yay...

This can be mitigated using ultrasonic jamming, but that's quite rare. It can also be easily reverse engineered ans DDOS... =]

https://twitter.com/Cunchem


## 8th conference : Bridging the gap between Secure Hardware and Open Source

Too much hardware, not enough brain left...

https://github.com/LedgerHQ


## 9th conference : Detecting all type of illegal Access Points on enterprise networks

Too tired and preparing for the workshop...

https://twitter.com/qingxp9


## Workshop on Miasm (one among many others proposed)

Excellent introduction to the Miasm reverse engineering framework.

The exercice presented is the following : symbolical execution to resolve a crackme binary. But not on the binary itself, on the intermediate representation generated by Miasm, and solving the constraints using z3 as a solve engine.

If this sounds like deep black magic to your ears... That's pretty normal. But damn, it works, and it's beautiful !

https://github.com/cea-sec/miasm


## On-site CTF

We were only three members of Apéri'Kube present, so we merged with the team [Cryptis](https://twitter.com/TeamCryptis). They were really kind and paticipating with them was a lot of fun ! We're still a bit disapointed because the challenges were mainly focused in reverse engineering, some crypto and hardware stuff. Still some forensic and
some web and crypto, the infrastructure was nice !

Here is a picture of us not solving a challenge :

<img class="img_big" src="/hacking/grehack/ctf.jpg", alt="ctf" >

And later that day, we went to fly ! ;)

<img class="img_big" src="/hacking/grehack/team.jpg", alt="team" >

I hope you had fun reading this article, and will some day attend to a GreHack event. You definitely won't regret it !
