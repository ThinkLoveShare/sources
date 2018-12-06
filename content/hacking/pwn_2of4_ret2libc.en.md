---
author: "Laluka"
title: "PWN 2/4 : Return at libc, pick a shell !"
slug: "pwn_2of4_ret2libc"
date: 2018-05-08
description: "Introduction to Return to libc (ret2libc) and practical example."
---

> Small edit after the initial publication of the articles:

> These four articles lead me to give an "pwn introductory" conference at the HitchHack 2018. It summarizes the first 3 articles but goes less into detail. If this format suits you better, the slides are downloadable[here] (/hacking/pwn_1of4_buffer_overflow/slides_conf_123_pwned.pdf) and the video (French only) here :

[![1, 2, 3, PWNED !](http://img.youtube.com/vi/hmt8M9YLwTg/0.jpg)](https://www.youtube.com/watch?v=hmt8M9YLwTg)

Welcome to this 2nd article dedicated to pwning linux executables!

On the list today, the ret2libc, or return to lib C. Still in the family of buffer overflow exploits, and always with the colleague's sources: https://cyrilbresch.fr/

I won't not go back to the huge definition list here, if needed, check back the (quite rough) previous article !


## The ret2libc... Why?

In the first article, we injected a shellcode into the stack, and we used the buffer overflow to redirect the execution on our shellcode, allowing us to spawn a shell. It was good, it was a little tricky, but it was... Functionnal ? Sadly, nowadays, it's not as easy as it was. Sad isn't it?

Indeed, at each security breach, new protections are developed and added to the systems. One of the protections found against this attack is the use of an NX flag placed on the stack. This makes the stack non-executable. Damnit!

<img class="img_med" src="/hacking/pwn_2of4_ret2libc/mince.jpg" alt="thin" >

Fortunately for us, some bearded (or beardless, who am I to judge?) people have found solutions to be able to have fun anyway. One of them, the ret2libc!


## The ret2libc... Wut ?

A C program does not know how to do much, very little in fact. In a program we use functions that "works magically", without thinking too much about what's underneath.

For example, the printf function that allows us to display text. The getc function which allows us to read a character typed by the user. Or even... The system function, which allows us to run a new program. All these functions are accessible in our program, we use them without ever having had the curiosity (or even the desire?) to look at their content or recode them. Good thing for us, they are already done, and placed in the...\
*Drum roll...*\
**libc** !

A little ref to the man: http://man7.org/linux/man-pages/man7/libc.7.html

<img class="img_med" src="/hacking/pwn_2of4_ret2libc/rtfm.jpg" alt="rtfm" >

Long story short, it is the standard C library, the place where all the most common / used functions are stored.

A program using the libc dynamically will be given a reference to this library when first executed. It'll then know where it can find it, its position in number of byte, in the stack.

The way it finds the different functions in the libc is quite complex, so I won't talk about it in this article, but for the most curious / brave: [plt_got_ld_so](https://www.segmentationfault.fr/linux/role-plt-got-ld-so/)

The main idea is the following:

The stack is not executable? Duh... The libc, on the other hand, is present, contains interesting functions, and is executable. The only thing left to do it to call on its functions. Literally.

We will therefore place in the stack the arguments that interest us (the arguments are here passed  by the stack, x86-64 style) as well as hijack the execution flow of the program to make it execute the system function (there are many variants, but it remains the most classic).

Note :

A program compiled in static (gcc: option -static) is not exploitable this way, because the used functions of the libc will have been incorporated into the program, so not libc will be linked at start-up. It will therefore not have access to the system function. But fortunately for you... Article 3? è_é


## The ret2libc.... How?

The basics are in place, now,  the walkthrough!

The studied binary is downloadable[here](/hacking/pwn_2of4_ret2libc/vuln)

We start by understanding how the program works (or does not work...), find the crash :

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/recon.png" alt="recon" >

Note :

 - `$(cmd)` : allows you to execute the cmd command as a priority.

 - `python -c "code"`: allows you to execute python code from bash. So it's really easy to display a lot of chars.

We're crashing. Well, that's excellent! Now, the offset, with the tool `pattern` in gdb-peda:

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/pattern_create.png" alt="pattern_create" >

I will explain some more the next screenshot, because it hurt you quite bad (cf your feedback, thank youuu!)

The terminal is divided into three parts:

 * Registers: What the different registers contain when the program stops, here by a crash.

 * Code: Where EIP (Instruction Pointer) points, i.e. where we are in the execution and what comes next.

 * Stack: The content of our stack, with addresses, format, references, ...

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/pattern_search.png" alt="pattern_search" >

Then we look for the pattern used previously to find the offset. Here, miraculously, EIP is directly controlled, which is actually quite rare... Good thing for us!

The offset displayed for EIP is therefore 268 bytes.

Now, the ret2libc part:

A simple payload will have the following structure:

-> "A" * offset\
-> Where we want to jump (system)\
-> Where the program will return after the function call\
-> Argument(s) of the used function

So we are missing the system address, and our parameter.

There are plenty of ways to retrieve this information, I'll show you two.

Attention, we are working here without the ASLR, once again to make the exploit more understandable. To disable it:

```shell
$ # As root :
$ echo 0 > /proc/sys/kernel/randomize_va_space
```

The first, simpler but also not always reliable, makes uses of gdb / peda (note that gdb disables by default the ASLR when debugging):

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/break_main.png" alt="break_main" >

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/print_system.png" alt="print_system" >

It is important to set a breakpoint (software breakpoint, a way to pause the program to see, for example, the state of its registers, and continue its execution later on) at the beginning of the program and run it before doing our search. It is necessary so the libc has been resolved (attached / linked). Otherwise, you wouldn't see anything, neither system, nor "/bin/sh", this string being nicely placed in the libc.

Second solution, a little less simple but so much more reliable / scalable:

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/ldd.png" alt="ldd" >

I will detail it for you, because these tools are powerful but not necessarily easy to use when you discover them.

 * Step 1:

 ldd displays the shared dependencies of a program. Here, (among other things), the libc and its offset. Without ASLR it does not change, with it enabled, it will change each time.

 * Step 2:

 readelf, helps us to analyze the content of the libc, which is an ELF file, but also a shared library. Option `-a` to read all the content, and put all the lines analyzed in grep using a pipe `|`, which will search for lines containing the word system. We get the one we are interested in: 0x0003c7d0, so the system offset in the libc.

 * Step 3:

 We then look for `/bin/sh\x00` in the libc. `-b` to have the offset in byte, `-o` to have only the search word and not the line, and `-a` to activate the analysis in binary mode. We therefore obtain in decimal the offset of `/bin/sh` in the libc.

 * Step 4:

 Some python to get the sum of the libc offset and what interests us, and BIM, we have everything. A little longer, but for more complicated exploits, this way of doing things is to be preferred, believe me! :')

<img class="img_med" src="/hacking/pwn_2of4_ret2libc/mind_blown.gif" alt="mind_blown" >

So we got the system and `/bin/sh` addresses to run a shell. Allright! :D

Now that we have everything we need, let's write down our exploit:

```python
#!/usr/bin/en python2

from pwn import *

offset = 268
payload = "A" * offset
payload += p32(0xf7dfa7d0) # @system
payload += p32(0x42424242) # @retour - foo
payload += p32(0xf7f3688a) # @"/bin/bash\x00"

r = process(["./vuln", payload])
r.interactive()
```

Note :

Here, I used 0x4242424242 because the value doesn't matter to us, where the program returns here when leaving the targeted function, here it doesn't matter. But if you want to avoid the program crash when you close your shell, it is possible to put in this location the address of the exit function, which will properly close the program, thus leaving no trace in the logs... ;)

Here, once the shell is closed, the program will jump to address 0x424242424 and die of a painful segfault... Save lives, place exits... Or don't.

Then we run it:

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/run_exploit.png" alt="run_exploit" >

And BIM, we pop our shell via a very basic ret2libc!

<img class="img_med" src="/hacking/pwn_2of4_ret2libc/like_a_boss.jpg" alt="like_a_boss" >

## Bonus: Memory mapping!

Assuming that the ASLR is activated, this solution can still be used under one condition: to be able to find the libc. There are many techniques to leak its current location, and that the program is started (because remember, it changes every time), all you have to do is add the function offset to get your exploit.

But luckily, there is a magical place in our system, readable by the user who ran the program (thank you Geluchat for the rectification, his website here: https://www.dailysecurity.fr/), which tells you where the different objects related to its execution are placed: `/proc/self/maps` !

<img class="img_full" src="/hacking/pwn_2of4_ret2libc/maps.png" alt="maps" >

A quick look there, or by /proc/PID/maps (the PID being the identifier of the program to analyze) will allow you to see where the different parts are placed. If you can pause your program and read this information, the ASLR is no longer relevant! :)

I will stop here for this brief introduction to ret2libc. Be aware that this is a basic example, that it is common to "chain" ret2libc calls to use several functions in a single exploit. Next article, the ROP!

See you soon for the third article and thank you for your many feedback!

And for those of my class who read me...\
Keep it up, the second-chance exam is coming!
