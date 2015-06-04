---
layout: post
title: "Security Now #510 Digest"
author: Rafael Beraldo
excerpt: "This week we discuss two Apple bugs, how Microsoft is bugging Windows users and a couple of Google Projects that might completely change how we interact with our devices, as well as their security."
---

Hello again and welcome to my little Security Now digest. I'm going to try and
assemble a short, actionable digest to help you get the most out of Steve and
Leo's tips.

Security Now #510 can be found at [twit.tv][sn510]. The show notes are over at
[grc.com][showNotes]. Here are the most important security news for this week:

- iOS's iMessage has a “UTF-8 encryption/encoding/viewing error” (as worded by
  user [johnkphotos][redditUser] on [Reddit][iMessageReddit]). **The bug can
  be triggered by sending a specially crafted message and will turn of the
  victim's device. iPhone users up to iPhone 4 are the only not affected**
  since the bug was introduced after iOS v7.1.2. Apple will probably fix this
  soon, so keep your phones up to date!
- Since we started talking Apple, let's continue on topic. **A bug [has been
  found][appleFirmware] in the Mac UEFI that allows the firmware to be
  rewritten.** Usually, the UEFI is protected against this kind of attack, but
  there was a bug in the firmware that allows an attacker to overwrite the
  bios after a suspend-resume cycle. **Newer Macs are not affected, but older
  Macs still don't have a fix. For now, you can avoid performing suspends or
  buy a new computer =/**

And that's it! In other noteworthy news, **your Windows 7 or 8 installation
might be bugging you with a suspicious looking traybar notification about
Windows 10.** That's not a virus, only Microsoft trying to push the newest,
yet-to-be-released Windows version. If that annoys you, **read this article on
[iDigitalTimes on how to remove the icon][removeUpdateIcon].**

Now on to fun stuff:

- **Project Vault** is a Google ATAP project to deliver a Hardware Security
  Module that can encrypt and decrypt streams of data.
- [**Project Soli**][soli] is a Google ATAP radar that Steve and Leo agree
  has to potential to completely change the way we interact with our devices.
  As Project Vault, Soli was introduced during the latest Google I/O, held on
  May 28 and 29.

A thus ends our digest. What did you think about it? Please send your
comments, questions and suggestions to rberaldo at cabaladada dot org. I'll be
happy to hear from you.

See you next week!

[sn510]: http://twit.tv/show/security-now/510
[showNotes]: https://www.grc.com/sn/SN-510-Notes.pdf
[redditUser]: https://www.reddit.com/user/johnkphotos
[iMessageReddit]: https://www.reddit.com/r/explainlikeimfive/comments/37edde/eli5_how_that_text_you_can_send_to_friends_turns/
[appleFirmware]: https://reverse.put.as/2015/05/29/the-empire-strikes-back-apple-how-your-mac-firmware-security-is-completely-broken/
[removeUpdateIcon]: http://www.idigitaltimes.com/windows-10-update-icon-real-how-can-i-remove-it-cautious-users-worry-theyve-been-445716
[soli]: https://www.youtube.com/watch?v=0QNiZfSsPc0
