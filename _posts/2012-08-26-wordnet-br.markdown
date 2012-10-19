---
layout: post
title: "WordNet.Br"
author: Rafael Beraldo
excerpt: "No qual discuto meu envolvimento com o projeto WordNet.Br, e alguns pontos sobre a base da WordNet."
published: false
---

Esse é um momento particularmente bom para discutir a WordNet.Br. Mais sobre
isso adiante; primeiro quero discutir o que é essa tal WordNet.Br. 

O projeto visa produzir uma [rede semântica][rede-semantica] do português,
alinhada à [WordNet][wnpr], projeto iniciado em 1985 por Christiane Fellbaum na
Universidade de Princeton.  Essa rede tem como nós os chamados _synsets_, ou
seja, “conjuntos de sinônimos”; penso que o nome é bastante explicativo. Um
exemplo de _synset_ é _{ carro, automóvel }_. Em inglês, o _synset_
equivalente seria _{ car, auto, automobile, machine, motorcar }_.
Podemos, desse modo, “alinhar” esses dois _synsets_, uma vez que há uma
equivalência de _sentido_ entre eles. Em suma, um _synset_ representa um
_conceito_ dentro de uma língua qualquer, seja lá quantos termos existam para
preencher lexicalmente esse conceito. Existem wordnets para várias línguas, e
todas elas se conectam a todas as outras (em teoria) ao se alinhar com a
WordNet (notem as maiúsculas). Desse modo, podemos acessar qualquer outro
_synset_ em qualquer outra língua passando pela WordNet.

Mas isso não é tudo; entre as palavras de uma wordnet, existem relações. Por
exemplo, no caso de substantivos, temos a relação _IS A_. Assim, _dog IS A
canine WHICH IS A carnivore WHICH IS AN animal WHICH IS A_ etc. Visualmente:

{% highlight bash linenos %}

    dog, domestic dog, Canis familiaris
      => canine, canid
         => carnivore
           => placental, placental mammal, eutherian, eutherian mammal
             => mammal
               => vertebrate, craniate
                 => chordate
                   => animal, animate being, beast, brute, creature, fauna
                     => ...

{% endhighlight %}

Na minha iniciação científica fiz o trabalho de alinhar uma certa quantidade de
substantivos do tipo ARTIFACT, o que foi bastante divertido e também deu no que
pensar. O projeto está entrando, no entanto, em uma nova fase, e meu
envolvimento como bolsista acabou e no processo de produzir o relatório final
para a CNPQ, me peguei pensando em vários tópicos para discutir no relatório, e
resolvi ensaiar um pouco aqui. Sobre o futuro do projeto, fiquem ligado que
eventualmente publicarei notícias!

Primeiramente, gostaria de discutir um problema com a base da WN.Pr (é como
chamamos a WordNet de Princeton em nossos documentos). Durante os últimos 500
alinhamentos que fiz, notei que, em várias ocasiões, _synsets_ traziam a noção
de registro, isso é, variações na língua (inglesa, no caso). Para melhor me
explicar, vejamos _{ burthen }_:

{% highlight bash linenos %}

    burthen
           => load, loading, burden
               => weight
                   => artifact, artefact
                       => object, physical object
                           => entity
                       => whole, whole thing, unit
                           => object, physical object
                               => entity

{% endhighlight %}

A glosa (pequena frase que explica aquele _synset_) é “_a variant of
‘burden’_”, ou seja, “_uma variação de ‘burden’_”. Oras, do jeito que a WordNet
2.0 coloca _burthen_, tecnicamente, parece que essa palavra é um tipo (_IS A_)
de _burden_, afinal de contas, sinônimos devem ficar num mesmo _synset_. Me
pergunto por qual motivo esse tipo de alinhamento foi escolhido. Nesse sentido,
a WN.Br é mais rigorosa, pois em _{ cela, cubículo, prisão, xadrez }_, a
palavra _xadrez_, muito embora seja um modo informal de dizer _prisão_, está
incluído no mesmo _synset_. 

Esse comportamento se repete, nos 500 últimos _synsets_ que alinhei, em alguns
outros casos:

* _{ boot2 }_ (termo britânico para “porta-malas”)
* _{ britches }_ (termo informal para “_breeches_”)
* _{ bioscope1 }_ (esse é obscuro; a glosa é “_a South African movie
  theater_”, mas não achei referências na Internet)

Existe outros casos onde o _synset_ é discutível. Chamo a atenção para _{
bitmap, electronic image }_, cuja glosa é “_an image represented as a two
dimensional array of brightness values for pixels_”. Em primeiro lugar, sinto
que o termo _image_, ou talvez _picture_ deveria ser incluído no _synset_, uma
vez que, [muito frequentemente][images-google], imagens digitais são chamadas
assim. Além disso, nem todas as imagens digitais são um _array of brightness
values for pixels_; existem imagens vetoriais e a maioria dos formatos atuais
são na verdade comprimidos. Assim, _bitmap_ deveria ser [hipônimo][hyponymy] de
_electronic image_, assim como _JPG_, _GIF_, _PNG_, _TIFF_ etc. [E o erro não
está corrigido na versão 3.1 da WN.Pr][error].

Um terceiro caso constitui uma questão que se relaciona mais ao meu trabalho. É
o caso de _{ brush }_:

{% highlight bash linenos %}

    brush
           => implement
               => instrumentality, instrumentation
                   => artifact, artefact
                       => object, physical object
                           => entity
                       => whole, whole thing, unit
                           => object, physical object
                               => entity

{% endhighlight %}

Em inglês, _brush_ é qualquer coisa que tenha um cabo e cerdas ou pelo
firmemente presos a esse cabo. Nessa categoria cabem escovas de dente, de
cabelo, de limpar o chão do banheiro, de limpar garrafas etc. Um caso muito
interessante é, no entanto, o de _pincel_. Fiz uma pesquisa informal com
algumas pessoas, e todos ficaram igualmente surpresos ao darem conta que um
pincel _é_ um tipo de escova, mas nunca pensamos nesses termos. O português
parece ter, ao contrário do inglês, uma categoria à parte para os pincéis,
muito embora eles sejam bastante parecidos com as escovas em geral. Talvez a
diferenciação não seja só pela utilização, mas porque os pincéis possuem cerdas
macias, enquanto que escovas possuem cerdas rígidas. Não me surpreenderia se
existissem pincéis com cerdas rígidas e vice-versa, no entanto.

A solução para esse alinhamento foi alinhar com _{ escova }_, afinal _{
pincel&nbsp;}_ será alinhado a _{ paint brush }_. Ainda assim, solução melhor
seria que _{  brush }_ tivesse um duplo alinhamento; porém, ainda não dispomos
de dispositivos para representar manualmente esse tipo de alinhamento.

Para usar a WordNet de Princeton, visitem [a interface web][wnpr-web] em
Python!

Por hoje é isso! _Happy hacking to you all_!

![wordmadness](http://www.cs.princeton.edu/courses/archive/spr07/cos226/assignments/wordnet-fig1.png "Wordneds are mad!")

[wnpr]: http://en.wikipedia.org/wiki/WordNet
[rede-semantica]: http://en.wikipedia.org/wiki/Semantic_network
[hyponymy]: http://en.wikipedia.org/wiki/Hyponymy
[error]: http://wordnetweb.princeton.edu/perl/webwn?o2=&o0=1&o8=1&o1=1&o7=&o5=&o9=&o6=&o3=&o4=&s=electronic+image
[images-google]: https://www.google.com/search?q=images
[wnpr-web]: http://wordnetweb.princeton.edu/perl/webwn
