---
layout: post
title: "Jekyll never finishes compiling and other stuff"
author: Rafael Beraldo
excerpt: "In which I discuss an easy “bugfix”. Really, it was even stupid."
---

I use the monstrous [Jekyll][jekyll] for all my blogging, and I love it. It’s
simple enough, though you can do some pretty awesome stuff with it. I was away
from my blog for quite a while so I completely lost the hang of Jekyll. Any
time I’d try to compile my site, it would stop on `regenerating: n files
changed`.

I googled this message and found out that whenever the option `auto` is on,
Jekyll will watch for any changes and recompile the site whenever it finds one.
Thus, it will never “finish” compiling, unless you stop it by hitting `Ctrl-C`.
The solution was simple: I just had to change `auto: true` to `auto: false` in
the `_config.yml` configuration file. Now it compiles just fine.

As for the “other stuff” in the title of the post, I’d like to know from my
readers whether reading this blog is too difficult for you. Being a command
line geek myself, I think the readability is OK but I might consider changing
the font to a brighter green or even white. Please [mail me][email] with your
ideas!

And here’s yet another cat by [Noah Sussman][thefangmonster] for your
appreciation!

![CATML](http://farm1.staticflickr.com/221/490423135_c2a908f3a0_o.jpg "HTML can not do that!")


[jekyll]: http://jekyllrb.com/
[email]: mailto:rberaldo@cabaladada.org
[thefangmonster]: http://www.flickr.com/photos/thefangmonster/490423135/
