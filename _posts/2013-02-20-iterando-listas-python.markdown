---
layout: post
title: "Iterando por itens em listas do Python"
author: "Rafael Beraldo"
excerpt: "No qual compartilho um pouco de conhecimento sobre métodos de iterar por itens em listas do Python."
---

Essa é uma pequena dica para os que são, como eu, newbies em Python.

Para resolver [alguns exercícios no Codecademy][exercises-codecademy]
que envolviam operações nos itens de algumas listas, eu costumava criar
uma variável `count` e atribuir a ela o valor `0`. Para acessar cada
item das listas, eu utilizava o valor de `count` para acessar o índice
equivalente. Ao final da operação, eu aumentava o valor da variável em
1 e, enquanto (`while`) o valor de `count` fosse menor do que o número
de itens de lista (determinado por `len(sequence)`), essa operação seria
repetida.

Para vocês entenderem melhor, aqui vai o código para uma função que
recebe uma lista como argumento (`sequence`), remove todos os números
ímpares e retorna uma nova lista (`out_sequence`):

{% highlight python %}
def purify(sequence):
  count = 0
  out_sequence = []
  while count < len(sequence):
    if sequence[count] % 2 == 0:
      out_sequence.append(sequence[count])
    count += 1
  return out_sequence
{% endhighlight %}

## Uma maneira mais fácil

Para aprender mais maneiras de conseguir o mesmo resultado, li o código
de outros usuários do Codecademy e descobri que é possível utilizar um
loop `for`:

{% highlight python %}
def purify(sequence):
  out_sequence = []
  for i in sequence:
    if i % 2 == 0:
      out_sequence.append(i)
  return out_sequence
{% endhighlight %}
            
O loop `for` itera por cada item (`i`) da lista `sequence` e, se `i` for
um número par (ou seja, divisível por 2), ele será adicionado à lista
`out_sequence`. Muito mais elegante, devo admitir!

[exercises-codecademy]: http://www.codecademy.com/courses/python-intermediate-en-rCQKw/2?curriculum_id=4f89dab3d788890003000096
