---
layout: post
title: "Criptografia no Linux: Backups"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt:
---

Essa é o oitavo post de uma série de dez posts traduzindo o original de Tom
Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma licença [Creative
Commons 3.0][cc].

Para a lista de posts, veja a [introdução][linux_crypto_intro].

---

Embora possuir backups locais para a recuperação rápida de dados seja
importante, tal como em um disco USB ou num disco rígido vago, é igualmente
importante ter um backup externo, a partir do qual você possa restaurar seus
documentos importantes se, por exemplo, o seu escritório foi roubado ou pegar
fogo e você perder tanto seu computador quanto o seu meio de backup.

Para a maior parte das pessoas, a maneira mais fácil de fazê-lo é com um
provedor de armazenamento, que ofereça acesso a armazenamento em massa de
tamanho adequado, mantido nos sistemas de outras companhia, por um preço
relativamente modesto ou mesmo de graça, como o [Ubuntu One][ubuntu_one] ou o
[Skydrive][skydrive], da Microsoft. Os melhores provedores também criptografam
os dados em seus servidores, não importando se eles tem acesso aos dados ou
não.

Mas confiar todos os seus dados e a criptografia dos mesmos a uma companhia é
arriscado, particularmente após as recentes revelações de um [conluio
corporativo com a NSA][conluio_nsa], e usuários preocupados com sua privacidade
devem preferir a segurança de criptografar seus backups antes de serem enviados
aos servidores. O provedor pode implementar seus próprios mecanismos de
criptografia simétrica e/ou fechada, que podem ou não ser confiáveis. Como
estabelecido, para uma criptografia pessoal muito forte, podemos usar nossa
instalação do GnuPG para criptografar arquivos antes de enviá-los:

    $ tar -cf backup_docs-"$(date +%Y-%m-%d)".tar $HOME/Documentos
    $ gpg --encrypt backup_docs-2013-07-27.tar
    $ scp backup_docs-2013-07-27.tar.gpg usuario@backup.exemplo.com.br:backup_docs

O problema de criptografar arquivos inteiros antes de copiá-los ao servidor de
armazenamento é que mesmo para dados de tamanho modesto, realizar backups
completos e fazer upload de todos os arquivos juntos, todas as vezes, pode
custar muita banda. Da mesma forma, gostaríamos de ser capazes de restaurar
nossos arquivos tal como eram num dia específico, para o caso de backups que
não funcionem ou arquivos deletados acidentalmente, porém sem armazenar todos
os arquivos em todos os dias de backup, o que pode acabar requerendo espaço
demais.

## Backups incrementais

Normalmente, a solução é usar um sistema de backup incremental, o que significa
que, após o upload inicial de seus arquivos em sua totalidade ao sistema de
backup, os backups sucessivos fazem o upload _apenas das mudanças_,
arquivando-as num formato recuperável e com um aproveitamento de espaço
eficiente. Sistemas como o [Dirvish][dirvish], uma interface escrita em Perl
para o `rsync(1)`, permitem isso.

Infelizmente, o Dirvish não nem criptografa os arquivos, nem o conjunto de
alterações que ele armazena. Precisamos de uma solução de backup incremental
que calcule e armazene eficientemente as mudanças nos arquivos num servidor
remoto e que também os criptografe. O [Duplicity][duplicity], uma ferramenta
escrita em Python e construída sob a biblioteca `librsync` se destaca nessa
tarefa. Ele pode usar nossa configuração de chave assimétrica do GnuPG para a
criptografia dos arquivos e está disponível em sistemas derivados do Debian no
pacote [`duplicity`][duplicity_pkg].

## Uso

Podemos ter uma ideia de como o [`duplicity(1)`][duplicity_man] funciona
pedindo que ele inicie um backup em nossa máquina local. Ele utiliza quase os
mesmo argumentos de fonte e destino que ferramentas como o `rsync` ou o `scp`:

    $ cd
    $ duplicity --encrypt-key taspargos@exemplo.com.br Documentos file://backup_docs

É importante especificar a opção `--encrypt-key`, pois de outro modo o
`duplicity(1)` utilizará a criptografia simétrica com senha ao invés da chave
pública, que é consideravelmente menos segura. Indique o endereço de email que
corresponde ao par de chaves que você deseja utilizar para a criptografia.

O comando acima realiza o backup completo e criptografado do diretório,
retornando a seguinte saída:

    Os metadados remotos e locais estão sincronizados; nenhuma sincronização é necessária.
    Data da última cópia de segurança completa: nenhuma
    Não encontrou assinaturas, a mudança para backup completo.
    --------------[ Estatísticas de backup ]--------------
    StartTime 1374903081.74 (Sat Jul 27 17:31:21 2013)
    EndTime 1374903081.75 (Sat Jul 27 17:31:21 2013)
    ElapsedTime 0.01 (0.01 seconds)
    SourceFiles 4
    SourceFileSize 142251 (139 KB)
    NewFiles 4
    NewFileSize 142251 (139 KB)
    DeletedFiles 0
    ChangedFiles 0
    ChangedFileSize 0 (0 bytes)
    ChangedDeltaSize 0 (0 bytes)
    DeltaEntries 4
    RawDeltaSize 138155 (135 KB)
    TotalDestinationSizeChange 138461 (135 KB)
    Errors 0
    -------------------------------------------------------

Você poderá notar que sua senha não é requerida. Lembre-se que para
criptografar arquivos, a chave pública não requer uma senha; a ideia geral é
que qualquer um possa criptografar utilizando nossa chave, sem precisar de sua
permissão.

Verificando o diretório criado, `backup_docs`, encontramos três novos arquivos
dentro, todos criptografados:

    $ ls -1 backup_docs
    duplicity-full.20130727T053121Z.manifest.gpg
    duplicity-full.20130727T053121Z.vol1.difftar.gpg
    duplicity-full-signatures.20130727T053121Z.sigtar.gpg

O arquivo `vol1.difftar.gpg` contém os dados armazenados; os outros dois
arquivos contém _metadados_ sobre os conteúdos do arquivo, para que as
diferenças sejam calculadas na próxima vez que o backup for executado.

Se fizermos uma pequena mudança num arquivo do diretório que estamos copiando e
rodarmos o mesmo comando novamente, notaremos que o backup será realizado
_incrementalmente_, e apenas as mudanças (o novo arquivo) será salvo:

    $ duplicity --encrypt-key taspargos@exemplo.com.br Documentos file://backup_docs
    Os metadados remotos e locais estão sincronizados; nenhuma sincronização é necessária.
    Data da última cópia de segurança completa: Sab Jul 27 17:34:33 2013
    --------------[ Estatísticas de backup ]--------------
    StartTime 1374903396.52 (Sat Jul 27 17:36:36 2013)
    EndTime 1374903396.52 (Sat Jul 27 17:36:36 2013)
    ElapsedTime 0.01 (0.01 seconds)
    SourceFiles 5
    SourceFileSize 142255 (139 KB)
    NewFiles 2
    NewFileSize 4100 (4.00 KB)
    DeletedFiles 0
    ChangedFiles 0
    ChangedFileSize 0 (0 bytes)
    ChangedDeltaSize 0 (0 bytes)
    DeltaEntries 2
    RawDeltaSize 4 (4 bytes)
    TotalDestinationSizeChange 753 (753 bytes)
    Errors 0
    -------------------------------------------------------

Também encontraremos três novos arquivos no diretório `backup_docs`, contendo
os novos dados:

    $ ls -1 backup_docs
    duplicity-full.20130727T053433Z.manifest.gpg
    duplicity-full.20130727T053433Z.vol1.difftar.gpg
    duplicity-full-signatures.20130727T053433Z.sigtar.gpg
    duplicity-inc.20130727T053433Z.to.20130727T053636Z.manifest.gpg
    duplicity-inc.20130727T053433Z.to.20130727T053636Z.vol1.difftar.gpg
    duplicity-new-signatures.20130727T053433Z.to.20130727T053636Z.sigtar.gpg

Note que os novos arquivos têm o prefixo `duplicity-inc-` ou `duplicity-new-`,
denotando que são backups incrementais e não completos.

Note, também, que para poder rastrear os arquivos que já foram copiados, o
`duplicity(1)` armazena os metadados em `~/.cache/duplicity`, bem como junto
com os backups. Assim, podemos executar nossos processos de backup de forma
autônoma, ao invés de ter de inserir nossa senha para ler os metadados no
servidor remoto antes de realizar o backup incremental. Naturalmente, se
perdermos nossos arquivos em cache, não há problemas; podemos ler os arquivos
que estão no backup fornecendo nossa senha quando pedida.

## Backups remotos

Se você tem acesso SSH ou mesmo apenas SCP/SFTP aos servidores do seu provedor
de armazenamento, não é preciso mudar muito para que o `duplicity(1)` armazene
os arquivos nesses servidores:

    $ duplicity --encrypt-key taspargos@exemplo.com.br Documentos sftp://usuario@backup.exemplo.com.br:backup_docs

Seus backups serão, então, enviados por SSH ao diretório `backup_docs` no
sistema `backup.exemplo.com.br`, com o nome de usuário `usuario`. Dessa
maneira, os dados são não apenas protegidos durante a transmissão, mas também
armazenados criptografados no servidor remoto, que nunca vê seus dados em texto
plano. Qualquer um que tenha acesso aos seus backups pode ver apenas o tamanho
aproximado dos dados, a data em que foram criados e (se você publicar sua chave
pública) a ID de usuário da chave do GnuPG usada para criptografá-los.

Se você estiver [usando o programa `ssh-agent(1)`][agentes] para armazenar suas
chaves privadas descriptografadas, você nem mesmo terá de digitar sua senha
para isso.

A interface do `duplicity(1)` suporta outros métodos de envio para diferentes
servidores, também, incluindo o backend `boto`, para o S3 Amazon Web Services,
o backend `gdocs`, para o Google Docs, e `httplib2` ou `oauthlib` para o Ubuntu
One.

Se você desejar, também é possível assinar seus backups, para garantir que não
foram modificados, mudando `--encrypt-key` para `--encrypt-sign-key`. Note que
essa operação irá requerer sua senha.

## Restaurando o backup

Restaurar a partir de um volume de backup do `duplicity` é bem parecido, mas os
argumentos são invertidos:

    $ duplicity sftp://usuario@backup.exemplo.com.br:backup_docs restaura_docs
    Sincronizando metadados remotos ao cache local...
    Senha GnuPG:
    Copiando duplicity-full-signatures.20130727T053433Z.sigtar.gpg ao cache local.
    Copiando duplicity-full.20130727T053433Z.manifest.gpg ao cache local.
    Copiando duplicity-inc.20130727T053433Z.to.20130727T053636Z.manifest.gpg ao cache local.
    Copiando duplicity-new-signatures.20130727T053433Z.to.20130727T053636Z.sigtar.gpg ao cache local.
    Data do último backup: Sat Jul 27 17:34:33 2013

Note que, dessa vez, sua senha será requerida, pois a restauração do backup
requer a descriptografia dos dados e possivelmente as assinaturas em seu volume
de backup. Após inseri-la, o conjunto completo de documentos mais recentemente
copiados estará disponível em `restaura_docs`.

Usando esse sistema incremental, também podemos restaurar os dados tal como
eram antes de uma data específica. Por exemplo, para recuperar meu diretório
`~/Documentos` tal como era há três dias, posso rodar:

    $ duplicity --time 3D \
        sftp://usuario@backup.exemplo.com.br:backup_docs \
        restaura_docs

Para volumes maiores, você pode extender esse comando para restaurar apenas
arquivos em particular, se precisar:

    $ duplicity --time 3D \
        --file-to-restore privado/eff.txt \
        sftp://usuario@backup.exemplo.com.br:backup_docs \
        restaura_docs

## Automatizando o backup

Você deve rodar seu primeiro backup interativamente para garantir que ele faz o
que você precisa mas, quando você estiver confiante que tudo está funcionando
corretamente, você pode escrever um Bash script simples para rodar backups
incrementais para você. Aqui está um exemplo, salvo em
`$HOME/.local/bin/backup-remote`:

    #!/usr/bin/env bash
    
    # Rode o keychain para encontrar quaisquer agentes armazenando chaves
    # descriptografadas que possamos precisar (opcional, dependendo da sua
    # configuração de chave do SSH) 
    eval "$(keychain --eval --quiet)"
    
    # Especifique um diretório para faze backup, uma ID de chave GnuPG, e um
    # usuário remoto e hostname
    keyid=taspargos@exemplo.com.br
    local=/home/tim/Documentos
    remote=sftp://usuario@backup.exemplo.com.br/backup_docs
    
    # Execute o backup com o duplicity
    /usr/bin/duplicity --encrypt-key "$keyid" -- "$local" "$remote"

A linha com `keychain` é opcional, mas será necessária se você estiver usando
uma chave SSH com senha; também será necessário ter se autenticado ao
`ssh-agent` ao menos uma vez. Veja o artigo anterior [sobre agentes
SSH/GPG][agentes] para mais detalhes.

Não esqueça de tornar o script executável:

    $ chmod +x ~/.local/bin/backup-remote

Você também pode pedir ao [`cron(8)`][cron] que execute-o uma vez por semana,
rodando como seu usuário, editando o [arquivo `crontab(5)` de
usuário][crontab_usuario]:

    $ crontab -e

A linha a seguir roda o script toda manhã, começando às 6:

    0 6 * * *   ~/.local/bin/backup-remote

## Dicas

Algumas melhores práticas gerais se aplicam ao nosso caso, consistentes com o
[Tao do Backup][tao_backup]:

- Garanta que seus backups são completados; peça ao `cron` que envie sua saída
  para seu email ou para um arquivo que você cheque pelo menos ocasionalmente,
  para ter certeza que seus backups estão funcionando. Recomendo altamente usar
  o email e incluir erros:

        MAILTO=voce@exemplo.com.br
        0 6 * * *   ~/.local/bin/backup-remote 2>&1

- Armazene seus backups em servidores locais, também. Você pode prevenir que
  seu provedor de backup leia seus arquivos, mas não pode evitar que sejam
  deletados acidentalmente.

- Não se esqueça de testar/restaurar seus backups ocasionalmente para garantir
  que estão funcionando corretamente. Também é aconselhável rodar `duplicity
  verify` sobre os arquivos ocasionalmente, especialmente se você não realiza o
  backup todos os dias:

        $ duplicity verify sftp://usuario@remoto.exemplo.com.br/backup_docs Documentos
        Os metadados remotos e locais estão sincronizados; nenhuma sincronização é necessária.
        Data da última cópia de segurança completa: Sat Jul 27 17:34:33 2013
        Senha GnuPG:
        Verificação completa: 2195 files compared, 0 differences found.

- Esse sistema incremental significa que você, provavelmente, terá de fazer
  backups completos apenas uma vez, portanto você deve copiar muito dados, ao
  invés de muito poucos dados; se você pode gastar a banda e tem espaço, copiar
  seu computador inteiro não é tão extremo.

- Tente não depender demais dos seus backups remotos; veja-os como último
  recurso e trabalhe seguramente e com backups locais tanto quanto puder.
  Certamente, nunca confie em backups como controle de versão; [use o Git para
  isso][git].

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[linux_crypto_intro]: {% post_url 2013-09-16-linux_cripto_intro %}
[ubuntu_one]: https://one.ubuntu.com/
[skydrive]: https://skydrive.live.com/
[conluio_nsa]: http://www.guardian.co.uk/world/2013/jul/11/microsoft-nsa-collaboration-user-data
[dirvish]: http://www.dirvish.org/
[duplicity]: http://duplicity.nongnu.org/
[duplicity_pkg]: http://packages.debian.org/wheezy/duplicity
[duplicity_man]: http://linux.die.net/man/1/duplicity
[agentes]: #
[cron]: http://linux.die.net/man/8/cron
[crontab_usuario]: http://blog.sanctum.geek.nz/user-cron-tasks/
[tao_backup]: http://www.taobackup.com/
[git]: http://git-scm.com/book
