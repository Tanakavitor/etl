# Projeto ETL

Este é um projeto de ETL (Extract, Transform, Load) desenvolvido em OCaml. 
## Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas:

- [OCaml](https://ocaml.org/) - Linguagem de programação funcional utilizada no projeto.
- [Dune](https://dune.build/) - Ferramenta de construção para projetos OCaml.
## Estrutura do Projeto
O projeto está organizado da seguinte forma:
- **`bin/main.ml`**: Arquivo principal que contém a lógica do ETL.
- **`data/`**: Diretório contendo os arquivos CSV de entrada (`order.csv` e `order_item.csv`).
- **`output/`**: Diretório onde o arquivo CSV de saída (`totals.csv`) será gerado após a execução.
## Como Executar
```bash
"dune exec bin/main.exe"
```
# Relatório
Para a criação do ETL em OCaml, o código foi desenvolvido em várias etapas. A primeira parte consistiu na criação dos registros (`records`) de acordo com os arquivos de entrada e o que era esperado na saída. Assim, foram criados três registros.

Após isso, foi necessário realizar a leitura dos dois CSVs. Para isso, utilizou-se uma biblioteca de OCaml que transforma cada linha em uma lista, resultando em uma lista de listas como saída final. Esse processo foi aplicado para ambos os arquivos de entrada. No entanto, antes de manipular essas listas, foi necessário remover a primeira linha de cada uma, pois continham os cabeçalhos descritivos das colunas. Para isso, criou-se uma função específica para eliminar o cabeçalho. Com isso, foi possível usar um `map` para aplicar a função responsável por transformar as linhas em registros (`records`). Além disso, foram adicionados os parâmetros necessários para a saída, realizando a manipulação dos dados conforme especificado.

Depois, conforme o enunciado, seria necessário passar alguns parâmetros para filtrar os dados de pedidos. Para isso, foi criada uma função que exibia uma mensagem com os possíveis valores a serem escolhidos ou permitia não aplicar filtros caso desejado. Essas entradas foram armazenadas em duas variáveis.

Após isso, foram criadas duas funções utilizando *pattern matching*. Essas funções retornavam a lista original caso nenhum filtro fosse aplicado, ou filtravam os dados quando um valor específico era escolhido, verificando se o parâmetro do registro correspondia ao critério do enunciado isso na lista order.

Com a lista order agora contendo apenas os pedidos que o usuário desejava, partimos para manipular o order_item, que já havia passado por um filtro para transformar cada linha em registros (`records`). Para isso, foi criada uma função que filtrava o order_item, mantendo apenas os itens cujos IDs estavam presentes na lista de pedidos order filtrada.

Tendo essa lista, foi necessário agrupar os pedidos por ID, somando os valores totais e as taxas acumuladas. Para isso, foi criada uma função específica, denominada `calculate_totals_per_order`, responsável por realizar esse processamento. Essa função foi desenvolvida com o auxílio de ferramentas de IA que também foi utilizada para gerar um arquivo CSV de saída contendo os resultados consolidados alem de correção de alguns erros.

Com o código já funcionando, a última etapa consistiu em "limpar o código". No bloco `let () =`, as variáveis estavam realizando muitas operações diretamente na linha. Para melhorar a estrutura, essas operações foram retiradas e transformadas em funções auxiliares e colocadas em cima, deixando o código mais organizado e modular.


