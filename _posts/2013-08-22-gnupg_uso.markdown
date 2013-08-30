---
layout: post
title: "Criptografia no Linux: Usando o GnuPG"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt: Com nossas chaves privada e públicas criadas e guardadas, podemos começar usar alguns dos recursos do GnuPG para assinar, verificar, criptografar e descriptografar arquivos e mensagens para distribuição em canais não confiáveis, como a internet.
---

Essa é o terceiro post de uma série de dez posts traduzindo o original de Tom
Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma licença [Creative
Commons 3.0][cc].

Para a lista de posts, veja a [introdução][linux_crypto_intro].

---

Com nossas chaves privada e públicas criadas e guardadas, podemos começar usar
alguns dos recursos do GnuPG para assinar, verificar, criptografar e
descriptografar arquivos e mensagens para distribuição em canais não
confiáveis, como a internet.

## Assinando uma mensagem ou arquivo de texto

Começaremos assinando um simples arquivo de texto, usando a opção
`--clearsign`. Ela inclui a assinatura na mensagem, o que significa que podemos
distribuí-la para outras pessoas lerem. Esse é o conteúdo de `mensagem.txt`:

    Essa é uma mensagem pública de Timoteo Aspargos.

Assinamos a mensagem com nossa nova chave privada da seguinte maneira:

    $ gpg --clearsign mensagem.txt

Nossa senha da chave privada é solicitada:

    You need a passphrase to unlock the secret key for
    user: "Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>"
    4096-bit RSA key, ID 1FC2985D, created 2013-08-22

Após provê-la, o arquivo `mensagem.txt.asc` é criado, com seções do PGP e uma
assinatura ASCII em texto plano:

    -----BEGIN PGP SIGNED MESSAGE-----
    Hash: SHA256

    Essa é uma mensagem pública de Timoteo Aspargos
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v2.0.21 (GNU/Linux)

    iQIcBAEBCAAGBQJSFqZjAAoJENq55KAfwphdJcYQAM1xBX1fU91rSKBH05MDpKNp
    l+y834JPR4P1Zwp6pK0BMXBxfL+xk4V7DAMXOmw6iFpGsxhW/f3ehnIPghH5PkLs
    FbdHTWFrxuGBge0B+f7AwAaVabvbcgSL3H7F3QxxXcrdWCajlbX+zKx5o+DlKYMC
    uQK0yczfUS0WBTnRMFb//NW7HrS9DU6hydAjNV3+m/NJXvOmh5H2H6dvJM8hxfPR
    MdmEYJ8gHPTXIwd+Xtt+0VlwPLOMD76S3S3rpaC5taM7qbxvya/xmvlxDqRIo3sP
    Az1552h86HPJEjDg2j5sF6YCvVl5Aq2dJfPqVy4ZuB7wyaKhk2JIFgIs/M4VFptH
    AvJaE5FcMdAhz3eWHdCIqvSuTjmf/ZXn8BlbMugkSitKzbUvxVGoPv/gYzMKJhIl
    SFCeyJxGl1t6tKYK3iXh+Ady4AzscjYXcfK9yCPtkITPQyRYN51qBDNWR55Raznf
    SybLYbRRdiZz7XuiUozy+CjvduEjw3bmFFOwpE9HCkQeyu+PPf3PszbhFcm8Wav2
    OM3fmLhCEcFnIh/mIn/SveTE8Br9tyHJpSmk11sWjPFkT+fAKDTq5YeIZHXVk2Av
    X6P8Lxenfuj0+Grk8DEZnA3bTmNP52+kJ0v2UrdjIcheigPXrY5pY0iBOdG+/S1k
    MUN9XbXKNxrx4CAwDKXY
    =Lmvn
    -----END PGP SIGNATURE-----

Note que a própria mensagem é nitidamente legível; ela não está criptografada,
apenas verificada como escrita por uma pessoa em particular e não alterada
desde então.

Agora, qualquer um que tenha sua chave pública no chaveiro (como nós mesmos)
pode verificar que ela foi realmente escrita por nós:

    $ gpg --verify mensagem.txt.asc
    gpg: Signature made Qui 22 Ago 2013 21:01:39 BRT using RSA key ID 1FC2985D
    gpg: Good signature from "Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>"

Se alguém adulterar a mensagem, mesmo que remova apenas um ponto final de uma
frase, a verificação falhará, sugerindo que a mensagem foi alterada:

    $ gpg --verify mensagem.txt.asc
    gpg: Signature made Qui 22 Ago 2013 21:01:39 BRT using RSA key ID 1FC2985D
    gpg: BAD signature from "Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>"

## Assinando e verificando arquivos binários

Para todos os outros arquivos, provavelmente teremos de criar um arquivo de
assinatura separado com uma **assinatura avulsa**:

    $ gpg --armor --detach-sign arquivo.tar.gz

O comando produz um arquivo chamado `arquivo.tar.gz.asc` no mesmo diretório,
contendo a assinatura. Usamos `--armor` para deixar a assinatura em ASCII, o
que a torna mais longa porém mais fácil para a distribuição online.

Nesse caso, tanto o arquivo quanto a assinatura são necessários para a
verificação; coloque o arquivo de assinatura em primeiro lugar quando for
checar, dessa maneira:

    $ gpg --verify arquivo.tar.gz.asc arquivo.tar.gz

Você pode usar esse método para verificar software baixado de fontes
confiáveis, como do [time de desenvolvimento do Apache HTTPD][apache_httpd].
Primeiramente, faríamos o download e importaríamos todas as chaves públicas a
partir da URL que o time indica:

    $ wget http://www.apache.org/dist/httpd/KEYS
    $ gpg --import KEYS


Poderíamos, então, baixar uma versão do Apache HTTPD, juntamente de sua chave,
de um mirror arbitrário:

    $ wget http://www.example.com/apache/httpd/httpd-2.4.4.tar.gz
    $ wget https://www.apache.org/dist/httpd/httpd-2.4.4.tar.gz.asc

Podemos então usar a chave e a assinatura para verificar que essa é uma cópia
não comprometida do arquivo original assinado pelos desenvolvedores:

    $ gpg --verify httpd-2.4.4.tar.gz.asc httpd-2.4.4.tar.gz
    gpg: Signature made Tue 19 Feb 2013 09:28:39 NZDT using RSA key ID 791485A8
    gpg: Good signature from "Jim Jagielski (Release Signing Key) <jim@apache.org>"
    gpg:                 aka "Jim Jagielski <jim@jaguNET.com>"
    gpg:                 aka "Jim Jagielski <jim@jimjag.com>"
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.
    Primary key fingerprint: A93D 62EC C3C8 EA12 DB22  0EC9 34EA 76E6 7914 85A8

Note que a saída do `gpg` adverte que essa ainda não é uma garantia perfeita de
que a versão de fato veio de Jim Jaielski, porque nunca o encontramos e não
podemos absolutamente, definitivamente dizer que essa é sua chave pública. No
entanto, ao buscá-lo nos servidores públicos de chaves, podemos ver que muitos
outros dos desenvolvedores do Apache assinaram sua chave, o que parece
promissor. Mas nós sabemos quem *eles* são?

Quando baixamos de mirrors, apesar da falta de certeza absoluta, essa
verificação é muito melhor (e torna mais difícil explorar falhas de segurança)
do que simplesmente baixar sem validar ou executar uma soma de verificação,
dado que a assinatura e o arquivo `KEYS` foi baixado do próprio site da Apache.

Você terá de decidir para si mesmo [qual o grau de certeza
necessário][validando_chaves] para confiar que a chave pública de alguém
realmente corresponde a ela. Esse grau de certeza pode se estender até o ponto
de combinar um encontro com essa pessoa, verificando sua identidade com
documentos de identificação expedidos pelo governo!

## Criptografando um arquivo

Podemos criptografar um arquivo de maneira que apenas as pessoas nomeadas
possam descriptografá-lo e lê-lo. Nesse caso, devemos criptografá-lo não com
nossa própria chave privada, mas com a chave pública do destinatário. Dessa
maneira, apenas ele será capaz de descriptografar o arquivo usando sua chave
privada.

Esse é o conteúdo do arquivo `mensagem-secreta.txt`:

    Essa é uma mensagem secreta de Timoteo Aspargos.

Now we need at least one recipient. Let’s say this message was intended for my friend John Public. He’s given me his public key in a file called john-public.asc on a USB drive in person; he even brought along his birth certificate and driver’s license (which is weird, because I’ve known him since I was four).

Agora, precisamos de pelo menos um destinatário. Digamos que essa mensagem é
destinada ao meu amigo, João Público. Ele me entregou sua chave pública, em
pessoa, em um arquivo chamado `joao-publico.asc` num pendrive; ele trouxe até
mesmo a sua carta de motorista e sua certidão de nascimento (o que é estranho,
porque o conheço desde que tinha quatro anos de idade).

Para começar, irei importar sua chave para meu chaveiro:

$ gpg --import joao-publico.asc
gpg: key 695195A5: public key "João Público (Chave principal) <joaopublico@exemplo.com.br>" imported
gpg: Número total processado: 1
gpg:               imported: 1  (RSA: 1)

Agora podemos criptografar a mensagem para que apenas o João leia. Gosto de
usar o código hexadecimal de oito dígitos para o `--recipient`, para ter
certeza de que selecionei a pessoa certa. Você pode ver esse código na saída
acima, ou na saída de `gpg --list-keys`.

    $ gpg --armor --recipient 695195A5 --encrypt mensagem-secreta.txt

A mensagem secreta é gravada em `mensagem-secreta.txt.asc`.

    -----BEGIN PGP MESSAGE-----
    Version: GnuPG v1.4.10 (GNU/Linux)

    hQEMAxiBb8eWSupuAQgAgOUQvqbTh60N6RQhDtP/bY9l+gjm4Grx5XcuhgQqK6pn
    YtyPTKcpHdPK679lhbv0vE0RYe7pL+nBOngU1hCQYuGbRDZDxIXTIZW/rBvXbtHA
    jgeSxrquad2totfh2nc7upePVCqXncPrLraJyDJBLLMrBHVvmOZymDabJbemOFuq
    A/NbcmT3+osptvaEPFdlbgAW+J3vGxXMuQQYkT8GSnuutfEhZRb7SEL1ktaXwaMc
    AA6NAan5ak7nCyDDHhDSDFMS9SQQHd8TDvQPF6OzRXlq26EOFD8HvlbDcgc51lbS
    +N5nWaHM/CiuPh9dIOEV0H4Y8WDBdgkxp6kXKQfqb9JzAdwQ047r82SJAA7MSqCS
    HRVtCRf5SNM12HqTRzF9XXum4uG+HXT6Bpy+K/lYpLgmHcHoUVKh8c2OcGaCHWQh
    UC9B+aaThKdkxUfD/9tVIRmugjutgj7KdtDTGm+qLeCoJqp6HK5z5SX8Ha+P6/P5
    hxinyw==
    =kqUG
    -----END PGP MESSAGE-----

Note que até mesmo eu não posso lê-la, porque não me adicionei na lista de
destinatários e não tenho acesso à chave privada de João:

    tim@timbox:~$ gpg --decrypt mensagem-secreta.txt.asc
    gpg: encrypted with 2048-bit RSA key, ID 964AEA6E, created 2013-03-10
        "João Público (Chave principal) <joaopublico@exemplo.com.br>"
        gpg: descriptografia falhou: chave secreta não disponível

No entanto, no computador do João, usando sua chave privada, ele pode
descriptografar e ler o arquivo:

    joao@joaobox:~$ gpg --decrypt mensagem-secreta.txt.asc
    gpg: encrypted with 2048-bit RSA key, ID 964AEA6E, created 2013-03-10
        "João Público (Chave principal) <joaopublico@exemplo.com.br>"
    Essa é uma mensagem secreta de Timoteo Aspargos.

Se eu quisesse ter certeza de que eu poderia ler a mensagem também, adicionaria
minha própria chave pública para me identificar como um destinatário quando
criptografasse a mensagem. Assim, ambos poderíamos ler a mensagem com nossas
chaves privadas (independentemente um do outro).

    $ gpg --recipient 695195A5 --recipient 1FC2985D \
        --armor --encrypt mensagem-secreta.txt

Só para ser completos, podemos também assinar a mensagem para provar que ela veio de nós:

    $ gpg --recipient 695195A5 --recipient 1FC2985D \
        --armor --sign --encrypt mensagem-secreta.txt

Quando o João rodar a opção `--decrypt`, o `gpg` irá automaticamente verificar
a assinatura, desde que ele tenha minha chave pública em seu chaveiro:

    $ gpg --decrypt mensagem-secreta.txt.asc
    gpg: encrypted with 2048-bit RSA key, ID 964AEA6E, created 2013-03-10
        "João Público (Chave principal) <joaopublico@exemplo.com.br>"
    gpg: encrypted with 4096-bit RSA key, ID 1FC2985D, created 2013-08-22
        "Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>"
    Essa é uma mensagem secreta de Timoteo Aspargos.
    gpg: Signature made Qui 22 Ago 2013 17:23:20 BRT using RSA key ID 1FC2985D
    gpg: Good signature from "Timoteo Aspargos (Apenas para teste) <taspargos@exemplo.com.br>"

Essas são todas as funções básicas do GnuPG que são úteis para a maior parte
das pessoas. Nós não consideramos nesse artigo o [envio de nossas chaves a
servidores públicos][servidores_publicos] ou a participação em uma [rede de
confiança][rede_confianca]. Você deve procurar mais informações sobre esses
assuntos apenas quanto que estiver feliz com a configuração e funcionamento de
suas chaves e estiver pronto para publicar suas chaves para uso público.

Essa entrada é a parte 3 de 10 na série [Criptografia no
Linux][linux_crypto_intro].

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[linux_crypto_intro]: #
[apache_httpd]: http://httpd.apache.org/dev/verification.html
[validando_chaves]: http://www.gnupg.org/gph/en/manual.html#AEN335
[servidores_publicos]: http://www.gnupg.org/gph/en/manual.html#AEN464
[rede_confianca]: http://en.wikipedia.org/wiki/Web_of_trust
