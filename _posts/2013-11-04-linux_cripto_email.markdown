---
layout: post
title: "Criptografia no Linux: Email"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt: "Um sistema de armazenamento criptografado de senhas é um bom começo, mas agora que temos uma instalação do GnuPG em funcionamento, devemos considerar o uso do PGP para aquilo que foi originalmente criado: emails. Para isso, usaremos o mutt."
---

Este é o sétimo post de uma série de dez posts traduzindo o original de Tom
Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma licença [Creative
Commons 3.0][cc].

Para a lista de posts, veja a [introdução][linux_crypto_intro].

---

Um sistema de armazenamento de senhas criptografado é um bom começo, mas agora
que temos uma instalação do GnuPG em funcionamento, devemos considerar o uso do
PGP para aquilo que foi originalmente criado: emails. Para isso, usaremos o
[Mutt][mutt].

O Mutt é um cliente de email para o console, ou MUA (do inglês _mail user
agent_), projetado sobretudo para gerenciar e ler emails. Ao contrário de
outros clientes como o [Thunderbird][thunderbird], ele não foi projetado para
ser um cliente POP3/IMAP, ou um agente SMTP, embora versões mais recentes
incluam essa funcionalidade; essas são operações realizadas por programas como
o [Getmail][getmail] e o [MSMTP][msmtp].

Se, como muitas outras pessoas, você estiver usando o Gmail, o Mutt funciona
muito bem com POP3/IMAP e SMTP, permitindo que você componha mensagens em texto
plano, com seu editor de escolha, numa janela de terminal, num ambiente
altamente configurável e utilizando sua própria criptografia para email, para
qualquer comunicação confidencial, de maneira que nem mesmo o seu provedor de
email possa lê-la.

O uso geral do Mutt e a configuração para usuários do Gmail não será coberta em
detalhes aqui. Por enquanto, existem muitos [artigos excelentes][corner] sobre
a configuração básica do Mutt. Se você está interessado na configuração de
outros clientes de email para o Linux, como o [Claws][claws] ou o Thunderbird,
o Cory Sadowski tem um [ótimo passo-a-passo][sadowski], além de comentar sobre
outras configurações de privacidade relevantes tanto no GNU/Linux quanto no
Windows.

As instruções abaixo presumem que você já tem um [par de chaves
GnuPG][gnupg_intro] pronto, com o [`gpg-agent(1)`][agentes] rodando no
background para gerenciar suas chaves.

## Background

A maioria dos [guias de configuração do PGP para o Mutt][pgp_guia] online são
bastante antigos e geralmente sugerem muitas linhas para o arquivo de
configuração, `.muttrc`, que lidam diretamente com o comando `gpg`, com uma
miríade de opções e algumas substituições de variáveis obscuras:

    set pgp_clearsign_command="gpg --no-verbose --batch --output - ...
    set pgp_decode_command="gpg %?p?--passphrase-fd 0? --no-verbose ...
    set pgp_decrypt_command="gpg --passphrase-fd 0 --no-verbose --batch ...
    set pgp_encrypt_only_command="pgpewrap gpg --batch --quiet ...
    set pgp_encrypt_sign_command="pgpewrap gpg --passphrase-fd 0 ...
    set pgp_export_command="gpg --no-verbose --export --armor %r"
    set pgp_import_command="gpg --no-verbose --import -v %f"
    set pgp_list_pubring_command="gpg --no-verbose --batch --with-colons ...
    set pgp_list_secring_command="gpg --no-verbose --batch --with-colons ...
    set pgp_sign_command="gpg --no-verbose --batch --output - ...
    set pgp_verify_command="gpg --no-verbose --batch --output - --verify %s %f"
    set pgp_verify_key_command="gpg --no-verbose --batch --fingerprint ...

Sou completamente a favor da filosofia do Unix de usar os programas em
conjunto, mas isso é demais. Essa configuração é volúvel e muito difícil de
trabalhar, além de requerer conhecimento demais do `gpg(1)` para ser usada e
editada sensatamente. Afinal de contas, queremos uma configuração que possamos
entender razoavelmente bem.

Então esqueça tudo aquilo; ao invés disso, iremos usar o [GPGME][gpgme]. A
configuração acima é exatamente o problema que essa biblioteca foi projetada
para resolver: os aplicativos podem se ligar a ela para simplificar o uso das
funções do GnuPG, incluindo a interface com agentes. Podemos substituir todas
as linhas acima com o seguinte:

    set crypt_use_gpgme = yes

## Instalação

Se você tem o Mutt instalado, há chances que ele já possua uma interface para o
GPGME. Você pode checar se sua versão atual do Mutt é capaz de utilizá-lo com a
saída de `mutt -v version`. Essa é a saída do meu, usando o Mutt empacotado
para o Debian GNU/Linux, que suporta o GPGME:

    $ mutt -v | grep -i gpgme
    +CRYPT_BACKEND_CLASSIC_PGP  +CRYPT_BACKEND_CLASSIC_SMIME  +CRYPT_BACKEND_GPGME
    upstream/548577-gpgme-1.2.patch

Se você não tem uma versão do Mutt com GPGME, você pode fazer o download do
código fonte e compilá-lo com a opção `--enable-gpgme`:

    $ ./configure --enable-gpgme
    $ make
    # make install

Você pode ter de instalar a biblioteca GPGME e suas headers antes disso:

    # apt-get install libgpgme11 libgpgme11-dev

## Configuração

Adicione as seguintes linhas ao arquivo `.muttrc`; remova qualquer texto que
comece por `crypt_*` ou `pgp_*`:

    # Use o GPGME
    set crypt_use_gpgme = yes

    # Assine as respostas para emails já assinados
    set crypt_replysign = yes

    # Criptografe as respostas para emails já criptografados
    set crypt_replyencrypt = yes

    # Criptografe e assine as respostas para emails já criptografados e assinados
    set crypt_replysignencrypted = yes

    # Tente verificar assinaturas automaticamente
    set crypt_verify_sig = yes

Reinicie o Mutt e pronto.

## Uso

Primeiramente, verifique se você tem a chave pública do seu destinatário
disponível em seu chaveiro do GnuPG:

    $ gpg --list-keys joao@exemplo.com.br

Se ela estiver disponível para download, você pode baixá-la usando o
[`curl(1)`][curl] e importá-la diretamente com o `gpg(1)`:

    curl http://www.exemplo.com.br/joao-ninguem.asc | gpg --import
    gpg: key 1234ABCD: public key "João Ninguém" imported
    gpg: Total number processed: 1
    gpg:               imported: 1  (RSA: 1)
    gpg: no ultimately trusted keys found

Lembre-se: é sua responsabilidade decidir o grau de confiança que tem nessa
chave; normalmente, a melhor prática é que vocês se encontrem em pessoa para
trocar as fingerprints das chaves, de modo que se tenha certeza absoluta de que
a chave corresponde àquele usuário.

Se você conhece mais ninguém que use o PGP para se comunicar, você pode me
enviar uma mensagem criptografada com minha chave pública,
[0x77BB8872][tom_key], para `tom@sanctum.geek.nz` (em inglês). Caso você me
envie sua chave pública, ou insira um link em sua mensagem, irei respondê-la
com outra mensagem criptografada com a sua chave pública, para que você pode
verificar se tudo está funcionando.

    $ curl http://static.sanctum.geek.nz/thomas-ryder.asc | gpg --import

Você também pode enviar uma mensagem criptografada com a chave pública do
tradutor desse artigo, [0x2D4BF1D0][rberaldo_key], para
`rberaldo@cabaladada.org` (em português ou inglês).

    $ curl http://www.cabaladada.org/public/rberaldo.asc | gpg --import

Voltando ao Mutt, comece a compor sua mensagem com a tecla `m`. Preencha os
campos de destinatário e assunto normalmente e escreva sua mensagem. Quando
terminar, salve e saia do `$EDITOR` e sua mensagem estará em sua tela de
Composição, esperando para ser enviada. Aperte `p` para acessar o menu do PGP,
que aparecerá na parte de baixo da tela:

    PGP (e)ncrypt, (s)ign, sign (a)s, (b)oth, s/(m)ime or (c)lear?

Pressione `b` para assinar e criptografar a mensagem.

Caso você queira ser capaz de ler a mensagem após enviá-la, será necessário
criptografá-la tanto com a sua chave quanto com a do destinatário. Em minha
experiência, a maneira mais simples de fazer isso é adicionar o seu próprio
endereço ao campo `Bcc:` pressionando `b`. Você também pode deixar esse
comportamento como padrão com a seguinte linha em `~/.gnupg/gpg.conf`, onde
`0x1234ABCD` é a ID curta de sua chave:

    encrypt-to 0x1234ABCD

![Tela de Composição do Mutt](/assets/images/mutt-compose.png "Tela de composição do Mutt")

Quando você enviar a mensagem pressionando `y`, talvez seja necessário
especificar quais chaves você deseja usar para quais destinatários, se você não
possuir uma única chave para aquele endereço de email.

Além disso, você terá de inserir a senha de sua chave privada, que será
requerida pelo programa de entrada de PIN, a menos que um agente já a tenha
carregada. A senha é necessária para assinar a mensagem. Quando você a
fornecer, a mensagem será enviada e, caso você tenha se inserido no campo
`Bcc:`, você também deve ser capaz de lê-la em seus emails enviados, com alguns
cabeçalhos mostrando informações do PGP (se a mensagem foi assinada,
criptografada ou ambos):

![Tela de Mensagens Enviadas do Mutt](/assets/images/mutt-sent.png "Tela de mensagens enviadas do Mutt")

O destinatário será capaz de descriptografar a mensagem usando sua chave
privada, e ninguém mais além de vocês dois poderá lê-la. Note que isso funciona
qualquer que seja número de destinatários, desde que você tenha a chave pública
de cada um deles.

Lembre-se que os metadados da mensagens, tais como os nomes e endereços dos
remetentes e destinatários, o dia e a hora em que foi enviada e
(principalmente) o assunto, são enviados em texto plano. Apenas o corpo da
mensagem (incluindo os anexos) é criptografado.

## Alguns extras úteis

Com o GPGME, o Mutt tenta utilizar a primeira chave secreta disponível no
chaveiro privado. Caso você queira utilizar outro par de chaves específico para
assinar mensagens, você pode especificá-lo com a opção `pgp_sign_as` no arquivo
`.muttrc`:

    set pgp_sign_as = 0x9876FEDC

Se você deseja assinar automaticamente todas as mensagens que enviar, você pode
configurar a opção `crypt_autosign`:

    set crypt_autosign = yes

O primeiro conjunto de opções que configuramos anteriormente irá assinar e/ou
criptografar mensagens automaticamente, em respostas para mensagens assinadas,
criptografados ou ambos.

Se você desejar incluir um link para a sua chave PGP nos cabeçalhos das
mensagens, é possível adicionar uma header personalizada com a opção `my_hdr`:

    my_hdr X-PGP-Key: http://static.sanctum.geek.nz/thomas-ryder.asc

Todos esses aspectos, combinados com a rapidez e a configuração poderosa do
Mutt, o tornam um cliente de email PGP conveniente e muito capaz. Como sempre,
quanto mais pessoas que você conhecer utilizarem o PGP, e quanto mais chaves
públicas você tiver, mais útil ele será.

Essa entrada é a parte 7 de 10 na série [Criptografia no
Linux][linux_crypto_intro].

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[linux_crypto_intro]: {% post_url 2013-09-16-linux_cripto_intro %}
[mutt]: http://www.mutt.org/
[thunderbird]: http://www.mozilla.org/en-US/thunderbird
[getmail]: http://pyropus.ca/software/getmail/
[msmtp]: http://msmtp.sourceforge.net/
[corner]: http://www.andrews-corner.org/mutt.html
[claws]: http://www.claws-mail.org/
[sadowski]: http://probablytechrelated.wordpress.com/2013/07/01/basic-privacy-security-and-encryption-on-the-internet/
[gnupg_intro]: #
[agentes]: #
[pgp_guia]: http://dev.mutt.org/trac/wiki/MuttGuide/UseGPG
[gpgme]: http://www.gnupg.org/related_software/gpgme/
[curl]: http://linux.die.net/man/1/curl
[tom_key]: http://static.sanctum.geek.nz/thomas-ryder.asc
[rberaldo_key]: http://cabaladada.org/public/rberaldo.asc
