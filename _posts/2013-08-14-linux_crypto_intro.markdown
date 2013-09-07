---
layout: post
title: "Criptografia no Linux: Introdução"
author: Tom Ryder (autoria) e Rafael Beraldo (tradução)
excerpt: "No qual apresento uma tradução do texto “Linux Crypto: Introduction” de Tom Ryder. A criptografia para a autenticação e encriptação é um campo complexo e que muda com frequência e, para alguém novo no assunto, pode ser difícil saber onde começar. Se você é um usuário de Linux confortável com o terminal, mas não tem familiaridade com as ferramentas de criptografia disponíveis em sistemas operacionais abertos estilo UNIX, essa é uma série de posts que visa ajudá-lo."
---

Essa é uma série de posts que será publicada em dez partes, traduzindo o
original de Tom Ryder, [Linux Crypto][linux_crypto]. Essa série está sob uma
licença [Creative Commons 3.0][cc].

---

A criptografia para a autenticação e encriptação é um campo complexo e que muda
com frequência e, para alguém novo no assunto, pode ser difícil saber onde
começar. Se você é um usuário de Linux confortável com o terminal, mas não tem
familiaridade com as ferramentas de criptografia disponíveis em sistemas
operacionais abertos estilo UNIX, essa é uma série de posts que visa ajudá-lo a
configurar algumas ferramentas básicas que permitirão manter suas informações
seguras, autenticar convenientemente e seguramente a servidores remotos e a
trabalhar com arquivos online assinados digitalmente e criptografados.

Trabalharei com o Debian GNU/Linux, mas a maior parte dessas ferramentas deve
se adaptar bem em outros sistemas abertos no estilo UNIX, incluindo o BSD.
Sinta-se a vontade para comentar nos artigos sobre detalhes relevantes para
suas próprias implementações, ou considerações extras de segurança para
os leitores interessados.

Aviso que não sou um expert em algorítimos criptográficos ou em seguranças de
chaves. Se você é um e encontrar algum erro ou problema de segurança em
qualquer uma de minhas explicações ou sugestões, por favor, avise-me que irei
corrigi-los e lhe darei o crédito.

Cobrirei os seguintes tópicos:

- [Geração e manutenção de chaves para o GnuPG][gnupg_intro]
- [Assinando, verificando, criptografando e descriptografando com o GnuPG][gnupg_uso]
- [Geração e autenticação com chaves SSH][ssh_chaves]
- [`gpg-agent(1)`, `ssh-agent(1)` e o uso do `keychain(1)`][agents]
- [O gerenciador de senhas `pass(1)`][pass]
- [Emails criptografados/assinados com PGP usando o `mutt(1)`][mutt]
- [Backups incrementais e criptografados usando o `duplicity(1)`][duplicity]
- [Drives USB criptografados usando o LUKS][luks]
- [A importância da criptografia e sua ampla utilização][criptografia_importancia]

Se você já conhece sobre um tópico específico, sinta-se livre para pular para
os outros artigos.

[linux_crypto]: http://blog.sanctum.geek.nz/series/linux-crypto/
[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/
[gnupg_intro]: #
[gnupg_uso]: #
[ssh_chaves]: #
[agentes]: #
[pass]: #
[mutt]: #
[duplicity]: #
[luks]: #
[criptografia_importancia]: #
