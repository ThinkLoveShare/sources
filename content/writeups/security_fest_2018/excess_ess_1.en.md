---
author: "Laluka"
title: "Security Fest - Excess ess 1"
slug: "excess_ess_1"
date: 2018-06-04
status: "original"
description: "Web challenge about XSS and browser behavior. It's all about finding a bypass in order to execute a javascript function after its references has been removed. "
---

This challenge is called "Excess Ess 1", a funny name for XSS, which is an attack that consists in forcing our victim's browser to execute code (most of the time javascript) without its consent. This challenge was proposed by the 2018's edition of the SecurityFest CTF.

## The goal
Most of the time, to prove that an XSS is possible, the hacker provides a payload that pops an alert. And that's exactly what we're asked to do. So we first feed a simple word to see if it's reflected in the webpage. We do so and see that the keyword is reflected as a variable content in our page.

<img class="img_full" src="/writeups/security_fest_2018/recon.png" alt="recon" >

The next step is to force the page to execute code. I try this using the console.log function after closing the first variable affectation, and commenting what comes afterward. I try (cf the URL), and yup ! It logs 3, so we can execute javascript !

<img class="img_full" src="/writeups/security_fest_2018/inject.png" alt="inject" >

## The protection
Next step, we try to use the alert(1) payload to validate the challenge, but : Uh Oh !

<img class="img_full" src="/writeups/security_fest_2018/prompt.png" alt="prompt" >

All we have is a prompt. The reason of this behavior is that a script is loaded and executed before our payload. We can fetch its content and we understand that the alert function has been override with the prompt function...

<img class="img_full" src="/writeups/security_fest_2018/ascii_art.png" alt="ascii_art" >

So.. We don't have it anymore ? How to use it then ?

## The bypass
I saw few months ago a video from LiveOverflow. It was about the reverse-engineering of a pop-under javascript module that helps f*ckers to pop annoying ads under your current window, so it takes you more time to realize it and close it.

Many of the functions they wanted to use to pop / place the window under were blacklisted, so they created an iframe (Long story short, a new frame / window in the current window). The creation of the iframe offers a brand new context, rebinds all the main functions to be sure that the site that'll be loaded in the new iframe will be functional. But doing so, we also regain the alert function. We can then either reassign our alert function, or just call it from the iframe ! Isn't it great ? =D

## The solution
```html
/?xss='; <!-- Escape out payload -->
```
```javascript
i = document.createElement("iframe");
i.onload=function(){
    i.contentWindow.alert(1);
};
document.getElementsByClassName('container')[0].appendChild(i);//
```

So the final payload submited was :
```html
http://xss1.alieni.se:2999/?xss=';i=document.createElement("iframe");i.onload=function(){i.contentWindow.alert(1);};document.getElementsByClassName('container')[0].appendChild(i);//
```

<img class="img_full" src="/writeups/security_fest_2018/alert.png" alt="alert" >

## Conclusion
Using a blacklist system is (most of the time) a bad idea, especially with javascipt / python / SQL / ... because there are so many ways to bypass blocked keywords, edit or recreate objects and functions easily, that this kind of sandboxing / protection is definitely not effective enough.

Even if this trick isn't new to me, I never had to use it before, so it was quite cool to try it by my own and realize that it's a really easy and fun trick to use !

Later during this CTF, a second version of this challenge has been released, "Excess Ess 2". I've spent few hours on it. We were controlling fields in a meta tag, but not the content part. If you're aware of a way to exploit an XSS in a meta tag, without the content field, without <> to create a new entity, or a way to overwrite the content attribute, please tell me, I'll be glad to know !

I hope you liked this write-up,\
Have a great day ! ^.^
