---
layout: post
title: "rsync options"
author: Rafael Beraldo
excerpt: "In which I discuss what flags I use with the rsync command and a small mnemonics to help me remember them."
---

`rsync` is a wonderful program. Three days ago, I forgot to use it and used
`scp` instead to transfer the files of this blog from my netbook to the server,
destroying my `piwik` installation in the process. In my defense, it was 7 am
and I was in a hurry to upload the [first post on the Linux Crypto
series][linux_crypto_intro].

I learned my lesson and used `rsync` to transfer the subsequent changes. It has
so many options, though, that I'm never sure what to use. To help me with that,
I wrote them down on my Moleskine notebook and came up with a mnemonics.
Here's what I use:

    rsync -zarc source destination

where `-z` is `--compress`, `-a` is `--archive`, `-r` is `--recursive` and `-c`
is `--checksum`. According to `man rsync`, `--archive` “ensures that symbolic
links, devices, attributes, permissions, ownerships, etc. are preserved in the
transfer”. It is a shorthand for `-rLptgoD`!

The mnemonics is pretty simple:

> `z`ombies `a`re `r`eally `c`areless

[linux_crypto_intro]: {% post_url 2013-09-16-linux_cripto_intro %}
