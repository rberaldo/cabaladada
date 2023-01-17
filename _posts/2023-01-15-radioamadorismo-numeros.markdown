---
layout: post
title: "O radioamadorismo é sustentável no Brasil?"
author: Rafael Beraldo
excerpt: Quantos e quem são os radioamadores no Brasil? Será que essa prática tem futuro? Fuçando o site da Anatel e com um pouco de criatividade – e webscrapping – tento traçar a situação do radioamadorismo em nosso país.
---

Numa trilha pelo Espinhaço no carnaval de 2022, me dei conta de que um rádio teria
feito toda a diferença. Estávamos em um grupo com cerca de quinze pessoas e houve
momentos de algum estresse por não podemos nos comunicar facilmente. Foi assim que
resolvi tirar a licença de radioamador no ano passado, comprei meu primeiro rádio (um
Baofeng UV-5R) e tenho estudado e aprendido cada vez mais sobre a prática. Aliás, o
meu indicativo é `PU2URT` (de Urutu Branco – leitores do Guimarães Rosa entenderão);
me encontrem no [QRZ.com][qrz]!

![Em Ilha Grande, fazendo a volta munido do meu fiel Baofeng
UV-5R.](/assets/images/me-radio.webp "Selfie em Ilha Grande durante a volta à ilha,
com meu Baofeng UV-RT preso à mochila.")

Como atualmente moro em Campinas, tenho acompanhado as conversas nas repetidoras
locais, como as Chapéu de Couro (146.910 MHz) e de Palha (439.900 MHz), em Amparo, as
repetidoras do [Clube de Radioamadores de Americana][cram] (CRAM; 146.770 MHz) e as
raras conversas que escuto na repetidora do Capricórnio (146.810 MHz), localizada na
Serra das Cabras, próximo do Observatório Municipal Jean Nicolini. Aliás, fiz um
compilado das frequências que costumo ouvir para uso no CHIRP para quem estiver
interessado em configurar seu rádio para ouvir e transmitir nas repetidoras da região.
[Baixe aqui][csv-repetidoras].

Uma das coisas que mais tem me chamado a atenção no radioamadorismo é a (aparente,
pelo menos) falta de pessoas jovens ou novatos. Quer dizer, a prática me parece
dominada por pessoas mais experientes, que aprenderam o rádio há algumas décadas e
novos radioamadores não parecem estar entrando no hobby. Minhas elucubrações me
levaram a crer que a facilidade de comunicação via Internet, juntamente com a presença
universal dos celulares, foram um tipo de tiro de misericórdia no radioamadorismo.
Isso explicaria a falta de tráfego nas repetidoras e no _simplex_, ou seja,
comunicação ponto-a-ponto entre dois rádios.

Mas, será mesmo que esse é o caso? Que métricas podemos consultar para obter uma
imagem do radioamadorismo no Brasil? Neste post, vou tentar obter alguns dados no site
da Anatel para caracterizar quem e quantos são, onde vivem e qual a idade dos
radioamadores.

## Uma hipótese e algumas perguntas

A minha hipótese sobre o estado do radioamadorismo no Brasil foi exposta acima: minha
breve experiência parece indicar que há poucos novos radioamadores, de modo que essa
poderia ser uma prática que está fadada a deixar de existir no Brasil. Rádios são
equipamentos caros e as repetidoras usadas no VHF (faixa dos 2m) e no UHF (faixa dos
70cm), que me parecem ser as mais acessíveis para os novatos, exigem constante
manutenção e alguém ou uma associação que pague a conta. Com menos radioamadores na
cena, como essa infraestrutura iria se manter?

Assim, queria responder pelo menos as seguintes perguntas:

- Qual a idade dos radioamadores no Brasil?
- Quantos radioamadores há no país?
- Onde eles estão localizados?
- Qual a tendência para a taxa de novos licenciamentos?

Nem todas elas puderam ser respondidas satisfatoriamente. Além disso, de acordo com os
dados limitados que consegui levantar, parece que eu estava errado em supor que há
poucos novos radioamadores. Vamos aos números.

## Dados oficiais da Anatel

O primeiro lugar onde podemos obter e visualizar dados é no próprio site da Anatel, em
[Painéis de Dados → Outorga e Licenciamento → Estações Licenciadas][anatel-dados]. Lá
é possível filtrar a exibição apenas para as estações licenciadas de radioamador, o
que nos dá um número total de 42.516 licenças. Para fins de comparação, há cerca de
dez mil estações de rádio no Brasil [segundo o Ministério das
Comunicações][dados-radio].

Façamos algumas contas de padaria colocar esse número em perspectiva. A proporção da
população que tem licença para operar estações de radioamador é de aproximadamente
0,02% (segundo o IBGE, estávamos estimados em 213,3 milhões em 2021). Isso significa
que uma a cada 5.000 pessoas está outorgada. Nos Estados Unidos, um país com dimensões
e população relativamente comparáveis, a quantidade de radioamadores é dez vezes
maior: [há quase 800.000 licenciados][numeros-wikipedia], ou cerca de 0,233% da
população.

Mas como os radioamadores nos distribuímos pelo território nacional? O mapa abaixo,
extraído do site da Anatel, indica que há uma concentração de radioamadores no
Sudeste, no Sul e em estados do Nordeste (cores escuras indicam maior densidade):

![Há cerca de dez mil radioamadores em São Paulo, metade disso no Rio de Janeiro e
cerca de três mil em Minas Gerais; o Nordeste também se
destacada.](/assets/images/mapa-radioamadores.png "Mapa com a densidade de
radioamadores por estado.")

Em valores numéricos:

| Estado              | Estações |
|---------------------|----------|
| São Paulo           | 10.800   |
| Rio de Janeiro      | 4.685    |
| Minas Gerais        | 3.506    |
| Paraná              | 3.299    |
| Rio Grande do Sul   | 3.239    |
| Santa Catarina      | 2.748    |
| Ceará               | 2.107    |
| Paraíba             | 1.875    |
| Rio Grande do Norte | 1.553    |
| Pernambuco          | 1.244    |
| Distrito Federal    | 1.189    |
| Bahia               | 1.168    |
| Goiânia             | 699      |
| Piauí               | 622      |
| Mato Grosso do Sul  | 607      |
| Espírito Santo      | 587      |
| Pará                | 462      |
| Sergipe             | 370      |
| Alagoas             | 366      |
| Maranhão            | 296      |
| Mato Grosso         | 275      |
| Amazonas            | 237      |
| Rondônia            | 229      |
| Amapá               | 126      |
| Roraima             | 105      |
| Tocantins           | 66       |
| Acre                | 58       |

Até o momento, conseguimos obter os dados para duas perguntas: a quantidade e
localização dos radioamadores. Entretanto, o site da Anatel não traz dados pessoais,
em especial a idade dos operadores. Para isso, teremos que usar um _proxy_, ou seja,
algum outro dado que possa estar correlacionado com a idade dos radioamadores.

## Qual a idade dos radioamadores?

Essa pergunta se provou impossível de responder – a não ser que pesquisássemos os
42.000 radioamadores, um a um. Apesar disso, talvez seja possível estimar a idade dos
radioamadores a partir da obtenção do primeiro registro de estação para cada
indicativo. A hipótese é que, em havendo uma concentração de registros em anos
passados e menos em anos recentes, há de se esperar que a idade dos radioamadores siga
essa tendência.

A [página de consulta de indicativos da Anatel][consulta-indicativos] nos permite
inserir um indicativo e obter dados como a localização das estações a ele associadas,
a data de validade da licença de cada estação, o nome do autorizado, a sua classe de
radioamador e, crucialmente, a data de primeiro registro das estações. Por exemplo, a
minha data de inclusão é 15/07/2022 e a data de validade é 23/06/2042. Estou
presumindo, aqui, que ao renovar o indicativo, a data original de inclusão da primeira
estação será mantida.

O problema é que essa informação deve ser obtida de maneira manual, ou seja, nós
teríamos que digitar os indicativos um a um. Felizmente, foi possível confeccionar uma
série de comandos no terminal do Linux para automatizar a tarefa. De maneira bastante
resumida, primeiro a lista de indicativos foi obtida no site da Anatel. Então, um robô
baixou a página correspondente a cada indicativo. Finalmente, foi possível extrair o
ano mais antigo de cada página, produzindo-se assim os dados que discutiremos a
seguir. A metodologia completa está anexada após a conclusão deste pequeno artigo.

### Primeiros registros de cada indicativo

O gráfico abaixo ([clique aqui](/assets/images/registros-indicativos.png) para uma
versão maior) apresenta o número de primeiros registros de estação por ano,
desde 1987. Podemos ver que o maior número de registros, ao contrário do que minha
hipótese supunha, não se concentra nos anos iniciais; na realidade, observamos
exatamente o contrário! Parece que há uma distribuição relativamente uniforme dos
registros, então não é possível dizer que há uma tendência de desaparecimento nos
registros de novos radioamadores.

![Histograma de registros de estação por
ano.](/assets/images/registros-indicativos.png "Histograma de registros de estação por
ano. Ao contrário do que supus, não há uma concentração de registros em datas mais
antigas.")

Gostaria de especular sobre algumas tendências curiosas:

- O primeiro registro é de 1987, ano em que há apenas uma estação registrada.
  Presumivelmente, havia radioamadores desde muito antes disso; é possível que o
  sistema informatizado tenha sido implementado no fim dos anos 80.
- Suponho que o registro informatizado foi um processo gradual e que os radioamadores
  paulatinamente atualizaram seu cadastro para o meio digital. A data final para essa
  atualização de dados me parece ter sido 1998, quando o número de registros explode,
  tendência que não se verifica nos anos consecutivos.
- Uma outra possibilidade é que a promulgação da Constituição Cidadã de 1988 e o fim
  da ditadura militar no Brasil estejam relacionados ao início dos registros
  identificados aqui (obrigado, [Igor Costa][igor-costa], por esse apontamento
  histórico!).
- No começo dos anos 2010 e até 2019, a média de novos registros por ano fica em quase
  2.000 novos registros por ano. Essa tendência acaba justamente em 2020, o ano da
  pandemia. É possível que o interesse pelo radioamadorismo tenha crescido em meados
  de 2010, seja por mudanças na legislação ou por mais fácil acesso ao equipamento ou
  informação.
- Não podemos concluir, entretanto, que há uma falta de interesse após 2019; é
  possível que a pandemia tenha impactado negativamente o processo para a obtenção de
  novas licenças. De fato, o sistema de provas online para obtenção do Certificado de
  Operador de Estação de Radioamador (COER), que ainda perdura, foi implementado
  apenas como resposta à pandemia.

## O radioamadorismo tem futuro no Brasil?

Ainda me é um pouco estranho que pareça haver pessoas mais experientes do que novatos
no ar. Apesar disso, se a minha metodologia e os dados levantados estiverem corretos,
então somos obrigados a concluir que, embora não haja um número muito grande de
radioamadores no Brasil proporcionalmente à população, o interesse pela licença parece
ter se mantido constante.

Embora o Sudeste, Sul e alguns estados do Nordeste concentrem o maior número de
radioamadores, me parece que há poucos justamente em estados menos densamente
populados, onde o serviço fornecido pelo radioamador em situações de emergência, ou
como ponte de contato com o mundo, poderia ser ainda mais valioso. Presumivelmente,
deve haver também menos estrutura, como torres repetidoras, nesses locais. É claro que
isso pode ser mitigado pelo uso de frequências, como os 11m ou 20m, cujas propriedades
naturais podem propagá-las até mesmo para outros locais do mundo. Entretanto, essas
bandas são menos amigáveis para o iniciante tanto do ponto de vista do custo, quanto
da facilidade de operação: é muito comum que se comece, como eu mesmo estou começando,
por exemplo com o uso de HTs (_hand talks_, ou rádios móveis).

O [estudo estatístico do professor Ricardo da Silva Benedito PY2QB
(UFABC)][estudo-estatistico] aborda essa questão com uma métrica interessante: o
número de estações de radioamador por 100 mil habitantes é relativamente maior em uma
série de estados menos populosos. O estudo especula que isso pode indicar que há uma
cultura de radioamadorismo mais bem difundida nessas regiões, o que pode estar
relacionado ao fato levantado acima de que esses estados são menos densamente
populados. Vale a pena ler o material, que vai muito além desta pequena análise que
realizei, incidindo inclusive sobre a importante questão da proporção desigual de
homens (93%) e mulheres (apenas 7%) no hobby.

Uma pergunta que me faço desde que iniciei o processo para tirar minha licença e que
me fiz mais agudamente durante essa breve pesquisa foi sobre como poderíamos
popularizar mais a atividade do radioamadorismo. Quais são as barreiras de entrada? Me
parece que

- a falta de acesso à informação
- o processo burocrático envolvido no licenciamento
- o custo dos equipamentos e
- a universalidade do celular e da Internet nas cidades

são fatores que poderiam explicar a baixa adesão ao hobby de radioamador. Por exemplo,
conheci pessoas em grupos de trilha que têm rádios móveis como meu Baofeng, mas
restringem seu uso à trilha e à comunicação _simplex_. Não conhecem as associações de
radioamadores, ou diferentes bandas e suas características de uso, nem mesmo como
programar o rádio para ativação de uma repetidora, que poderia ser útil em certos
locais bastante frequentados pelos trilheiros. Esse seria um dos públicos ideais para
se atrair ao radioamadorismo: pessoas motivadas a aprender e que teriam uma aplicação
prática dos conhecimentos e normas desse serviço.

Hoje mesmo estava escutando a [uma transmissão no YouTube do radioamador Alexandre PU2YPO][live-youtube], em QSO – ou seja, uma conversa – com um senhor de Três
Corações, MG. Esse senhor, [Zé Mauro Braz PY4JMB][ze-mauro], é deficiente visual e uma
de suas formas de comunicação com o mundo é justamente o rádio, que o permite conhecer
pessoas de longe e prestar informações quando chamado. Essa anedota representa bem a
comunidade dos radioamadores: pessoas abertas, comunicativas e com vontade de se
conectar umas com as outras para compartilhar interesses em comum. Se uma classe tão
pequena quanto a dos radioamadores consegue manter uma infraestrutura não só física,
mas também comunitária, não seriam eles capazes de expandir ainda mais essa atividade
para novas pessoas que, apesar de não a conhecerem, ficariam fascinadas com sua
riqueza e possibilidades?

---

Obrigado pela leitura! Ficou curioso para se tornar um radioamador? Fique de olho
nesse blog, porque estou preparando um material para introduzir o radioamadorismo aos
trilheiros.

---

## Anexo: obtendo os dados de todos os indicativos

Para estimar a idade dos radioamadores no Brasil, decidi encontrar os anos de primeiro
registro das estações no [site de consulta de indicativos da
Anatel][consulta-indicativos]. Seria impossível pesquisar os mais de quarenta mil
indicativos manualmente, portanto encontrei uma maneira programática de compilar essa
informação.

Primeiramente, obtive a lista de todos os indicativos existentes baixando o arquivo
ZIP disponibilizado no [site de informações e dados abertos da Anatel][anatel-dados],
clicando no botão de dados abertos. Uma [cópia desse arquivo está disponível
aqui][dados-estacoes]. Abri o CSV no meu editor de planilhas e filtrei tudo aquilo que
não fosse estação de radioamador; depois disso, deletei as colunas espúrias, mantendo
apenas a coluna com os indicativos. Finalmente, removi os indicativos que por algum
motivo estavam repetidos, [obtendo o número exato de 42.516
indicativos][dados-indicativos]. Bingo!

De posse dessa informação, com algum custo e usando do método do erro e acerto,
confeccionei um script em Bash para baixar os dados de cada um dos indicativos nessa
longa lista:

{% highlight bash %}
 #!/bin/bash
 #
 # Baixa, de maneira paralelizada, informações referentes a indicativos
 # no site da Anatel.

 # Criar 50 instâncias paralelas do curl.
 N=50
 (
     for ind in $(cat indicativos-uniq-2023-01-15.txt) ; do
         ((i=i%N)); ((i++==0)) && wait
         echo "Baixando indicativo $ind"
         # Baixar a página do indicativo $ind
         curl -X POST \
              -H "Content-Type=x-www-form-urlencoded" \
              # Preencher o campo do formulário de busca com o indicativo.
              -d "pIndicativo=$ind" \
                  https://sistemas.anatel.gov.br/easp/Novo/ConsultaIndicativo/Tela.asp?acao=e \
                  -o $ind.html 2> /dev/null &
     done
 )
{% endhighlight %}

O processo demorou várias horas, porque houve situações em que o processo do `curl`
falhou em baixar a página, provavelmente algum erro no servidor da Anatel; tive que
reiniciar o processo algumas vezes, excluindo manualmente os indicativos já baixados.

Em seguida, notei que alguns indicativos eram especiais, ou seja, concedidos pela
Anatel para uso em eventos específicos. Esse é o caso, por exemplo, de `ZZ5FLORIPA`.
Encontrei-os com o seguinte código

{% highlight bash %}
 grep "9 - Especial" *.html -o | cut -d : -f 1
{% endhighlight %}

e excluí todas as páginas referentes a esses indicativos especiais. Ao cabo, sobraram
42.202 indicativos regulares. Agora, só restava obter o ano do primeiro registro de
cada um:

{% highlight bash %}
 #!/bin/bash

 # Criar o arquivo CSV
 echo "ano" > anos.csv

 for indicativo in $(ls *.html) ; do
   # Encontrar as datas no arquivo
   grep -E [0-9]{2}/[0-9]{2}/[0-9]{4} -o "$indicativo" |
   # Pular a primeira data (comentário no HTML)
   tail +2 |
   # Cortar apenas os anos e ordená-los
   cut -d / -f 3 | sort |
   # Retornar primeira linha (ano mais antigo)
   sed -n 1p >> anos.csv ;
 done
{% endhighlight %}

Como havia uma data usada em documentação em um comentário no HTML da página, foi
necessário pular essa primeira data; só depois é que o _script_ isola os anos, os
ordena, de modo que o mais antigo esteja na primeira linha e retorna exatamente essa
linha. Assim, se o meu código estiver todo correto, obtivemos então os anos de
primeiro registro de estação para cada indicativo na base de dados da Anatel.

O arquivo com os anos foi então alimentado no seguinte _script_ em R

{% highlight R %}
 require(ggplot2)

 dados <- read.csv("anos.csv")
 contagem <- as.data.frame(table(dados$ano))

 ggplot(contagem, aes(x=Var1, y=Freq)) +
     geom_bar(stat="identity") +
     geom_text(aes(label=Freq), vjust=-1) +
     labs(title="Número de primeiros registros de estação por indicativo",
          x="Ano",
          y="Primeiros registros") +
     theme_minimal() +
     theme(panel.background = element_blank(),
           panel.grid.major.x = element_blank())
{% endhighlight %}

que gerou o gráfico apresentado mais acima.

[qrz]: https://www.qrz.com/db/pu2urt
[cram]: https://www.cram.org.br/
[csv-repetidoras]: /public/Campinas-Repetidoras-CSV-20230115.csv
[anatel-dados]: https://informacoes.anatel.gov.br/paineis/outorga-e-licenciamento/estacoes-licenciadas
[dados-radio]: https://www.gov.br/mcom/pt-br/noticias/2021/setembro/radio-no-brasil-ha-mais-de-100-anos-criando-e-contando-historias
[consulta-indicativos]: https://sistemas.anatel.gov.br/easp/Novo/ConsultaIndicativo/Tela.asp
[dados-estacoes]: /public/estacoes_licenciadas-2023-01-15.zip
[dados-indicativos]: /public/indicativos-uniq-2023-01-15.txt
[numeros-wikipedia]: https://en.wikipedia.org/wiki/Amateur_radio_operator
[igor-costa]: https://igordeo-costa.github.io
[PU2YPO]: https://www.youtube.com/@alexandrepu2ypo/
[estudo-estatistico]: https://www.labre.org.br/radioamadorismo-no-brasil-versao-2021/
[live-youtube]: https://youtu.be/iQcYBRb1VZ0
[ze-mauro]: http://www.hambrasil.com.br/PY4JMB
