---
layout: post
title: "LaTeX: Acentos em fórmulas"
author: Rafael Beraldo
excerpt: "No qual ajudo meus amigos usuários de LaTeX com um problema pequeno, mas chatinho."
---

Essa é uma breve dica pra quem tem ou teve problemas para escrever fórmulas que
contenham variáveis com acentos no LaTeX. Se você escrever uma fórmula como:

    \[ Variável = \frac{x}{y} \]

O “á” em “Variável” não será mostrado como esperamos. Para resolver esse
problema, basta usar `\acute{a}`. Assim:

    \[ Vari\acute{a}vel = \frac{x}{y} \]

irá produzir o efeito desejado. Para mais acentos, vejam essa imagem que
encontrei [num site por aí][garsia]:

![Acentos em fórmulas no LaTeX](http://garsia.math.yorku.ca/~zabrocki/latexpanel/mathaccents.jpg "Pequena tabela para colocar acentos em fórmulas no LaTeX")

Se as variáveis forem muito longas, como

    \[ Variável muito longa que vai dar problema = \frac{x}{y} \]

os espaços irão simplesmente desaparecer. Para evitar que isso aconteça, basta
encapsular (gostou, ãh?) o texto em `\textrm{}`, assim:

    \[ \textrm{Variável muito longa que vai dar problema} = \frac{x}{y} \]

Nesse caso não é necessário marcar os acentos, apenas os escreva como faria com
textos normais.

É isso aí, espero que isso ajude vocês!

[garsia]: http://garsia.math.yorku.ca/~zabrocki/latexpanel/mathaccents.html
