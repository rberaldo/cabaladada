---
layout: post
title: "Criptografia no Linux: Chaves SSH"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt: "O método mais comum de autenticação a um servidor OpenSSH é a inserção de sua senha na máquina remota. Esse método é apropriado para o primeiro contato com a máquina e é suportado de fábrica pelo ssh(8). Porém, ele também é alvo de ataques constantes. Iremos investigar a configuração e uso de chaves SSH como alternativa para a autenticação por meio de senhas."
---

Este é o quarto post de uma série de dez posts traduzindo o original de Tom
Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma licença [Creative
Commons 3.0][cc].

Para a lista de posts, veja a [introdução][linux_crypto_intro].

---

O método mais comum de autenticação a um servidor OpenSSH é a inserção de sua
senha na máquina remota:

    tim@local:~$ ssh remoto
    The authenticity of host 'remoto (192.168.0.64)' can't be established.
    RSA key fingerprint is d1:35:45:a6:d1:b2:e4:08:f8:67:b1:19:fe:04:ca:1c.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added 'remoto,192.168.0.64' (RSA) to the list of known hosts.
    tim@remoto's password:

    tim@remoto:~$

Esse método é apropriado para o primeiro contato com a máquina e é suportado de
fábrica pelo `sshd(8)` na maior parte das instalações do OpenSSH.

O `sshd(8)` é um alvo muito comum de ataques, particularmente de ataques
automáticos. Bots mal-intencionados tentam se conectar a servidores escutando a
porta padrão do SSH, `tcp/22`, bem como algumas alternativas comuns, como a
`tcp/2222`. Se você impor uma política de senhas altamente seguras em seu
sistema, isso geralmente não é um grande problema, especialmente se apenas os
usuários apropriados possuírem acesso à linha de comando, ou se você restringir
as conexões SSH a certos usuários ou grupos.

Existem outras medidas para se defender contra ataques automáticos, tais como a
aplicação de sistemas como o [fail2ban][fail2ban], que rejeita clientes que
realizam muitas tentativas falhas de conexão. No entanto, a maneira
possivelmente mais efetiva de sabotar ataques automáticos é ignorar
completamente as senhas e utilizar **chaves SSH**, permitindo apenas esse
método de conexão às máquinas relevantes.

## Como as chaves funcionam

Assim como na configuração de chaves para o GnuPG nos dois primeiros artigos
desta série, pares de chaves SSH são compostos de uma **chave privada** e uma
**chave pública**, dois arquivos vinculados criptograficamente. As chaves para
autenticação são baseadas na ideia de que se alguém possui sua chave pública,
essa pessoa é capaz de autenticá-lo ao requerer operações que podem ser
realizadas apenas com a chave privada correspondente; o funcionamento é similar
à **assinatura** criptográfica.

Esse método é efetivo pois requer uma chave pública válida para realizar a
autenticação. Com uma chave longa o suficiente, torna-se efetivamente
impossível que um invasor adivinhe seus detalhes de autenticação; não existe
uma chave privada “comum” para adivinhar. Desse modo, os invasores teriam de
testar todas as chaves públicas possíveis, o que não é nem remotamente prático.

O `sshd(8)` de seu sistema ainda pode ser atacado, mas caso utilize apenas a
autenticação por chave pública, você pode estar confortavelmente certo de que é
_efetivamente impossível_ descobrir suas credenciais usando ataques de força
bruta. Note, no entanto, que isso não necessariamente te protege contra
problemas de segurança no próprio `ssh(8)`, e você ainda deve proteger sua
chave privada de ser roubada, daí a necessidade de uma senha.

Todas as informações abaixo supõe que você tenha o OpenSSH instalado tanto como
cliente quanto como servidor nos sistemas apropriados. Em sistemas derivados do
Debian, ambos podem ser instalados com:

    # apt-get install ssh
    # apt-get install openssh-server

Frequentemente, tanto o cliente quanto o servidor vêm instalados por padrão
(por exemplo, no [OpenBSD][openbsd]).

## Gerando as chaves

Assim como no processo de configuração do GnuPG, começamos gerando um par de
chaves na máquina a partir da qual queremos conectar, usando o
[`ssh-keygen(1)`][ssh-keygen]. Irei utilizar uma chave RSA de 4096 bits neste
artigo, já que ela é suportada mesmo em sistemas muito antigos, e deve ser
relativamente à prova de quebras no futuro, embora gerar novas chaves caso um
dia o RSA se torne inseguro não seja difícil. Se você preferir usar o novo
algorítimo [ECDSA][elliptic_curve], que é o padrão em versões recentes do
OpenSSH, os passos a seguir ainda irão funcionar. Também utilizarei um
**comentário** para a chave como um identificador não criptografado, para
distingui-la de outras chaves, caso eu tenha mais de uma. No meu caso,
endereços de email funcionam bem.

    $ ssh-keygen -t rsa -b 4096 -C taspargos@exemplo.com.br
    Generating public/private rsa key pair.

Primeiramente, a localização onde as chaves devem ser salvadas é solicitada.
Recomendo aceitar o padrão pressionando Enter, uma vez que usar a localização
padrão torna os próximos poucos passos mais fáceis:

    Enter file in which to save the key (/home/tim/.ssh/id_rsa):

A seguir, uma senha é solicitada, e devemos definitivamente adicionar uma para
garantir que a chave não será usada caso seja um dia comprometida. As mesmas
orientações para senhas aplicam nesse caso, e você deve escolher uma senha
diferente:

    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:

Isso feito, uma chave é gerada, incluindo uma representação pictórica que
permite o reconhecimento das chaves com um breve olhar. Nunca achei essa
representação muito útil, mas o fingerprint da chave é:

    Your identification has been saved in /home/tim/.ssh/id_rsa.
    Your public key has been saved in /home/tim/.ssh/id_rsa.pub.
    The key fingerprint is:
    d5:81:8c:eb:c6:c5:a2:b9:6a:ae:32:cc:20:bf:cf:66 tim@local
    The key's randomart image is:
    +--[ RSA 4096]----+
    |         o ..    |
    |        . o. .   |
    |         o. .    |
    |        o.o      |
    |       =So       |
    |o     o +        |
    |=.     o         |
    |oo..E .          |
    | ooO=.           |
    +-----------------+

As chaves devem estar disponíveis em `~/.ssh`:

    $ ls -l .ssh
    -rw-------  1 tim  tim  3326 Apr  2 22:47 id_rsa
    -rw-r--r--  1 tim  tim   754 Apr  2 22:47 id_rsa.pub

O arquivo `id_rsa` contém a chave privada criptografada, e deve ser mantido
bloqueado e confidencial. O arquivo `id_rsa_pub`, no entanto, contém a chave
pública, que pode ser distribuída com segurança, da mesma maneira que uma chave
pública PGP.

## Autenticação baseada em chaves

Agora, podemos nos preparar para usar a chave pública recém-gerada para a
autenticação, em lugar de uma senha. Em primeiro lugar, garanta que você
consegue se conectar à máquina remota com seu nome de usuário e senha:

    $ ssh remoto
    tim@remoto's password:

Quando você estiver conectado, garanta que o diretório `~/.ssh` existe na
máquina remota e que você não tenha chaves já listadas no arquivo
`~/.ssh/authorized_keys`, uma vez que iremos sobrescrevê-las:

    $ mkdir -p ~/.ssh
    $ chmod 0700 ~/.ssh

Se os passos acima funcionarem, feche a conexão (`exit` ou `Ctrl-D`) para
retornar à linha de comando de sua máquina local e copie sua chave pública na
máquina remota com o [`scp(1)`][scp]:

    $ scp ~/.ssh/id_rsa.pub remoto:.ssh/authorized_keys
    tim@remoto's password:
    id_rsa.pub    100%    754    0.7KB/s    00:00

Note que existe uma ferramenta, chamada [`ssh-copy-ip(1)`][ssh-copy-id]
incluída nas versões mais recentes do OpenSSH que faz as operações acima
automaticamente, mas é bom ter uma ideia do que ela faz por trás dos panos.

Com isso feito, sua próxima tentativa de conexão ao servidor remoto deve
solicitar a senha da sua chave, ao invés de sua senha de usuário:

    $ ssh remote
    Enter passphrase for key '/home/tim/.ssh/id_rsa':

## Vantagens

A princípio, pode parecer que você não fez nada de útil. Afinal de contas, você
ainda tem que digitar algo toda vez que conecta. Do ponto de vista da
segurança, a primeira vantagem desse método é que nem a sua senha de usuário,
nem a senha da chave, nem sua chave privada são transmitidas ao servidor ao
qual você está conectando; a autenticação é feita puramente baseado no par de
chaves pública-privada, descriptografado com a senha da chave.

Assim, se a máquina ao qual você estiver conectando for comprometida, ou se o
seu DNS for envenenado, ou algum ataque similar induzi-lo a conectar a um
daemon SSH falso, projetado para coletar credenciais, sua chave privada e sua
senha continuam seguras.

A segunda vantagem vem com o desligamento completo da autenticação por senha na
máquina remota, desde que todos os seus usuários estejam usando apenas a
autenticação por chave pública. Esse desligamento é feito com as seguintes
configurações no arquivo [`sshd_config(5)`][sshd_config], geralmente encontrado
em `/etc/ssh/sshd_config` no servidor remoto:

    PubkeyAuthentication yes
    ChallengeResponseAuthentication no
    PasswordAuthentication no

Reinicie o servidor SSH após aplicar essas configurações:

    $ sudo /etc/init.d/ssh restart

Assim, você não será mais capaz de conectar usando senhas, apenas chaves
privadas que são, como mencionado acima, efetivamente (mas não literalmente)
impossíveis de quebrar usando ataques de força bruta. Para conectar ao servidor
com suas credenciais, um invasor teria não apenas de saber sua senha, mas
também ter acesso a sua chave privada, tornando as coisas significantemente
mais difíceis.

O uso da autenticação por chave pública também permite ao `sshd(8)` um controle
refinado sobre a autenticação, tal como quais computadores podem conectar com
quais chaves, se eles podem executar túneis TCP ou X11, e (até um ponto) quais
comandos podem ser executados uma vez conectado. Veja a página do manual do
[`authorized_keys(5)`][authorized_keys] para dar uma olhada em alguns exemplos.

Finalmente, existe uma importante vantagem de usabilidade ao usar chaves SSH
para a autenticação usando os **agentes**, que iremos discutir no próximo
artigo.

## Chaves do servidor e fingerprints

Uma conexão SSH deve ser, idealmente, um processo de autenticação de duas vias.
Assim como o servidor ao qual você está se conectando precisa estar certo da
sua identidade, você precisa estar certo de que o servidor ao qual você está se
conectando é o esperado. Com truques como tunnelling, firewalls, envenenamento
de DNS, NAT, sistemas hackeados, entre outros, é apropriado ter cuidado de que
você está se conectando aos sistemas certos. É aí que entra o sistema de chaves
de servidor do OpenSSH.

A primeira vez que você se conecta a um novo servidor, você deve ver uma
mensagem como essa:

    $ ssh novoremoto
    The authenticity of host 'novoremoto (192.168.0.65)' can't be established.
    RSA key fingerprint is f4:4b:f4:8c:c5:50:f6:c8:d3:b2:e9:14:68:86:b5:7b.
    Are you sure you want to continue connecting (yes/no)?

Muitos administrados as desligam, mas não faça isso! Elas são muito
importantes.

A *fingerprint de uma chave* é um hash relativamente curto da chave de servidor
usada pelo OpenSSH naquela máquina. Ela é verificada pelo seu cliente SSH e não
pode ser facilmente falsificada. Se você está se conectando a um novo servidor,
é apropriado checar se a fingerprint da chave de servidor corresponde àquela
que você vê na primeira tentativa de conexão, ou pedir ao administrador do
sistema para que ele o faça. 

A fingerprint de chave do servidor pode ser checada no servidor SSH executando
`ssh-keygen(1)`:

    $ ssh-keygen -lf /etc/ssh/ssh_host_rsa_key
    2048 f4:4b:f4:8c:c5:50:f6:c8:d3:b2:e9:14:68:86:b5:7b /etc/ssh/ssh_host_rsa_key.pub (RSA)

Se você desejar, é possível checar a chave sem realizar uma tentativa de
conexão com um comando similar no cliente:

    $ ssh-keygen -lF novoremoto
    # Host 192.168.0.65 found: line 1 type RSA
    2048 f4:4b:f4:8c:c5:50:f6:c8:d3:b2:e9:14:68:86:b5:7b novoremoto (RSA)

Se você não consegue checar a chave de servidor, peça ao administrador que a
envie num canal seguro e confiável, como em pessoa ou via uma mensagem assinada
usando o PGP. Se a fingerprint SSH delimitada por dois pontos não for
exatamente a mesma, você pode ser vítima de alguém tentando fraudar sua
conexão!

Essa prática pode ser exagerada para máquinas virtuais novas e provavelmente
máquinas novas numa LAN confiável, mas para máquina acessadas através da
internet pública, ela é muito prudente.

De maneira similar, o `ssh(1)`, por padrão, mantém um registro das chaves de
servidor dos computadores aos quais você já se conectou. Por esse motivo,
quando uma chave de servidor diferente é apresentada numa tentativa de conexão,
o programa mostra um aviso:

    $ ssh novoremoto
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
    Someone could be eavesdropping on you right now (man-in-the-middle attack)!
    It is also possible that a host key has just been changed.
    The fingerprint for the RSA key sent by the remote host is
    d7:06:51:16:80:f6:32:b4:35:7c:53:8d:5a:49:69:ec
    Please contact your system administrator.
    Add correct host key in /home/tim/.ssh/known_hosts to get rid of this message.
    Offending RSA key in /home/tim/.ssh/known_hosts:22
    RSA host key for novoremoto has changed and you have requested strict checking.

Novamente, esse aviso é algo que usuários do `ssh(1)` frequentemente desligam,
o que é bastante arriscado, especialmente se você estiver usando a autenticação
por senha e, consequentemente, pode enviar sua senha a um servidor
mal-intencionado ou comprometido!

Essa entrada é a parte 4 de 10 na série [Criptografia no
Linux][linux_crypto_intro].

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[linux_crypto_intro]: {% post_url 2013-09-16-linux_cripto_intro %}
[fail2ban]: http://www.fail2ban.org/
[openbsd]: http://www.openbsd.org/
[ssh-keygen]: http://linux.die.net/man/1/ssh-keygen
[elliptic_curve]: http://en.wikipedia.org/wiki/Elliptic_Curve_DSA
[scp]: http://linux.die.net/man/1/scp
[ssh-copy-id]: http://blog.sanctum.geek.nz/shortcut-for-adding-ssh-keys/
[sshd_config]: http://linux.die.net/man/5/sshd_config
[authorized_keys]: http://linux.die.net/man/5/authorized_keys
