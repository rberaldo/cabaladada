---
layout: post
title: "Security Now #509 Digest"
author: Rafael Beraldo
excerpt: "I'm a big fan of TWIT's Security Now. Since the demise of my favorite show, Linux Outlaws, Security Now has had the highest priority on my playlist. Computer security has always been one of my favorite areas of interest, so I've decided I'll start to put together an actionable digest after listening to the shows."
---

## Introduction to the Security Now Digests

I'm a big fan of [TWIT's Security Now][sn]. Since the demise of my favorite
show, Linux Outlaws, Security Now has had the highest priority on my playlist.
Computer security has always been one of my favorite areas of interest, and
Leo and Steve do a great job of summing up the big stories of the week, as
well as breaking down complex concepts so they're much easier to understand.

As with all podcasts I subscribe to, I usually listen to Security Now while
doing the dishes, driving or doing something else that doesn't require any
intellectual effort. Furthermore, it often takes me a couple of days to get
through each episode, since I don't have a long commute every day. As a
result, I can never act on the security breaches immediately. Committing them
to memory doesn't work either, and for the most part all the plans that I make
while listening to the shows are never put into practice.

Since Snowden blew the metaphorical whistle there's been a great spike in
interest in security from the general public. So I thought I'd put together a
short weekly digest with actionable information that I'm hoping may be useful
for me and for other people who are interested in souping up their security.

Why wait any longer? Let's hit the news!

## Security Now #509 Digest

![weakdh.org page screaming at me for not having an up-to-date
browser.](/assets/images/logjam.png "weakdh.org page screaming at me for not having an
up-to-date browser.")

SN #509 can be found at [twit.tv][sn509]. The show notes are over at
[grc.com][showNotes]. Here are the most important security news for this week:

- This week's big story was **Logjam**, the latest in cleverly named security
  breaches. Without getting into too much detail, Logjam is a
  **man-in-the-middle attack** against TLS that allows the attacker to **lower
  the strength of the ciphersuite** used on a given web session. That allows
  the attacker to easily break the encryption and have access to the
  communication going between the client and the server. If you are a **systems
  administrator, you should update your TLS implementation and configure
  services such as Apache or OpenSSH not to use the weak chipersuites.**
  **Regular users,** on the other hand, **should upgrade their browsers.** See
  more info on [weakdh.org][weakdh].
- A new security flaw that affects routers has been discovered. There is a
  **NetUSB** bug that affects most routers with a USB port. Such routers allow
  the users to remotely access any devices connected to the USB port.
  Unfortunately, the NetUSB driver is subject to a buffer overflow. In some
  cases, the flaw can be exploited remotely, since the router exposes the
  service to the WAN port. **Solution: buy a new router, or use a custom
  firmware such as [OpenWRT][openwrt] or [Tomato][tomato]. To check if your
  router is vulnerable, use Steve's SHIELDS UP!:
  [grc.com/x/portprobe=20005][shieldsUp].**
- PKES (Passive Keyless Entry & Start, or The Stuff That Lets You Into Your
  Car Just By Having It On You) is Hopelessly Broken. Keep yours at a Faraday
  Cage! (I'm so happy my car is older, simpler and safer.)

Moving on to the fun stuff:

- [ScriptBlock][scriptBlock] is a (new?) Chromium/Chrome plugin that, well,
  blocks scripts! It works similarly to Firefox's NoScript, allowing the user
  to control which scripts can run and which can't.
- Steve read the [Let's Encrypt][letsEncrypt] subscriber agreement and it's
  looking good! I'm looking forward to using TLS on Cabaladadá, and Let's
  Encrypt is sure to be my CA of choice.

That's all for this first digest, guys! Happy hacking!

[sn]: http://twit.tv/show/security-now
[sn509]: http://twit.tv/show/security-now/509
[showNotes]: https://www.grc.com/sn/SN-509-Notes.pdf
[weakdh]: https://weakdh.org/
[openwrt]: https://openwrt.org/
[tomato]: http://www.polarcloud.com/tomato
[shieldsUp]: https://www.grc.com/x/portprobe=20005
[scriptBlock]: https://chrome.google.com/webstore/detail/scriptblock/hcdjknjpbnhdoabbngpmfekaecnpajba
[letsEncrypt]: https://letsencrypt.org/
