---
layout: post
title: "Criptografia no Linux: Senhas"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt:
---

Essa é o sexto post de uma série de dez posts traduzindo o original de Tom
Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma licença [Creative
Commons 3.0][cc].

Para a lista de posts, veja a [introdução][linux_crypto_intro].

---

É cada vez mais amplamente conhecido que o uso de senhas previsíveis ou o uso
da mesma senha para mais de uma conta é um sério risco de segurança, pois um
invasor pode tomar controle de uma conta (como um email) e causar uma série de
prejuízos. Se um invasor conseguir o hash de sua senha para algum serviço na web,
você quer ter certeza de que o hash é muito difícil de reverter e, mesmo que
ele possa ser revertido, é exclusivo o bastante para não dar ao invasor acesso
a qualquer outra de suas contas.

Essa crescente percepção contribuiu com a popularidade dos **gerenciadores de
senhas**, ferramentas projetadas para gerar, armazenar e recuperar senhas de
forma segura, criptografadas com uma senha ou palavra passe mestra. Em alguns
casos, como com o [KeePass][keepass], os dados são armazenados localmente; em
outros, como com o [LastPass][lastpass], são armazenados em um serviço da web.
Ambas são boas ferramentas e funcionam bem no Linux. Pessoalmente, tenho
algumas reservas quanto o LastPass, já que não quero minhas senhas armazenadas
em um serviço de terceiros, além de [não confiar na criptografia com o
JavaScript][javascript_crypto].

Curiosamente, por que nós agora temos uma configuração cuidadosa do GnuPG para
lidar com a criptografia sozinhos, outra opção é a ferramenta [`pass(1)][pass],
que se autoproclama “o gerenciador de senhas padrão do UNIX”.  Ela não passa de
um shell script e algumas completações para o `bash(1)` baseados em ferramentas
existentes como o [`git(1)`][git], o [`gpg2(1)`][gpg2], o  [`pwgen(1)`][pwgen],
o [`tree(1)`][tree], o [`xclip(1)`][xclip] e seu `$EDITOR` de escolha. Se você
ainda não investiu em um método de gerenciamento de senhas existente, essa pode
ser uma boa aplicação inicial para o seu sistema de criptografia e uma ótima
abordagem minimalista para o armazenamento seguro de senhas a partir da linha
de comando (e, portanto, SSH).

Em sistemas derivados do Debian, a ferramenta está disponível como parte do
pacote `pass`:

    # apt-get install pass

Ele inclui um manual:

    $ man pass

Instruções para a instalação em outros sistemas operacionais estão disponíveis
no site do projeto. Outras versões também estão disponíveis para o download,
bem como um link para o repositório de desenvolvimento. Caso deseje utilizar o
programa, certifique-se que as outras ferramentas necessárias citadas acimas
estão instaladas, embora o `xclip(1)` seja necessário apenas se você utilizar o
sistema X Windows.

## Instalação

Podemos obter um panorama geral do `pass(1)` invocando-o sem argumentos:

    $ pass

Para começar, iremos inicializar nosso armazenamento de senhas. Para nossas
próprias senhas, é necessário rodar o comando como o seu usuário e não como
root. Uma vez que o `pass(1)` usa o GnuPG para a criptografia, também
precisaremos informá-lo a ID da chave apropriada que ele deve utilizar.
Lembre-se que você pode encontrar esse código hexadecimal de oito dígitos
digitando `gpg --list-secret-keys`. Uma sequência de texto exclusiva que
identifique sua chave privada, como o seu nome ou endereço de email, também
pode funcionar.

    $ pass init 0x1FC2985D
    mkdir: created directory ‘/home/tim/.password-store’
    Password store initialized for 0x1FC2985D.

Notamos que, de fato, o diretório `~/.password-store` foi criado, embora no
momento esteja vazio exceto pelo arquivo `.gpg-id`, que mantém um registro da
ID de nossa chave:

    $ find .password-store
    .password-store
    .password-store/.gpg-id

## Inserindo senhas

Vamos inserir uma senha existente com `pass insert`, passando ao comando um
nome descritivo e hierárquico:

    $ pass insert google.com/gmail/exemplo@gmail.com
    mkdir: created directory ‘/home/tim/.password-store/google.com’
    mkdir: created directory ‘/home/tim/.password-store/google.com/gmail’
    Enter password for google.com/gmail/exemplo@gmail.com:
    Retype password for google.com/gmail/exemplo@gmail.com:

A senha é digitada e lida na linha de comando, criptografada e colocada em
`~/.password-store`:

    $ find .password-store
    .password-store
    .password-store/google.com
    .password-store/google.com/gmail
    .password-store/google.com/gmail/exemplo@gmail.com.gpg
    .password-store/.gpg-id

Note que o `pass(1)` cria uma estrutura de diretórios automaticamente. Podemos
obter uma boa visão do armazenamento das senhas com o comando `pass`, sem
argumentos:

    $ pass
    Password Store
    └── google.com
        └── gmail
            └── exemplo@gmail.com

## Gerando senhas

Se, ao invés de inserir uma senha existente, você desejar gerar uma senha nova,
segura e aleatória, você pode usar o comando `generate`, incluindo o seu
comprimento como último argumento:

    $ pass generate google.com/gmail/exemplo@gmail.com 16
    The generated password to google.com/gmail/exemplo@gmail.com is:
    !Q%i$$&q1+JJi-|X

Se o site não aceitar símbolos na senha, você pode adicionar a opção `-n` ao
comando:

    $ pass generate -n google.com/gmail/exemplo@gmail.com 16
    The generated password to google.com/gmail/exemplo@gmail.com is:
    pJeF18CrZEZzI59D

O `pass(1)` usa o `pwgen(1)` para a geração de senhas. Nos dois casos acima, a
senha é automaticamente inserida no armazenamento de senhas.

Se você precisa modificar uma senha existente, você pode tanto sobrescrevê-la
com o comando `insert`, ou usar a operação `edit` para chamar o `$EDITOR` de
sua escolha:

    $ pass edit google.com/gmail/exemplo@gmail.com

Caso utilize a opção `edit`, você deve ser cuidadoso e ter certeza que seu
editor não está configurado para manter arquivos de backup ou de troca, em
texto plano, dos documentos que ele edita, em diretórios temporários ou em
sistemas de arquivos na memória. Caso esteja utilizando o Vim, eu [escrevi um
script][noplaintext] para tentar resolver esse problema.

Note que a adição ou mudança de senhas não requer a senha de sua chave privada;
apenas a sua recuperação a requer, consistente com a maneira como o GnuPG
normalmente trabalha.

## Recuperando senhas

A senha que adicionamos ao programa pode ser, agora, recuperado e impresso na
linha de comando, desde que digitemos a senha correta para nossa chave privada:

    $ pass google.com/gmail/exemplo@gmail.com
    (...tela do gpg-agent pinentry...)
    Tr0ub4dor&3

Se você estiver utilizando o X Windows e o `xclip(1)` estiver instalado, a
senha pode ser colocada temporariamente na área de transferência e colada em
formulários online:

    $ pass -c google.com/gmail/exemplo@gmail.com
    Copied google.com/gmail/exemplo@gmail.com to clipboard. Will clear in 45 seconds.

Note que, em todos os casos, se as completações para o bash estiverem
instaladas e funcionando, é possível completar o caminho completo das senhas
usando a tecla `Tab `, como se você estivesse navegando uma hierarquia de
diretórios.

## Deletando senhas

Quando uma senha não é mais necessária, pode removê-la com `pass rm`:

    $ pass rm google.com/gmail/exemplo@gmail.com
    Are you sure you would like to delete google.com/gmail/exemplo@gmail.com? [y/N] y
    removed ‘/home/tim/.password-store/google.com/gmail/exemplo@gmail.com.gpg’

Podemos deletar diretórios de senhas inteiros com `pass rm -r`: 

    $ pass rm -r google.com
    Are you sure you would like to delete google.com? [y/N] y
    removed ‘/home/tim/.password-store/google.com/gmail/exemplo@gmail.com.gpg’
    removed directory: ‘/home/tim/.password-store/google.com/gmail’
    removed directory: ‘/home/tim/.password-store/google.com’

## Controle de versão

Para manter a história de nossas senhas, incluindo senhas que foram deletadas,
se algum dia precisarmos delas novamente, podemos configurar o controle de
versão automático com o comando `pass git init`:

    $ pass git init
    Initialized empty Git repository in /home/tim/.password-store/.git/
    [master (root-commit) 0ebb933] Added current contents of password store.
     1 file changed, 1 insertion(+)
      create mode 100644 .gpg-id

Esse comando irá atualizar o repositório sempre que uma senha é modificada, o
que significa que, sem dúvidas, seremos capazes de recuperar senhas antigas que
substituímos ou deletamos:

    $ pass insert google.com/gmail/novoexemplo@gmail.com
    mkdir: created directory ‘/home/tim/.password-store/google.com’
    mkdir: created directory ‘/home/tim/.password-store/google.com/gmail’
    Enter password for google.com/gmail/novoexemplo@gmail.com:
    Retype password for google.com/gmail/novoexemplo@gmail.com:
    [master 00971b6] Added given password for google.com/gmail/novoexemplo@gmail.com to store.
     1 file changed, 0 insertions(+), 0 deletions(-)
      create mode 100644 google.com/gmail/novoexemplo@gmail.com.gpg

## Backups

Uma vez que os arquivos contendo as senhas são todos criptografados com apenas
nossa chave do GnuPG, podemos armazenar um backup em sites de terceiros e em
computadores remotos, de maneira relativamente segura, simplesmente copiando o
diretório `~/.password-store`. Por outro lado, se os nomes dos arquivos contém
informações confidenciais, tais como nomes de usuários ou sites privativos,
você pode realizar o backup de uma tarball criptografada do diretório:

    $ tar -cz .password-store \
        | gpg --sign --encrypt -r 0x1FC2985D \
        > password-store-backup.tar.gz.gpg

O diretório pode ser restaurado de forma similar:

    $ gpg --decrypt \
        < password-store-backup.tar.gz.gpg \
        | tar -xz 

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[linux_crypto_intro]: {% post_url 2013-09-16-linux_cripto_intro %}
[keepass]: http://keepass.com/
[lastpass]: https://lastpass.com/
[javascript_crypto]: http://www.matasano.com/articles/javascript-cryptography/
[pass]: http://zx2c4.com/projects/password-store/
[git]: http://linux.die.net/man/1/git
[gpg2]: http://linux.die.net/man/1/gpg2
[pwgen]: http://linux.die.net/man/1/pwgen
[tree]: http://linux.die.net/man/1/tree
[xclip]: http://linux.die.net/man/1/xclip
[noplaintext]: https://gist.github.com/tejr/5890634
