---
layout: post
title: "Criptografia no Linux: Discos"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt: O GnuPG oferece uma maneira de criptografar seguramente arquivos individuais num sistema de arquivos, mas para informações ou sistemas de alta segurança, pode ser apropriado criptografar um disco inteiro para mitigar problemas como o cache de arquivos sensíveis em texto plano.
---

Este é o nono post de uma série de dez posts traduzindo o original de Tom
Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma licença [Creative
Commons 3.0][cc].

Para a lista de posts, veja a [introdução][linux_crypto_intro].

---

O GnuPG oferece uma maneira de criptografar seguramente arquivos individuais
num sistema de arquivos, mas para informações ou sistemas de alta segurança,
pode ser apropriado criptografar um disco inteiro para mitigar problemas como o
cache de arquivos sensíveis em texto plano. Possivelmente, o modo mais popular
de fazê-lo é usar a ferramenta [TrueCrypt][truecrypt], mas o kernel do Linux
inclui a sua própria solução de criptografia de disco, o `dm-crypt`. Você pode
tirar proveito dela utilizando uma ferramenta de baixo nível chamada
`cryptsetup`, ou mais facilmente com a LUKS, a [Linux Unified Key Setup][luks],
implementando criptografia com senhas ou arquivos de chave.

Neste exemplo, demonstraremos como criptografar um disco USB, um bom método
para armazenar seguramente dados realmente sensíveis, como chaves mestras PGP
que só são necessárias ocasionalmente, ao invés de deixá-las constantemente
montadas num dispositivo conectado à rede. Tenha cuidado, pois essa operação
apagará qualquer arquivo existente no disco.

## Instalação

As ferramentas criptográficas utilizadas pelo `dm-crypt` e pela LUKS são
embutidas no Linux a partir da versão 2.6, mas você talvez tenha de instalar um
pacote para acessar a interface `cryptsetup`. Em sistemas baseados no Debian,
ela está disponível no pacote [`cryptsetup`][cryptsetup_deb]:

    # apt-get install cryptsetup

Em sistemas baseados em pacotes RPM, como o Fedora ou CentOS, o pacote tem o
mesmo nome, [`cryptsetup`][cryptsetup_rpm]

    # yum install cryptsetup

## Criando o volume

Após identificarmos em qual dispositivo de blocos queremos o sistema de
arquivos criptografado, por exemplo `/dev/sdc1`, podemos deletar qualquer
conteúdo existente usando o `wipefs`:

    # wipefs -a /dev/sdc1

Alternativamente, podemos zerar o disco inteiro, se quisermos sobrescrever
completamente qualquer traço de dados prévios no disco. Essa operação pode
levar um longo tempo para volumes grandes:

    # cat /dev/zero >/dev/sdc1

Se você não tiver um dispositivo USB em mãos, mas ainda assim quiser testar
essas instruções, é possível utilizar um dispositivo de loop num arquivo. Por
exemplo, para criar um dispositivo de loop de 100MB:

    # dd if=/dev/zero of=/loopdev bs=1k count=102400
    102400+0 records in
    102400+0 records out
    104857600 bytes (105 MB) copied, 0.331452 s, 316 MB/s
    # losetup -f
    /dev/loop0
    # losetup /dev/loop0 /loopdev

Você pode seguir o resto deste guia usando `/dev/loop0` como o dispositivo de
blocos em lugar de `/dev/sdc1`. Na saída acima, o comando `losetup -f` retorna
o primeiro dispositivo de loop disponível para uso.

A configuração de um container LUKS num dispositivo de blocos é realizada como
a seguir, sendo necessário fornecer uma senha forte; como sempre, quanto mais
longa, melhor. Idealmente, você não deve utilizar a mesma senha que suas chaves
do GnuPG ou SSH.

    # cryptsetup luksFormat /dev/sdc1

    WARNING!
    ========
    This will overwrite data on /dev/sdc1 irrevocably.

    Are you sure? (Type uppercase yes): YES
    Enter passphrase:
    Verify passphrase:

Esse comando cria um container de criptografia abstrato no disco, que pode ser
aberto fornecendo a senha correta. Um dispositivo virtual mapeado é fornecido
para criptografar todos os dados escritos a ele transparentemente, com os dados
criptografados escritos no disco.

## Usando o dispositivo mapeado

Podemos abrir o dispositivo mapeado utilizando `cryptsetup luksOpen`, que
também irá perguntar a senha:

    # cryptsetup luksOpen /dev/sdc1 secreto

Isso feito, o dispositivo de blocos em `/dev/mapper/secreto` pode ser utilizado
da mesma maneira que qualquer outro dispositivo; todas as operações de disco
são abstraídas pelas operações de criptografia. Provavelmente, você irá desejar
criar um sistema de arquivos nele. No meu caso, criarei um sistema `ext4`:

    # mkfs.ext4 /dev/mapper/secreto
    mke2fs 1.42.8 (20-Jun-2013)
    Filesystem label=
    OS type: Linux
    Block size=1024 (log=0)
    Fragment size=1024 (log=0)
    Stride=0 blocks, Stripe width=0 blocks
    25168 inodes, 100352 blocks
    5017 blocks (5.00%) reserved for the super user
    First data block=1
    Maximum filesystem blocks=67371008
    13 block groups
    8192 blocks per group, 8192 fragments per group
    1936 inodes per group
    Superblock backups stored on blocks:
            8193, 24577, 40961, 57345, 73729
    
    Allocating group tables: done
    Writing inode tables: done
    Creating journal (4096 blocks): done
    Writing superblocks and filesystem accounting information: done

Agora, podemos montar o dispositivo normalmente, e os dados colocados no
recém-criado sistema de arquivo serão criptografados transparentemente:

    # mkdir -p /mnt/secreto
    # mount /dev/mapper/secreto /mnt/secreto

Podemos, por exemplo, armazenar nossa chave privada do GnuPG:

    # cp -prv /home/tim/.gnupg/secring.gpg /mnt/secreto

## Informações sobre o dispositivo

Podemos obter informações sobre o container LUKS e as especificidades de sua
criptografia usando o argumento `luksDump` no sistema de blocos subjacente. Ele
nos mostra o método de criptografia utilizado, nesse caso, `aes-xts-plain64`.

    # cryptsetup luksDump /dev/sdc1
    LUKS header information for /dev/sdc1

    Version:        1
    Cipher name:    aes
    Cipher mode:    xts-plain64
    Hash spec:      sha1
    Payload offset: 4096
    MK bits:        256
    MK digest:      87 6d 08 59 b2 f0 c6 6e ca ec 5f 72 2c e0 35 33 c2 9e cb 8e
    MK salt:        7f a5 38 4c 14 85 61 cb 6c 22 65 48 87 21 60 8f
                    fa 40 2a ab ae 7d cc df c9 9b a4 e3 3c 64 b6 bb
    MK iterations:  49375
    UUID:           f4e5f28c-3b34-4003-9bcd-dbb2352042ba

    Key Slot 0: ENABLED
            Iterations:             197530
            Salt:                   2d 57 f6 2b 44 a6 61 ee d6 ee e4 7d 64 f0 71 d6
                                    55 16 09 83 b4 f0 94 ca 19 17 11 a9 34 84 02 96
            Key material offset:    8
            AF stripes:             4000
    Key Slot 1: DISABLED
    Key Slot 2: DISABLED
    Key Slot 3: DISABLED
    Key Slot 4: DISABLED
    Key Slot 5: DISABLED
    Key Slot 6: DISABLED
    Key Slot 7: DISABLED

## Desmontando o dispositivo

Quando terminamos de trabalhar com o dispositivo, devemos desmontar quaisquer
sistemas de arquivos presentes e, também, fechar o dispositivo mapeado, para
que a senha seja necessária para reabri-lo:

    # umount /mnt/secreto
    # cryptsetup luksClose /dev/mapper/secreto

Se ele também é um dispositivo removível, você também deve considerar a remoção
física da mídia e colocá-la em algum local seguro.

Esse post apenas arranha a superfície da funcionalidade da LUKS; muitas outras
coisas são possíveis com o sistema, incluindo a montagem automática de sistemas
de arquivos criptografados e o uso de arquivos de chave armazenados ao invés de
senhas digitadas. O [FAQ do `cryptsetup`][faq] contém uma grande quantidade de
informações, incluindo considerações sobre a recuperação de dados, e a Arch
Wiki contém [uma página muito completa][arch_wiki] com muitas outras maneiras
de usar a LUKS seguramente.

Essa entrada é a parte 9 de 10 na série [Criptografia no
Linux][linux_crypto_intro].

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[linux_crypto_intro]: {% post_url 2013-09-16-linux_cripto_intro %}
[truecrypt]: http://www.truecrypt.org/
[luks]: https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup
[cryptsetup_deb]: http://packages.debian.org/wheezy/cryptsetup
[cryptsetup_rpm]: https://admin.fedoraproject.org/pkgdb/acls/name/cryptsetup
[faq]: https://code.google.com/p/cryptsetup/wiki/FrequentlyAskedQuestions
[arch_wiki]: https://wiki.archlinux.org/index.php/Dm-crypt_with_LUKS
