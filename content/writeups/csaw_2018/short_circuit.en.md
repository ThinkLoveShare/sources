---
author: "Laluka"
title: "CSAW - Short Circuit"
slug: "short_circuit"
date: 2018-09-16
status: "original"
description: "Hardware challenge on paper! This task consists in getting the internal state of a (simple) circuit, bit by bit, and convert it to ascii texte. "
---


### Description

> Start from the monkey's paw and work your way down the high voltage line,
for every wire that is branches off has an element that is either on or off.
Ignore the first bit. Standard flag format.

> -Elyk


### TL;DR

This challenge consists in the analysis of a lovely electronic scheme.\
It is composed of diodes, wires, wires, wires and wires.\
The goal is to extract bits of data from the circuit.\

The task was not really hard, but if you have a bad sight, you're gonna have a bad time.


### Methology

Few things to know, here are the keys :

  - If a diode is attached to VCC on its flat side and 0 (aka GND) on its pointy side, it'll be __ON__
  - If it's the opposite, it'll be __OFF__ (yup, direction matters !)
  - If the input and output are attached to the same wire, it's __OFF__

<img class="img_full" src="/writeups/csaw_2018/short_circuit/paper.png" alt="paper" >

By using these rules, we extract the bits one by one, with our eyes glitching hard, and we obtain :

`01100110 01101100 01100001 01100111 01111011 01101111 01110111 01101101 01111001 01101000 01100001 01101110 01100100 01111101`

Once decoded : __flag{owmyhand}__
