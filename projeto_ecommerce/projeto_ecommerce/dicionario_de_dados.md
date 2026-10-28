# Dicionário de Dados 

## 1. categoria

Armazena as categorias usadas para organizar os produtos.

| Campo | Tipo | Tamanho/valores | Nulo | Chave/regra | Descrição |
|---|---|---:|---|---|---|
| `id_categoria` | INT | — | Não | PK, AUTO_INCREMENT | Identificador da categoria. |
| `nome` | VARCHAR | 60 | Não | UNIQUE (`uq_categoria_nome`) | Nome da categoria; não pode se repetir. |
| `descricao` | VARCHAR | 200 | Sim | — | Descrição da categoria. |

## 2. cliente

Armazena os dados dos clientes da loja.

| Campo | Tipo | Tamanho/valores | Nulo | Chave/regra | Descrição |
|---|---|---:|---|---|---|
| `id_cliente` | INT | — | Não | PK, AUTO_INCREMENT | Identificador do cliente. |
| `nome` | VARCHAR | 100 | Não | — | Nome completo do cliente. |
| `email` | VARCHAR | 120 | Não | UNIQUE (`uq_cliente_email`); CHECK (`ck_cliente_email`) | E-mail do cliente. O CHECK valida um formato mínimo. |
| `cpf` | CHAR | 11 | Não | UNIQUE (`uq_cliente_cpf`); CHECK (`ck_cliente_cpf`) | CPF sem pontuação, com 11 dígitos. |
| `telefone` | VARCHAR | 20 | Sim | — | Telefone para contato. |
| `data_cadastro` | DATETIME | — | Não | DEFAULT `CURRENT_TIMESTAMP` | Data e hora do cadastro. |
| `ativo` | TINYINT(1) | 0 ou 1 | Não | DEFAULT 1; CHECK (`ck_cliente_ativo`) | Indica se o cadastro está ativo: 1 = sim; 0 = não. |

## 3. endereco

Armazena os endereços cadastrados pelos clientes.

| Campo | Tipo | Tamanho/valores | Nulo | Chave/regra | Descrição |
|---|---|---:|---|---|---|
| `id_endereco` | INT | — | Não | PK, AUTO_INCREMENT | Identificador do endereço. |
| `id_cliente` | INT | — | Não | FK (`fk_endereco_cliente`) → `cliente.id_cliente` | Cliente dono do endereço. Um cliente pode ter vários endereços. |
| `logradouro` | VARCHAR | 120 | Não | — | Rua ou avenida. |
| `numero` | VARCHAR | 10 | Não | — | Número do endereço; pode conter texto, como “S/N”. |
| `bairro` | VARCHAR | 60 | Não | — | Bairro do endereço. |
| `cidade` | VARCHAR | 60 | Não | — | Cidade do endereço. |
| `uf` | CHAR | 2 | Não | — | Sigla do estado. |
| `cep` | CHAR | 8 | Não | CHECK (`ck_endereco_cep`) | CEP sem pontuação, com 8 dígitos. |
| `principal` | TINYINT(1) | 0 ou 1 | Não | DEFAULT 1; CHECK (`ck_endereco_principal`) | Indica se é o endereço principal: 1 = sim; 0 = não. |

## 4. produto

Armazena os produtos disponíveis no catálogo.

| Campo | Tipo | Tamanho/valores | Nulo | Chave/regra | Descrição |
|---|---|---:|---|---|---|
| `id_produto` | INT | — | Não | PK, AUTO_INCREMENT | Identificador do produto. |
| `id_categoria` | INT | — | Não | FK (`fk_produto_categoria`) → `categoria.id_categoria` | Categoria à qual o produto pertence. |
| `nome` | VARCHAR | 100 | Não | — | Nome comercial do produto. |
| `descricao` | VARCHAR | 255 | Sim | — | Descrição do produto. |
| `preco` | DECIMAL | 10,2 | Não | CHECK (`ck_produto_preco`): maior que 0 | Preço atual do produto. |
| `estoque` | INT | — | Não | DEFAULT 0; CHECK (`ck_produto_estoque`): maior ou igual a 0 | Quantidade disponível em estoque. |
| `ativo` | TINYINT(1) | 0 ou 1 | Não | DEFAULT 1; CHECK (`ck_produto_ativo`) | Indica se o produto está disponível: 1 = sim; 0 = não. |

## 5. pedido

Registra as compras realizadas pelos clientes.

| Campo | Tipo | Tamanho/valores | Nulo | Chave/regra | Descrição |
|---|---|---:|---|---|---|
| `id_pedido` | INT | — | Não | PK, AUTO_INCREMENT | Identificador do pedido. |
| `id_cliente` | INT | — | Não | FK (`fk_pedido_cliente`) → `cliente.id_cliente` | Cliente associado ao pedido. |
| `id_endereco` | INT | — | Não | FK (`fk_pedido_endereco`) → `endereco.id_endereco` | Endereço de entrega associado ao pedido. |
| `data_pedido` | DATETIME | — | Não | DEFAULT `CURRENT_TIMESTAMP`; índice `idx_pedido_data` | Data e hora do pedido. |
| `status` | ENUM | PENDENTE, PAGO, ENVIADO, ENTREGUE ou CANCELADO | Não | DEFAULT PENDENTE; índice `idx_pedido_status` | Situação atual do pedido. |
| `valor_frete` | DECIMAL | 10,2 | Não | DEFAULT 0,00; CHECK (`ck_pedido_frete`): maior ou igual a 0 | Valor do frete. |

## 6. item_pedido

Relaciona os produtos aos pedidos e registra quantidade e preço da compra.

| Campo | Tipo | Tamanho/valores | Nulo | Chave/regra | Descrição |
|---|---|---:|---|---|---|
| `id_item` | INT | — | Não | PK, AUTO_INCREMENT | Identificador do item do pedido. |
| `id_pedido` | INT | — | Não | FK (`fk_item_pedido`) → `pedido.id_pedido`; UNIQUE com `id_produto` | Pedido ao qual o item pertence. |
| `id_produto` | INT | — | Não | FK (`fk_item_produto`) → `produto.id_produto`; UNIQUE com `id_pedido` | Produto incluído no pedido. O mesmo produto não se repete no mesmo pedido. |
| `quantidade` | INT | — | Não | CHECK (`ck_item_quantidade`): maior que 0 | Quantidade comprada. |
| `preco_unitario` | DECIMAL | 10,2 | Não | CHECK (`ck_item_preco`): maior que 0 | Preço do produto no momento da compra; preserva o valor histórico. |

## 7. forma_pagamento

Lista as formas de pagamento aceitas pela loja.

| Campo | Tipo | Tamanho/valores | Nulo | Chave/regra | Descrição |
|---|---|---:|---|---|---|
| `id_forma_pagamento` | INT | — | Não | PK, AUTO_INCREMENT | Identificador da forma de pagamento. |
| `nome` | VARCHAR | 30 | Não | UNIQUE (`uq_forma_pagamento_nome`) | Nome da forma de pagamento; não pode se repetir. |
| `descricao` | VARCHAR | 100 | Sim | — | Descrição da forma de pagamento. |

## 8. pagamento

Armazena o pagamento associado a um pedido.

| Campo | Tipo | Tamanho/valores | Nulo | Chave/regra | Descrição |
|---|---|---:|---|---|---|
| `id_pagamento` | INT | — | Não | PK, AUTO_INCREMENT | Identificador do pagamento. |
| `id_pedido` | INT | — | Não | FK (`fk_pagamento_pedido`) → `pedido.id_pedido`; UNIQUE (`uq_pagamento_pedido`) | Pedido associado. Cada pedido pode ter no máximo um registro de pagamento. |
| `id_forma_pagamento` | INT | — | Não | FK (`fk_pagamento_forma`) → `forma_pagamento.id_forma_pagamento` | Forma de pagamento escolhida. |
| `valor` | DECIMAL | 10,2 | Não | CHECK (`ck_pagamento_valor`): maior que 0 | Valor registrado para o pagamento. |
| `data_pagamento` | DATETIME | — | Sim | CHECK junto com `status_pagamento` (`ck_pagamento_aprovado_data`) | Data e hora do pagamento; deve ser informada quando o status é APROVADO. |
| `status_pagamento` | ENUM | PENDENTE, APROVADO, RECUSADO ou ESTORNADO | Não | DEFAULT PENDENTE | Situação do pagamento. |

## 9. avaliacao

Armazena as avaliações feitas pelos clientes sobre os produtos.

| Campo | Tipo | Tamanho/valores | Nulo | Chave/regra | Descrição |
|---|---|---:|---|---|---|
| `id_avaliacao` | INT | — | Não | PK, AUTO_INCREMENT | Identificador da avaliação. |
| `id_cliente` | INT | — | Não | FK (`fk_avaliacao_cliente`) → `cliente.id_cliente`; UNIQUE com `id_produto` | Cliente que escreveu a avaliação. |
| `id_produto` | INT | — | Não | FK (`fk_avaliacao_produto`) → `produto.id_produto`; UNIQUE com `id_cliente` | Produto avaliado. Cada cliente pode avaliar um produto uma vez. |
| `nota` | TINYINT | 1 a 5 | Não | CHECK (`ck_avaliacao_nota`) | Nota dada ao produto. |
| `comentario` | VARCHAR | 255 | Sim | — | Comentário opcional sobre o produto. |
| `data_avaliacao` | DATETIME | — | Não | DEFAULT `CURRENT_TIMESTAMP` | Data e hora da avaliação. |

## Relacionamentos

| Relação | Cardinalidade | Significado |
|---|---|---|
| `categoria` → `produto` | 1:N | Uma categoria pode conter vários produtos; cada produto pertence a uma categoria. |
| `cliente` → `endereco` | 1:N | Um cliente pode ter vários endereços; cada endereço pertence a um cliente. |
| `cliente` → `pedido` | 1:N | Um cliente pode fazer vários pedidos; cada pedido está associado a um cliente. |
| `endereco` → `pedido` | 1:N | Um endereço pode ser associado a vários pedidos; cada pedido referencia um endereço. |
| `pedido` → `item_pedido` | 1:N | Um pedido pode conter vários itens; cada item pertence a um pedido. |
| `produto` → `item_pedido` | 1:N | Um produto pode aparecer em vários itens de pedido. |
| `pedido` → `pagamento` | 1:0..1 | Um pedido pode ainda não ter pagamento ou ter um pagamento; cada pagamento pertence a um pedido. |
| `forma_pagamento` → `pagamento` | 1:N | Uma forma de pagamento pode ser usada em vários pagamentos. |
| `cliente` → `avaliacao` | 1:N | Um cliente pode fazer avaliações; cada avaliação pertence a um cliente. |
| `produto` → `avaliacao` | 1:N | Um produto pode receber avaliações; cada avaliação se refere a um produto. |

As tabelas `item_pedido` e `avaliacao` resolvem relações muitos-para-muitos:
pedidos e produtos se relacionam por `item_pedido`; clientes e produtos se
relacionam por `avaliacao`.

## Regras gerais do banco

- As chaves estrangeiras usam `ON DELETE RESTRICT` e `ON UPDATE CASCADE`.
- As tabelas usam o mecanismo InnoDB e o banco utiliza `utf8mb4`.
- As regras `CHECK` dependem do MySQL 8.0.16 ou superior para serem aplicadas.
- `idx_pedido_data` e `idx_pedido_status` são índices usados para apoiar filtros
  por data e por status.
