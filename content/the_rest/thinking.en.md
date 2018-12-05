---
author: "Laluka"
title: "Reasoning without headache"
slug: "reasoning_without_headache"
date: 2017-03-07
description: "Reasoning is not simple and often leads to a headache or even stress. Here are some personal methods and advices that will hopefully allow you to better experience these research phases. "
---

Today, I propose to take a step back on how to approach problems, research, or even.... Life in general?

## Prologue

What I am going to tell you here is common sense to me, but it took me years to adopt these few methods, and even then, sometimes I forget to use them and quickly regret it.

I will therefore present some ideas and techniques that will serve you in your studies (cuckoo math and physics that hurts!), in your work (cuckoo administration, market', research,...), or in your passion (hello there fellow hacking challenges that take daysssss <3).

<img class="img_med" src="/the_rest/thinking/head.png" alt="head">

## HowTo

#### What I have, what I want, what I need in between

The name of this first point is quite explicit, a new problem? A new question? Reflex!

  1. I take what I need to write, I mark all the information, the means at my disposal in the first place.

  2. I mark at the bottom of the sheet (paper, word, .txt, whatever...) what I want to reach, my goal.

  3. I mark the possible intermediate steps that can serve as a "checkpoints", to know what has been validated or not, and through which paths one can go to access the same result.

#### Write everything, classify, sort, conclude

This step consists of recording each attempt, briefly, to find out what has been done or not, what may have worked or not. Once this information has been collected, sort them into small groups and try to draw conclusions and generalizations, but keep every piece of relevant information.

#### Descend from a level of abstraction, understand, ascend

 > Sure ! Wait... What?

 This one is a little confusing, can be explained, but it is much better understood with an example.

 Let's take maths, but kind ones, so we don't upset anyone, okay?

 I used to tutor students from college to high school, and one question that came up very often was this:

 How do powers work?

 I then put a simple line on the board:

 ```
 x^2*x^3 = ?
 ```

 "But I just want to know how it works, not to fail one more time while at the board... \
 -But... You already know how it works, believe me! What *is* x^2 ?
 -x*x\
 -Yes, and what *is* x^3?\
 -x*x*x\
 -All right, now, what if you replace what you don't know with what you already know? "\

 Then appears on the board:

 ```
 x*x*x*x*x
 ```

"And that... You know what it is, isn't it?
-Yes... It's x^5....\

*Piouf! Infinite knowledge!* :O

And that's exactly what this first barbaric sentence means. Take what I don't know, go backward until you reach something you know, or a definition, understand it, and assemble the little pieces until you understand how the studied object works. And the good thing about this technique is that it works with absolutely everything! Our world being made of many small bricks stacked one on top of each other, whether it is in science, philosophy, socio, etc...

Its only weakness is circular dependencies, when the definition of A sends to B, which refers to A, ... And then....

*Program received signal SIGSEGV, Segmentation fault.*

#### Do make diagrams

 > Diagrams save lives. Always

 Every day, every hour, every minute of your life you spend not making a diagram, extremists (religious and atheists all together) kill kittens to make you understand how bad it is.

 Making diagrams is giving yourself a chance to visualize what is happening, easily identify errors in your reasoning, measurement, logic, etc.

 A short tour on the youtube channel [https://www.youtube.com/channel/UCYO_jab_esuFRV4b17AJtAw](ThreeBlueOneBrown) will allow you to see that diagrams are beautiful, useful, and often necessary for a good understanding (especially in math, physics, info, ...)

#### One can't know everything, but can search about everything

Yup, we live in a world where a multitude of people have been searching (and finding) things in all areas for a very long time. So starting from the principle that we can know everything, discover everything alone, it is unrealistic and even pretentious. So for each new project or challenge, a documentation stage has been done in order to know what is feasible or not. This stage is crucial.

A short quote from OWASP (free and open security community):

 > The first phase in security assessment is focused on collecting as much information as possible about a target application. Information Gathering is the most critical step of an application security test. The security test should endeavour to test as much of the code base as possible. Thus mapping all possible paths through the code to facilitate thorough testing is paramount.

#### Proofreading and Self-feedback

Proofreading: Check that the result obtained is consistent, depending on the case, it can be:

"Is my result the initial objective? "

"Do I have a result in the right unit? Good order of magnitude? Good type? Realistic? "

This will allow students to make a small conclusion proudly announcing: "I did this, but I have enough perspective to know that I made a mistake! Give me a few points pleaseeee! °^° "

And others to review their approach before embarking on further operations with a shaky start, thus saving time, energy, etc....

Self-feedback: Once the reasoning has come to an end, take notes on what you may have done right or wrong, the little details that you missed. That way you'll pay more attention to it next time.

Example: During a CTF, when a challenge makes me download files to analyze / exploit, I tend to rush into the content of the file, and I have already lost days misleaded by my behaviour. A clue was in the name and the date the file, its creation timestamp. I was fooled twice on this point before telling myself "Oops, self-feedback... :x "

Now that I am aware of this issue, I remember not to forget to check these kind of informations first... ^.^

#### Know how to ask for help

Yes, sometimes, even with all these good practices, when it doesn't want to work, it does *not* want to. So knowing how to ask for help is essential, but not always easy. First of all, you have to dare. But even if you dare, there are many points to check before asking.

**MUST** :

 - Explain the problem precisely by specifying what is blocking or not
 - Pay attention to what is and is not disclosable (confidential project, challenge spoil, ...)
 - Explain what has been tried or not, and what the attempts have resulted in
 - Give the context of the tests (OS? Software? Location? Starting axioms? Anything that can affect the search or the result actually... Unsuspected case: The current hour! :D)
 - Remain polite and courteous, always, and thankful for the time spent helping, whether or not the help was helpful in the end... :)

**MUST NOT**:

 - "Iz no workin, aniwai i zuck nd it zuck. "
 - "Can you give me the answer? "
 - "Can you do it for me? "
 - "I've tried everything, so the exercise is broken, not my personal skills. " -> Personal experience... Java exams... Oopsy... :<
 - Spam someone waiting for their help, one must know  how to reason himself, stay stuck some time before asking for help.... (Hello Cyril, once again, sorry... :> )

## Epilogue

Now, with these few methods, you are a little better prepared to handle these tricky problems!

The idea is not to apply them strictly, but to have them as a 'guide-line' and to be able to lean on them when you're stuck, jumping from one to the other until the problem solves itself, and most often it works!

I am not saying that this is the only approach to use, because there are many cases where it cannot or should not apply, but it has served me so much that I can only advise you to keep it in mind for the right time. I'm sure that some day it will prevent you from drowning in a difficult task.

Wishing you a good unstuck reflexion, 
