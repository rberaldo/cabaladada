---
layout: post
title: "Criptografia no Linux: Agentes"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt:
published: false
---

Essa é o quinto post de uma série de dez posts traduzindo o original de Tom
Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma licença [Creative
Commons 3.0][cc].

Para a lista de posts, veja a [introdução][linux_crypto_intro].

---

Agora que o GnuPG e o SSH estão configurados seguramente, podemos criptografar,
descriptografar, assinar e verificar mensagens, e autenticar seguramente a
servidores remotos sem o risco de expor nossas senhas e com uma possibilidade
efetivamente nula de ataques de força bruta. Isso tudo é ótimo, mas ainda
existe um elo fraco em nossa corrente com o qual lidar — nossas senhas.

Se você usa essas ferramentas com frequência, inserir nossa senha para a maior
parte das operações pode se tornar irritante. Podemos ficar tentados a incluir
um meio de automatizar a inserção da senha, ou simplesmente não usá-la,
deixando nossa chave privada descriptografada. Como usuários preocupados com a
segurança, nós definitivamente desejamos evitar a última possibilidade, caso o
arquivo de nossa chave privada seja roubado, e é aqui que o conceito de agentes
para o SSH e GnuPG entra.

Um agente é um daemon projetado para otimizar o processo de usar chaves
privadas descriptografadas, guardando os detalhes seguramente na memória,
idealmente por um período limitado de tempo. Ele permite que você insira sua
senha do SSH ou GnuPG apenas uma vez e usos subsequentes que requerem a chave
privada descriptografada são gerenciados pelo agente.

Neste artigo, discutiremos o básico da configuração de agentes para o SSH e o
GnuPG. Depois que você souber como eles funcionam, iremos apresentar uma
ferramenta conveniente para iniciá-los e gerenciá-los facilmente.

## Agentes para o SSH

O programa [`ssh-agent(1)`][ssh-agent] vem como parte da [suíte
OpenSSH][openssh_suite]. Ele pode ser executado em dois modos, como parte de um
processo pai ou daemonizado e rodando no plano de fundo. Iremos discutir o
último método, uma vez que é mais comumente usado e mais flexível.

### Instalação e configuração

Quando rodamos o `ssh-agent(1)` pela primeira vez, seu comportamento é curioso:
ele não parece fazer nada além de soltar umas linhas de shell script
enigmático:

    $ ssh-agent 
    SSH_AUTH_SOCK=/tmp/ssh-EYqoH3qwfvbe/agent.28881; export SSH_AUTH_SOCK;
    SSH_AGENT_PID=28882; export SSH_AGENT_PID;
    echo Agent pid 28882;

No entanto, podemos verificar que o daemon está rodando com o PID que ele
menciona:

    $ ps 28882
      PID TTY      STAT   TIME COMMAND
      28882 ?        Ss     0:00 ssh-agent

Mas se ele está executando sem problemas, qual o problema do shell script que
ele produz? Por que ele não roda o script de uma vez?

A resposta é uma interessante solução alternativa para a rigidez do modelo de
processos do Unix; especificamente, um processo não pode modificar seu ambiente
pai. As variáveis `SSH_AUTH_SOCK` e `SSH_AGENT_PID` são projetadas para
permitir que programas como o `ssh(1)` encontrem o agente e possam se comunicar
com ele, então definitivamente precisamos atribuir valores a elas. No entanto,
se o `ssh-agent(1)` tentasse configurá-las automaticamente, as configurações
seriam aplicadas apenas para seu próprio processo e não para o shell no qual o
executamos.

Assim, além de executar o `ssh-agent(1)`, precisamos executar o código que ele
imprime na tela para que as variáveis sejam atribuídas em nosso shell. Um bom
método para fazer isso em Bash é usar o `eval` e a substituição de comando com
`$(...)`.

    $ eval $(ssh-agent)
    Agent 3954

Se executarmos esse comando, vemos não apenas que o `ssh-agent(1)` está
rodando, mas que temos duas novas variáveis em nosso ambiente identificando o
caminho de seu socket e a ID do processo:

    $ pgrep ssh-agent
    3954
    $ env | grep ^SSH
    SSH_AUTH_SOCK=/tmp/ssh-oF1sg154ygSt/agent.3953
    SSH_AGENT_PID=3954

Com isso feito, o agente está pronto e podemos começar a usá-lo para gerenciar
nossas chaves.

### Uso

O próximo passo é carregar nossas chaves no agente com o
[`ssh-add(1)`][ssh-add]. Dê ao programa o caminho completo da chave privada que
o agente deve usar. O caminho é, provavelmente, `~/.ssh/id_rsa` ou
`~/.ssh/id_dsa`:

    $ ssh-add ~/.ssh/id_rsa
    Enter passphrase for /home/tim/.ssh/id_rsa:
    Identity added: /home/tim/.ssh/id_rsa (/home/tim/.ssh/id_rsa)

Você pode deixar esse argumento de lado se desejar que o `ssh-add` adicione
todos os tipos de chave padrão em `~/.ssh` caso elas existam (`id_dsa`,
`id_rsa` e `id_ecdsa`):

    $ ssh-add

De qualquer maneira, sua senha será requerida; isso é esperado, e você deve
digitá-la.

Se pedirmos ao `ssh-add(1)` que liste as chaves que está gerenciando, veremos a
chave que acabamos de adicionar:

    i$ ssh-add -l
    4096 87:ec:57:8b:ea:24:56:0e:f1:54:2f:6b:ab:c0:e8:56 /home/tim/.ssh/id_rsa (RSA)

Agora, caso tentemos conectar a outro servidor utilizando essa chave, não
teremos de providenciar nossa senha; seremos conectados imediatamente:

    tim@local:~$ ssh remoto
    Welcome to remote.sanctum.geek.nz, running GNU/Linux!
    tim@remoto:~$

O padrão do agente é manter as chaves permanentemente, até que ele seja parado
ou até que as chaves sejam explicitamente removidas, uma a uma, com o comando
`ssh-add -d <arquivo da chave>`, ou até que todas sejam removidas de uma vez
com `ssh-add -D`. Para os cautelosos, você pode configurar um tempo limite com
o comando `ssh-add -t`. Por exemplo, para que o `ssh-add` esqueça sobre as
chaves após duas horas, você pode executar:

    $ ssh-add -t 7200 ~/.ssh/id_rsa

Para matar o agente completamente, você pode usar o comando `ssh-agent -k`,
novamente com `eval $(...)` envolvendo o comando:

    $ eval $(ssh-agent -k)
    Agent pid 4501 killed

Para se livrar do agente após sair de sua sessão, você pode considerar
adicionar o comando acimo ao script `~/.bash_logout` ou similares.

### Configuração permanente

Se você gostou do agente e ele torna o gerenciamento de suas chaves mais
conveniente, faz sentido colocá-lo num script de inicialização como o
`~/.bash_profile`. Dessa maneira, o agente será iniciado a cada login e seremos
capazes de comunicar com ele a partir de qualquer subshell (`xterm`, `screen`,
ou o `tmux`, se configurado apropriadamente):

    eval $(ssh-agent)
    ssh-add ~/.ssh/id_rsa

Em nosso próximo login num TTY, nossa senha será requerida e, a partir daí,
poderemos conectar a qualquer máquina usando as chaves gerenciadas pelo agente:

    tim@local:~$ ssh remoto
    Welcome to remote.sanctum.geek.nz, running GNU/Linux!

Se você deseja utilizar um gerenciador de desktop como o GDM ou o XDM, você
pode adicionar uma variável apontando para o programa
[`ssh-askpass(1)`][ssh-askpass]:

    eval $(ssh-agent)
    export SSH_ASKPASS=/usr/bin/ssh-askpass
    ssh-add ~/.ssh/id_rsa

Se a variável `SSH_ASKPASS` está atribuída como acima e `DISPLAY` se refere a
um monitor em funcionamento, um simples aviso gráfico aparecerá, pedindo nossa
senha:

![ssh-askpass](/images/ssh-askpass.png "ssh-askpass em funcionamento")

Esse programa talvez tenha de ser instalado separadamente. Em sistemas
derivados do Debian, o nome do pacote é [`ssh-askpass`][ssh-askpass-pkg].

Todos os processos filhos e subshells do shell de login irão herdar as
variáveis do agente, uma vez que foram exportadas utilizando o `export`:

    tim@local:~$ screen
    tim@local:~$ tmux bash
    tim@local:~$ bash
    tim@local:~$ ssh remote
    Welcome to remote.sanctum.geek.nz, running GNU/Linux!
    tim@remote:~$

Dessa maneira, temos que digitar nossa senha apenas uma vez por sessão de login
e podemos conectar a todos os servidores aos quais nossas chaves conferem
acesso… Muito conveniente!

## Agentes do GnuPG

Assim como o `ssh-agent(1)`, existe também um agente para gerenciar chaves do
GnuPG, chamado [`gpg-agent(1)`][gpg-agent]. O seu comportamento é muito
similar. Em sistemas derivados do Debian, ele pode ser instalado com o [pacote
`gnupg-agent`][gnupg-agent-pkg]. Você também deve instalar um programa de
`pinentry` [entrada de PIN]; como estamos focando no aprendizado dos aspectos
básicos na linha de comando, utilizaremos o
[`pinentry-curses(1)`][pinentry-curses]:

    # apt-get install gnupg-agent pinentry-curses

### Configuração

Iniciaremos o agente usando o mesmo truque com `eval $(...)` que aprendemos com
o `ssh-agent`:

    $ eval $(gpg-agent --daemon)

Podemos verificar que o agente está rodando no plano de fundo com o PID
infomado e também que temos uma nova variável de ambiente:

    $ pgrep gpg-agent
    5131
    $ env | grep ^GPG
    GPG_AGENT_INFO=/tmp/gpg-hbro8r/S.gpg-agent:5131:1

Também iremos atribuir a variável `GPG_TTY`, que informa o programa `pinentry`
sobre o terminal no qual ele deve desenhar sua tela de inserção de senha:

    $ export GPG_TTY=$(tty)
    $ echo $GPG_TTY
    /dev/pts/2

Finalmente, para estimular o `gpg(1)` a realmente usar o agente, precisamos
adicionar uma linha aqui arquivo `~/.gnupg/gpg.conf`. Você pode criar esse
arquivo, caso ele não exista.

    use-agent

### Uso

Isso feito, caso tentemos realizar qualquer operação que requeira nossa chave
privada, a senha será requerida não diretamente na linha de comando, mas por
nosso programa de entrada de PIN:

    $ gpg --armor --sign mensagem1.txt

    ┌──────────────────────────────────────────────────────────┐
    │ You need a passphrase to unlock the secret key for user: │
    │ "Timoteo Aspargos (taspargos) <taspargos@exemplo.com.br>"│
    │ 4096-bit RSA key, ID 25926609, created 2013-08-22        │
    │ (main key ID 1FC2985D)                                   │
    │                                                          │
    │                                                          │
    │ Passphrase ***__________________________________________ │
    │                                                          │
    │       <OK>                                 <Cancel>      │
    └──────────────────────────────────────────────────────────┘

Após inserirmos a senha, a operação é realizada:

    $ ls mensagem1*
    mensagem1.txt
    mensagem1.txt.asc

Mais tarde, se realizarmos outra opção que requeira a chave privada, veremos
que a senha não é pedida:

    $ gpg --armor --sign mensagem2.txt
    $ ls mensagem2*
    mensagem2.txt
    mensagem2.txt.asc

O agente armazenou nossa chave privada em cache, tornando muito mais fácil
realizar uma série de operações utilizando-a. O tempo limite padrão é de 10
minutos, mas você pode mudá-lo com as configurações `default-cache-ttl` e
`max-cache-ttl` em `~/.gnupg/gpg-agent.conf`. Por exemplo, para reter a chave
privada por uma hora após o seu último uso, com um máximo de duas horas a
partir do primeiro uso, escreveríamos:

    default-cache-ttl 3600
    max-cache-ttl 7200

Para que esses valores façam efeito, precisamos recarregar o agente:

    $ gpg-connect-agent <<<RELOADAGENT
    OK

### Configuração permanente

Assim como o `ssh-agent(1)`, um local ideal para o código de inicialização do
`gpg-agent(1)` é um script de login como o `~/.bash_profile`:

    eval $(gpg-agent --daemon)

O agente será iniciado e todas as suas variáveis de ambiente serão atribuídas
para todos os subshells, assim como com o `ssh-agent`.

Se você estiver usando uma ferramenta de entrada de PIN, você também deve
adicionar o seguinte ao fim de seu script de inicialização interativo. No
Linux, ele é arquivo `~/.bashrc`; no Mac OS X, você talvez precise colocá-lo em
`~/.bashrc`.

    export GPG_TTY=$(tty)

## Keychain

Para gerenciar tanto o `ssh-agent(1)` quanto o `gpg-agent(1)` eficientemente,
existe uma ferramenta chamada `keychain(1)`. Ela fornece uma maneira simples de
iniciar ambos os agentes com um único comando, incluindo carregar as chaves
durante a inicialização. Ele também evita que qualquer um dos agentes seja
executado duas vezes, identificando agentes inciados em outros locais do
sistema. Muitos ambientes de desktop são configurados para iniciar um ou ambos
os agentes, por isso faz sentido reutilizá-los quando possível, e nisso o
`keychain(1)` se sobressai.

Em sistemas baseados no Debian, o programa está disponível no [pacote
`keychain`][keychain-pkg]:

    # apt-get install keychain

Com o `keychain` instalado, podemos iniciar ambos os agentes com apenas um
comando em `~/.bash_profile`:

    eval $(keychain --eval)

Opcionalmente, podemos incluir os nomes dos arquivos das chaves SSH em `~/.ssh`
ou das IDs em hexadecimal das chaves do GnuPG como argumentos para o
carregamento imediato das chaves privadas (incluindo a solicitação das senhas)
durante a inicialização.

    eval $(keychain --eval id_rsa 0x1FC2985D)

Se esse programa estiver disponível em seu sistema, ele é altamente
recomendável; gerenciar seus agentes e ambientes pode ser trabalhoso, e o
`keychain(1)` faz todo o trabalho duro, sem que você tenha de se preocupar se
um agente está disponível em seu contexto em particular. Confira [a página do
projeto][keychain_site] para mais informações sobre essa ferramenta.

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[linux_crypto_intro]: {% post_url 2013-09-16-linux_cripto_intro %}
[ssh-agent]: http://linux.die.net/man/1/ssh-agent
[openssh_suite]: http://openssh.org/
[ssh-add]: http://linux.die.net/man/1/ssh-add
[ssh-askpass]: http://linux.die.net/man/1/ssh-askpass
[ssh-askpass-pkg]: http://packages.debian.org/stable/ssh-askpass
[gpg-agent]: http://linux.die.net/man/1/gpg-agent
[gnupg-agent-pkg]: http://packages.debian.org/stable/gnupg-agent
[pinentry-curses]: http://linux.die.net/man/1/pinentry-curses
[keychain-pkg]: http://packages.debian.org/stable/keychain
[keychain_site]: http://www.funtoo.org/Keychain
