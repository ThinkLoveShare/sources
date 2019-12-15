---
author: "Laluka"
title: "ThinkLoveShare's migration"
slug: "website_migration"
date: 2018-12-09
status: "original"
description: "Short introduction to the technologies used to build and maintain this website and a few words on why I changed. "
---


## Why change ?

I used to write from time to time on thinkloveshare.blogspot.com which will soon be retired, replaced by [thinkloveshare.com](https://thinkloveshare.com). I decided to change for quite a few reasons, here's the story:

 * Code format

 There was no easy way to display code snippets. I could have added some js beautifier / pretty printers, but I lacked time, so instead of that was just putting screenshots which is... Probably the worst choice possible... =]

 * Hosting various files

 For the pwn series, I wanted to host the vulnerable binaries but wasn't able so store them on the blog itself. Using external links means that some day that can (will) expire, and I don't like that. I already lost days searching for *that one old tool / sample* that isn't available on the internet anymore, and all I could find was dead links.\
 **GRLANKHJDAKNKBJAFHLIFAJK** :@

 * Flexibility & Content Manager

 The content manager wasn't that bad, but It definitely wasn't really pleasant to use either. Also, there were only some basic features on the web interface... The website structure wasn't easily customizable, so this whole solution was sort of OK, but only temporary.


## New technologies

 * [OVH](https://www.ovh.com) - domain name

Step one, register the domain name `thinkloveshare.com` at OVH and configure it to make it point at `thinkloveshare.github.io` and use the github servers to resolve the domain name.

<img class="img_full" src="/coding/website_migration/dns_ovh.png" alt="dns_ovh">

 * [Github Pages](https://pages.github.com/) - hosting

Step two, create a new github account (named `thinkloveshare` as it'll used in the default website URL) that will contain the website sources and content. The website is then served at `thinkloveshare.github.io` and `thinkloveshare.com` but has no content yet.

<img class="img_full" src="/coding/website_migration/github_pages.png" alt="github_pages">

 * [Hugo](https://gohugo.io/) - website generator

Step three, use the templates, rules and content (here [toml](https://github.com/toml-lang/toml) and [markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)) to generate a fully functional static website (html5, css3, js, ...) with Hugo.

<img class="img_big" src="/coding/website_migration/hugo.png" alt="hugo">

 * [Hyde-Hyde](https://github.com/htr3n/hyde-hyde) - website theme

Step four, spend quite some time adjusting the Hyde-Hyde theme which is really clean and functional out of the box. Their team made an awesome work there !

 * [Bash](https://www.gnu.org/software/bash/) - automating

Step five, create two helpers script in order to fasten the debug and publishing process. I'm not a 'good' developer, but hey, they sure do the job !\
[hugo_server.sh](https://github.com/ThinkLoveShare/sources/blob/master/hugo_server.sh) &
[hugo_publish.sh](https://github.com/ThinkLoveShare/sources/blob/master/hugo_publish.sh)

 * [Deepl](https://deepl.com/translator) - translations

and last but not least, the magical ingredient, an awesome translator to fasten the translation as I had much content to translate and not much time to do so. The articles are still somehow patched after the automatic translation because Deepl isn't that perfect, but it **really** does an amazing job.

Just so you know, the articles are written in French or English depending on the subject, and translated afterward. Most of the IT stuff in English, the rest in French.


## Practical example

Here are the steps I use to publish a new article

 * Create / Edit the content
 * Debug in local

<img class="img_full" src="/coding/website_migration/workflow.png" alt="workflow">

 * Commit everything and publish

<img class="img_full" src="/coding/website_migration/publish.png" alt="publish">

## Last words

These are neat technologies, so there we go for much more fun and more content! ;)\
If you have any question or remark, feel free to use the comment system offered by [disqus](https://disqus.com/)!\
Also, I track you using [Google analytics](https://analytics.google.com/)...\
Sorry! `¯\_(ツ)_/¯`
