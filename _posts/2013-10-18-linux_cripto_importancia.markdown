---
layout: post
title: "Criptografia no Linux: Importância"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt:
published: false
---

Essa é o décimo post de uma série de dez posts traduzindo o original de Tom
Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma licença [Creative
Commons 3.0][cc].

Para a lista de posts, veja a [introdução][linux_crypto_intro].

---

Enquanto esta série de arquivos estava sendo escrita, a partir de junho de 2013
[Edward Snowden][snowden_wikipedia] começou a vazar documentos ultrassecretos
da Agência Nacional de Segurança [National Security Agency — NSA] dos Estados
Unidos, demonstrando que a agência era capaz de vigilar a Internet em uma
escala massiva com o sistema de vigilância PRISM e usando a interface XKeyscore
nos dados que acumulara. A notícia de que a vigilância governamental secreta
era possível e estava acontecendo não foi particularmente surpreendente para
engenheiros de rede e teóricos da conspiração, mas as revelações finalmente
deram ao público geral e não técnico uma ideia do quão seriamente os sistemas
proprietários sobre os quais eles haviam construído grande parte de suas vidas
digitais pode ser usado para prejudicá-los e comprometer sua privacidade.

Pessoas interessadas nos Estados Unidos são bastante conscientes de como o
abuso secreto do poder de exercer essa vigilância e as fracassadas moções do
Congresso dos Estados Unidos para cerceá-lo abalaram a confiança em seu próprio
governo. No entanto, as implicações dos vazamentos são também internacionais.
No meu próprio país, a Nova Zelândia, a agência de inteligência internacional,
o Escritório Governamental de Segurança nas Comunicações (GCSB), foi no início
do ano [acusado de espionar ilegalmente cidadãos neozelandeses][nzherald], e as
mensagens diplomáticas da WikiLeaks mostram que a GCSB [potencialmente já está
colaborando][wikileaks] com a NSA. Mesmo assim, novas leis estão definidas para
extender os poderes da GCSB, apesar de análises independentes [condenarem o
projeto de lei][lawsociety] tanto de uma perspectiva legal quanto do ponto de
vista dos direitos humanos, mesmo após as ementas. O escândalo e a ira sobre o
abuso da vigilância se estende ao [Reino Unido][guardian], [Alemanha][dw],
[Suécia][fra_law] e muitos outros países.

Realmente continuo com esperanças em esforços como a ação coletiva da
Electronic Frontier Foundation para reduzir a vigilância ou, no mínimo,
registrar a ira pública sobre essa invasão injustificada de nossas vidas
privadas. No entanto, estou preocupado não apenas pela possibilidade do
surgimento de um estado de vigilância global, mas pelas implicações que isso
tem no direito de proteger nossas comunicações utilizando a criptografia para
autenticação e encriptação.

Não é nenhum segredo que a criptografia e a encriptação [representam um
problema para os sistemas de vigilância da NSA][techdirt] e que eles despendem
muito esforço na tentativa de driblá-las, incluindo [a exigência das chaves
privadas][binsider] de empresas para aplicações como o HTTPS. Minha preocupação
é: caso se torne publicamente aceitável que governos espionem, sem mandados,
redes internacionais e que isso é justificável ou necessário, podemos atingir
um ponto no qual a própria legalidade do uso da criptografia pelo público geral
seja questionada.

Profissionais da área de computação da minha geração provavelmente não
começaram suas carreiras antes que o controle de exportação de criptografia dos
Estados Unidos fosse relaxado em 1999, talvez levando-nos a tomar como certo a
disponibilidade de algorítimos como o RSA e o AES com chaves grandes para
propósitos criptográficos. Um mundo no qual uma agência governamental tentaria
ativamente cercear o uso de tais tecnologias pode parecer inverossímil demais
para nós — talvez menos para quem se lembra que a [Pretty Good
Privacy][pgp_wikipedia] foi uma ideia radical que causou ao seu criador e
ativista, Phil Zimmermann, problemas legais reais.

Acredito que entusiastas da computação e usuários de sistemas operacionais
livres, não apenas experts em criptografia, estão numa posição especial para
ajudar seus amigos e familiares preocupados com a defesa de sua privacidade
online e a segurança de suas comunicações e que, se valorizamos tanto a
liberdade quanto a segurança da informação, como bons hackers fazem, temos, na
verdade, a responsabilidade de fazê-lo. Acredito que as pessoas precisam estar
conscientes não apenas das implicações da vigilância em massa numa escala
global, mas também de como exercitar seus direitos para lutar contra ela. Se a
legalidade da criptografia for algum dia questionada novamente, como um
resultado de seu impedimento da vigilância sem mandados judiciais, sua difusão
e a insistência do público em sua disponibilidade livre também deve tornar sua
restrição não apenas impraticável, mas impensável.

É por isso que apoio a [Electronic Frontier Foundation][eff], a [Free Software
Foundation][fsf] e qualquer um que apoie a liberdade e direito de todos para
usar a tecnologia segura e privadamente. Espero que qualquer pessoa que leia
este artigo considere fazer o mesmo.

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[linux_crypto_intro]: {% post_url 2013-09-16-linux_cripto_intro %}
[snowden_wikipedia]: https://en.wikipedia.org/wiki/Edward_Snowden
[nzherald]: http://www.nzherald.co.nz/nz/news/article.cfm?c_id=1&objectid=10885098
[wikileaks]: http://www.wikileaks.org/plusd/cables/04WELLINGTON662_a.html
[lawsociety]: https://www.lawsociety.org.nz/news-and-communications/news/august-2013/gcsb-bill-remains-flawed-despite-proposed-changes
[guardian]: http://www.theguardian.com/uk-news/2013/aug/01/nsa-paid-gchq-spying-edward-snowden
[dw]: http://www.dw.de/uproar-over-new-details-on-german-nsa-ties/a-16999179
[fra_law]: https://en.wikipedia.org/wiki/FRA_law
[techdirt]: http://www.techdirt.com/articles/20130725/00120423937/yes-nsa-has-always-hated-encryption.shtml
[binsider]: http://www.businessinsider.com.au/government-demands-encryption-keys-2013-7
[pgp_wikipedia]: https://en.wikipedia.org/wiki/Pretty_Good_Privacy
[eff]: https://www.eff.org/
[fsf]: https://my.fsf.org/
