---
layout: post
title: "Criptografia no Linux: Chaves do GnuPG"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt: Muitas ferramentas que usam criptografia no Linux e na internet centram-se no padrão de software Pretty Good Privacy (OpenPGP). O GNU Privacy Guard (GnuPG ou GPG) é uma implementação em software livre popular desse padrão.
---

Essa é o segundo post de uma série de dez posts traduzindo o original de Tom
Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma licença [Creative
Commons 3.0][cc].

Para a lista de posts, veja a [introdução][linux_crypto_intro].

---

Muitas ferramentas que usam criptografia no Linux e na internet centram-se no
padrão de software Pretty Good Privacy (OpenPGP). O GNU Privacy Guard (GnuPG ou
GPG) é uma implementação em software livre popular desse padrão.

No Debian, é possível instalar o GnuPG e sua interface, o `gpg(1)`, da seguinte
maneira:

    # apt-get install gnupg

Você pode fazer muitas coisas legais com o GPG, mas ele se resume a quatro
ideias centrais:

- A geração de **pares de chaves**, ou seja, pares de arquivos gerados
  aleatoriamente e vinculados matematicamente, um dos quais deve ser mantido
  permanentemente secreto (a **chave privada**) e um que deve ser publicado (a
  **chave pública**). Essa é a base da **criptografia de chave assimétrica**.
- O **gerenciamento** de chaves, tanto suas chaves públicas quanto as privadas,
  além das chaves públicas de outras pessoas, para que você possa verificar as
  suas mensagens e arquivos, ou criptografá-los para que apenas elas possam
  ler. Isso pode incluir a publicação de sua chave pública em servidores de
  chaves online e fazer com que outras pessoas assinem sua chave para confirmar
  que ela realmente é sua.
- A **assinatura** de arquivos e mensagens com sua chave privada, para que
  outras pessoas possam verificar que um arquivo ou mensagem foi criado ou
  assinado por você, e não foi editado durante a transmissão por canais
  não-confiáveis, como a internet. A mensagem em si ainda é legível por todos.
- A **criptografia** de arquivos e mensagens com as chaves públicas de outras
  pessoas, para que apenas elas possam, com suas chaves privadas,
  descriptografar e ler a mensagem. Você também pode assinar essas mensagens
  com sua própria chave privada para que elas possam verificar que ela foi
  enviada por você.

Iremos passar pelos fundamentais de cada uma dessas ideias. Não iremos nos
preocupar demais com a matemática ou os algorítimos por trás dessas operações;
o artigo da Wikipédia sobre a [criptografia de chave assimétrica][wikipedia]
[em inglês] explica esse aspecto muito bem para aqueles curiosos por mais
detalhes.

## Gerando um par de chaves

Vamos começar gerando um par de chaves RSA de 4096 bits, que deve ser mais do
que o suficiente para quase todos no momento da escrita deste artigo. Iremos
seguir algumas das [melhores práticas][debian_melhores_praticas] recomendadas
pelos desenvolvedores do Debian.

Fazer isso num computador privado e atualizado é o melhor, uma vez que é mais
fácil gerar entropia dessa maneira. Isso ainda é possível num servidor
acessível apenas por SSH, mas você pode ter que recorrer a métodos menos sãos,
criptograficamente falando, para gerar a aleatoriedade apropriada.


Crie ou edite o arquivo `~/.gnupg/gpg.conf` no seu sistema, e adicione as
seguintes linhas:

    personal-digest-preferences SHA256
    cert-digest-algo SHA256
    default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

Essas linhas informarão o GnuPG para usar o algorítimo de hashing SHA256 para
assinaturas, que é criptograficamente mais forte, em preferência ao [algorítimo
SHA1, há muito tempo quebrado][sha1].

Isso feito, podemos começar a gerar algumas chaves:

    $ gpg --gen-key

Você será solicitado a escolher o tipo de par de chaves que deseja. O padrão
deve ser RSA e RSA, o que significa que iremos gerar uma chave mestra para a
assinatura, e uma subchave para criptografia:

    Por favor selecione o tipo de chave desejado:
    (1) RSA and RSA (default)
    (2) DSA and Elgamal
    (3) DSA (apenas assinatura)
    (4) RSA (apenas assinatura)
    Sua opção? 1

Para o comprimento da chave, escolha o máximo (RSA 4096 bits):

    What keysize do you want? (2048) 4096
    O tamanho de chave pedido é 4096 bits

A data de validade cabe a você: se você está apenas brincando com o GnuPG no
momento, sinta-se livre para configurar uma validade curta. No entanto, se você
pretende usar o GnuPG por bastante tempo e está certo de que pode manter sua
chave indefinidamente segura, sinta-se à vontade para configurá-la para nunca
expirar, como farei aqui:

    Por favor especifique por quanto tempo a chave deve ser válida.
    0 = chave não expira
    <n>  = chave expira em n dias
    <n>w = chave expira em n semanas
    <n>m = chave expira em n meses
    <n>y = chave expira em n anos
    A chave é valida por? (0) 0

A seguir, algumas informações básicas são solicitadas para nomear a chave. Em
quase todas as circunstâncias você deveria usar seu nome real, já que sem um
meio de verificar sua identidade no mundo real, as chaves públicas são muito
menos úteis a longo prazo. Quanto ao comentário, você pode incluir o propósito
da chave, seus apelidos públicos ou qualquer outra informação relevante para a
chave:

    Nome completo: Timoteo Aspargos
    Endereço de correio eletrônico: taspargos@exemplo.com.br
    Comentário: Apenas para teste
    Você selecionou este identificador de usuário:
      "Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>"

    Muda (N)ome, (C)omentário, (E)ndereço ou (O)k/(S)air? O

## Senha da chave

A seguir, o programa pede uma senha para criptografar a chave. Assim, se ela
algum dia cair nas mãos erradas, ninguém poderá usá-la sem conhecer a senha.

    Você precisa de uma frase secreta para proteger sua chave.

Escolha uma sequência aleatória de palavras, ou possivelmente uma sentença
única que [você pode memorizar facilmente][xkcd] em qualquer língua. Quanto
maior, melhor. Não escolha nada que possa ser adivinhado na prática, como
provérbios ou frases de filmes. Você também terá de lembrar exatamente como
digitou a senha; recomendo utilizar todas as letras minúsculas e sem pontuação.
A Wikipédia tem [algumas orientações aqui][wiki_senha].

Você precisará digitar a senha duas vezes para confirmá-la, e o programa não
irá mostrá-la no terminal, como se você estivesse digitando uma senha.

## Geração de entropia

Finalmente, o sistema irá pedir que geremos alguma entropia:

    Precisamos gerar muitos bytes aleatórios. É uma boa idéia realizar outra
    atividade (digitar no teclado, mover o mouse, usar os discos) durante a
    geração dos números primos; isso dá ao gerador de números aleatórios
    uma chance melhor de conseguir entropia suficiente.

Esse passo é necessário para que o computador gere informação aleatória o
suficiente para assegurar que a chave privada que está sendo gerada não possa
ser viavelmente reproduzida. Mover o mouse e usar o teclado é o ideal, mas
gerar qualquer tipo de atividade no hardware (incluindo girar os discos) deve
servir. Rodar operações dispendiosas com o `find(1)` num sistema de arquivos
(com conteúdos que não possar ser razoavelmente preditos ou adivinhados) também
ajuda.

Esse passo se beneficia de sua paciência. Você pode encontrar discussões online
sobre forçar o uso do gerador de números pseudo-aleatórios /dev/urandom ao
invés disso, usado uma ferramenta como o `rngd(1)`. Isso definitivamente
acelera o processo, mas se você irá usar a sua chave para qualquer atividade
séria, recomendo realmente interagir com o computador usando o ruído do
hardware para alimentar a aleatoriedade adequadamente, se você puder.

Quando entropia o suficiente é lida e a chave terminar de ser gerada, alguns
detalhes da sua chave mestra e sua subchave serão apresentados, e as chaves
privadas e públicas para cada uma serão automaticamente adicionadas ao seu
chaveiro para uso posterior:

    gpg: /home/tim/.gnupg/trustdb.gpg: banco de dados de confiabilidade criado
    gpg: key 1FC2985D marked as ultimately trusted
    chaves pública e privada criadas e assinadas.
    gpg: a verificar a base de dados de confiança
    gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
    gpg: depth: 0  valid:   3  signed:   1  trust: 0-, 0q, 0n, 0m, 0f, 3u
    gpg: depth: 1  valid:   1  signed:   0  trust: 1-, 0q, 0n, 0m, 0f, 0u
    pub   4096R/1FC2985D 2013-08-22
          Key fingerprint = A577 2F62 9827 BCF1 D03C  0817 DAB9 E4A0 1FC2 985D
          uid                  Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>
          sub   4096R/E458D7E5 2013-08-22

## Gerenciando chaves

Com isso feito, adicionamos nossas próprias chaves ao chaveiro privado e
público:

    $  gpg --list-secret-keys 
    /home/tim/.gnupg/secring.gpg
    -----------------------------------
    sec   4096R/1FC2985D 2013-08-22
    uid                  Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>
    ssb   4096R/E458D7E5 2013-08-22

    $  gpg --list-public-keys 
    /home/tim/.gnupg/pubring.gpg
    -----------------------------------
    pub   4096R/1FC2985D 2013-08-22
    uid                  Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>
    sub   4096R/E458D7E5 2013-08-22

O diretório `~/.gnupg` contém as chaves gerenciadas. É muito, mas muito
importante manter esse diretório privado e fazer o seu backup seguramente,
preferivelmente em uma mídia removível que você possa manter em algum local
fisicamente seguro. Não o perca!

Na maior parte dos contextos no GnuPG, você pode se referir à chave pelo nome
do seu dono ou pela sua identificação hexadecimal de oito dígitos. Eu prefiro o
último método. Nesse caso, a identificação curta da minha chave principal é
1FC2985D. Embora você não deva usá-la para fazer nenhum tipo de verificação,
ela é suficientemente única para identificar uma chave específica no seu
chaveiro.

Por exemplo, se você desejar enviar uma cópia de sua chave púbica a alguém, uma
maneira amigável de fazê-lo é exportá-la no formato ASCII com a opção
`--armor`, fornecendo a identificação curta da chave apropriada:

    $ gpg --armor --export 1FC2985D > tim-aspargos.public.asc

Embora você possa exportar chaves privadas da mesma maneira, usando a opção
`--export-secret-key`, você nunca, nunca mesmo, deve fornecer sua chave privada
a ninguém, então ela não deve ser necessária.

## O certificado de revogação

Depois de gerar suas chaves, você deve gerar um **certificado de revogação**.

    gpg --output revoke.asc --gen-revoke 1FC2985D 

    sec  4096R/1FC2985D 2013-08-22 Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>

    Create a revocation certificate for this key? (y/N) y
    Please select the reason for the revocation:
    0 = Nenhum motivo especificado
    1 = A chave foi comprometida
    2 = A chave foi substituída
    3 = A chave já não é utilizada
    Q = Cancel
    (Probably you want to select 1 here)
    Sua decisão? 1
    Enter an optional description; end it with an empty line:
    > 
    Reason for revocation: A chave foi comprometida
    (No description given)
    Is this okay? (y/N) y

    You need a passphrase to unlock the secret key for
    user: "Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>"
    4096-bit RSA key, ID 1FC2985D, created 2013-08-22

    Please move it to a medium which you can hide away; if Mallory gets
    access to this certificate he can use it to make your key unusable.
    It is smart to print this certificate and store it away, just in case
    your media become unreadable.  But have some caution:  The print system of
    your machine might store the data and make it available to others!

Você deve guardar o arquivo resultante, `revoke.asc`, em algum local seguro.
Você pode usar esse certificado para [revogar][revogar] sua chave mais tarde,
caso a chave privada seja comprometida, para que as pessoas saibam que a chave
não é mais confiável nem pode ser usada. Você pode até mesmo imprimir e manter
uma cópia impressa, como o `gpg` sugere.

Com a configuração acima concluída, podemos proceder com o uso básico do GnupG,
como discutido no próximo artigo.

## Subchaves

Na saída de ambos os comandos, é possível notar que na verdade temos duas
chaves privadas e duas chaves públicas. A linha `sub` se refere à subchave de
criptografia, gerada automaticamente para você. A chave mestra é usada para a
assinatura criptográfica, e a subchave para a encriptação; é assim que o GnuPG
opera por padrão com pares de chaves RSA.

Para mais segurança, pode ser apropriado fisicamente mover a chave mestra do
seu computador e usar uma segunda subchave gerada para assinar arquivos. Isso é
desejável por lhe permite manter sua chave mestra segura em alguma mídia
removível (preferivelmente com um backup) e não carregada no seu computador
principal, caso você seja comprometido.

Dessa maneira, você pode assinar e criptografar arquivos normalmente com sua
subchave de assinatura e sua subchave de criptografia. Se essas chaves forem
algum dia comprometidas, você pode simplesmente revogá-las e gerar novas com
sua chave mestra, que não foi comprometida. Além disso, todos aqueles que já
assinaram ou de outra maneira demonstraram sua confiança em sua chave mestra
não terão de fazê-lo novamente.

Para detalhes sobre como efetuar esse procedimento, sugiro a leitura desse
[artigo na Debian Wiki sobre gerenciamento de subchaves][debian_subchaves].
Elas não são, no entanto, necessárias para efetuar operações básicas com o GPG.

Essa entrada é a parte 2 de 10 na série [Criptografia no
Linux][linux_crypto_intro].

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[linux_crypto_intro]: #
[wikipedia]: http://en.wikipedia.org/wiki/Public-key_cryptography
[debian_melhores_praticas]: http://keyring.debian.org/creating-key.html
[sha1]: http://www.schneier.com/blog/archives/2005/02/cryptanalysis_o.html
[xkcd]: http://xkcd.com/936/
[wiki_senha]: http://en.wikipedia.org/wiki/Passphrase#Passphrase_selection
[revogar]: http://www.gnupg.org/gph/en/manual.html#AEN305
[debian_subchaves]: http://wiki.debian.org/subkeys
