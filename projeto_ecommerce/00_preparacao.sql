-- Cria o banco, as tabelas e os dados de exemplo.
-- Este script apaga e recria o banco ecommerce.

DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce;

-- Cria as nove tabelas e define suas chaves e regras.

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(60)  NOT NULL,
    descricao    VARCHAR(200) NULL,
    CONSTRAINT uq_categoria_nome UNIQUE (nome)
) ENGINE=InnoDB;

CREATE TABLE cliente (
    id_cliente    INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    email         VARCHAR(120) NOT NULL,
    cpf           CHAR(11)     NOT NULL,
    telefone      VARCHAR(20)  NULL,
    data_cadastro DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo         TINYINT(1)   NOT NULL DEFAULT 1,
    CONSTRAINT uq_cliente_email UNIQUE (email),
    CONSTRAINT uq_cliente_cpf   UNIQUE (cpf),
    CONSTRAINT ck_cliente_email CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT ck_cliente_cpf   CHECK (cpf REGEXP '^[0-9]{11}$'),
    CONSTRAINT ck_cliente_ativo CHECK (ativo IN (0, 1))
) ENGINE=InnoDB;

CREATE TABLE endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente  INT          NOT NULL,
    logradouro  VARCHAR(120) NOT NULL,
    numero      VARCHAR(10)  NOT NULL,
    bairro      VARCHAR(60)  NOT NULL,
    cidade      VARCHAR(60)  NOT NULL,
    uf          CHAR(2)      NOT NULL,
    cep         CHAR(8)      NOT NULL,
    principal   TINYINT(1)   NOT NULL DEFAULT 1,
    CONSTRAINT ck_endereco_cep       CHECK (cep REGEXP '^[0-9]{8}$'),
    CONSTRAINT ck_endereco_principal CHECK (principal IN (0, 1)),
    CONSTRAINT fk_endereco_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE produto (
    id_produto   INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT           NOT NULL,
    nome         VARCHAR(100)  NOT NULL,
    descricao    VARCHAR(255)  NULL,
    preco        DECIMAL(10,2) NOT NULL,
    estoque      INT           NOT NULL DEFAULT 0,
    ativo        TINYINT(1)    NOT NULL DEFAULT 1,
    CONSTRAINT ck_produto_preco   CHECK (preco > 0),
    CONSTRAINT ck_produto_estoque CHECK (estoque >= 0),
    CONSTRAINT ck_produto_ativo   CHECK (ativo IN (0, 1)),
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pedido (
    id_pedido   INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente  INT           NOT NULL,
    id_endereco INT           NOT NULL,
    data_pedido DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status      ENUM('PENDENTE','PAGO','ENVIADO','ENTREGUE','CANCELADO') NOT NULL DEFAULT 'PENDENTE',
    valor_frete DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT ck_pedido_frete CHECK (valor_frete >= 0),
    INDEX idx_pedido_data   (data_pedido),
    INDEX idx_pedido_status (status),
    CONSTRAINT fk_pedido_cliente  FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)   ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_endereco FOREIGN KEY (id_endereco)
        REFERENCES endereco (id_endereco) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE item_pedido (
    id_item        INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido      INT           NOT NULL,
    id_produto     INT           NOT NULL,
    quantidade     INT           NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT uq_item            UNIQUE (id_pedido, id_produto),
    CONSTRAINT ck_item_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_item_preco      CHECK (preco_unitario > 0),
    CONSTRAINT fk_item_pedido  FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)   ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_item_produto FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE forma_pagamento (
    id_forma_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    nome               VARCHAR(30)  NOT NULL,
    descricao          VARCHAR(100) NULL,
    CONSTRAINT uq_forma_pagamento_nome UNIQUE (nome)
) ENGINE=InnoDB;

CREATE TABLE pagamento (
    id_pagamento       INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido          INT           NOT NULL,
    id_forma_pagamento INT           NOT NULL,
    valor              DECIMAL(10,2) NOT NULL,
    data_pagamento     DATETIME      NULL,
    status_pagamento   ENUM('PENDENTE','APROVADO','RECUSADO','ESTORNADO') NOT NULL DEFAULT 'PENDENTE',
    CONSTRAINT uq_pagamento_pedido UNIQUE (id_pedido),
    CONSTRAINT ck_pagamento_valor  CHECK (valor > 0),
    CONSTRAINT ck_pagamento_aprovado_data
        CHECK (status_pagamento <> 'APROVADO' OR data_pagamento IS NOT NULL),
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pagamento_forma  FOREIGN KEY (id_forma_pagamento)
        REFERENCES forma_pagamento (id_forma_pagamento) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE avaliacao (
    id_avaliacao   INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente     INT          NOT NULL,
    id_produto     INT          NOT NULL,
    nota           TINYINT      NOT NULL,
    comentario     VARCHAR(255) NULL,
    data_avaliacao DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_avaliacao      UNIQUE (id_cliente, id_produto),
    CONSTRAINT ck_avaliacao_nota CHECK (nota BETWEEN 1 AND 5),
    CONSTRAINT fk_avaliacao_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_avaliacao_produto FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Insere os dados de exemplo.

INSERT INTO categoria (nome, descricao) VALUES
('Eletrônicos',      'Celulares, notebooks e acessórios'),
('Moda',             'Roupas e calçados'),
('Casa e Cozinha',   'Eletrodomésticos e utilidades'),
('Livros',           'Livros técnicos e didáticos'),
('Esporte e Lazer',  'Artigos esportivos');

INSERT INTO cliente (nome, email, cpf, telefone, data_cadastro) VALUES
('Ana Souza',      'ana.souza@email.com',      '11111111111', '(11) 91111-1111', '2026-07-01 10:00:00'),
('Bruno Lima',     'bruno.lima@email.com',     '22222222222', '(11) 92222-2222', '2026-07-05 14:30:00'),
('Carla Mendes',   'carla.mendes@email.com',   '33333333333', '(11) 93333-3333', '2026-07-10 09:15:00'),
('Diego Alves',    'diego.alves@email.com',    '44444444444', '(11) 94444-4444', '2026-07-20 16:45:00'),
('Eduarda Rocha',  'eduarda.rocha@email.com',  '55555555555', '(11) 95555-5555', '2026-08-02 11:20:00'),
('Felipe Costa',   'felipe.costa@email.com',   '66666666666', '(11) 96666-6666', '2026-08-15 08:00:00'),
('Gabriela Nunes', 'gabriela.nunes@email.com', '77777777777', '(11) 97777-7777', '2026-09-01 13:10:00'),
('Henrique Dias',  'henrique.dias@email.com',  '88888888888', '(11) 98888-8888', '2026-09-10 17:30:00');

INSERT INTO endereco (id_cliente, logradouro, numero, bairro, cidade, uf, cep, principal) VALUES
(1, 'Rua das Flores',        '100', 'Centro',        'Mogi das Cruzes', 'SP', '08710000', 1),
(2, 'Av. Paulista',          '1500','Bela Vista',    'São Paulo',       'SP', '01310100', 1),
(3, 'Rua Sete de Setembro',  '45',  'Centro',        'Suzano',          'SP', '08674000', 1),
(4, 'Rua XV de Novembro',    '230', 'Centro',        'Curitiba',        'PR', '80020310', 1),
(5, 'Av. Atlântica',         '800', 'Copacabana',    'Rio de Janeiro',  'RJ', '22010000', 1),
(6, 'Rua da Bahia',          '321', 'Savassi',       'Belo Horizonte',  'MG', '30160011', 1),
(7, 'Rua das Palmeiras',     '55',  'Jardim Aeroporto','Mogi das Cruzes','SP', '08780000', 1),
(8, 'Rua do Comércio',       '12',  'Centro',        'Campinas',        'SP', '13010000', 1);

INSERT INTO produto (id_categoria, nome, descricao, preco, estoque) VALUES
(1, 'Smartphone X10',        'Tela 6.5", 128GB',               1899.90, 25),
(1, 'Notebook Pro 15',       'Intel i7, 16GB RAM, SSD 512GB',  4599.00, 10),
(1, 'Fone Bluetooth',        'Cancelamento de ruído',           249.90, 60),
(2, 'Camiseta Básica',       '100% algodão',                     59.90, 120),
(2, 'Tênis de Corrida',      'Amortecimento leve',              329.90, 40),
(2, 'Jaqueta Jeans',         'Unissex',                         219.90, 30),
(3, 'Liquidificador 800W',   '3 velocidades, jarra de vidro',   189.90, 35),
(3, 'Cafeteira Elétrica',    '30 xícaras',                      159.90, 20),
(4, 'Livro SQL na Prática',  'Introdução a banco de dados',      89.90, 50),
(4, 'Livro Modelagem de Dados','DER e normalização',            109.90, 45),
(5, 'Bola de Futebol',       'Tamanho oficial',                  99.90, 70),
(5, 'Kit Halteres 10kg',     'Par de halteres emborrachados',   179.90, 15);

INSERT INTO pedido (id_cliente, id_endereco, data_pedido, status, valor_frete) VALUES
(1, 1, '2026-08-03 10:15:00', 'ENTREGUE',  20.00),
(2, 2, '2026-08-10 15:40:00', 'ENTREGUE',  15.00),
(3, 3, '2026-08-15 09:05:00', 'ENVIADO',   25.00),
(1, 1, '2026-09-02 19:20:00', 'PAGO',      20.00),
(4, 4, '2026-09-05 12:00:00', 'CANCELADO', 18.00),
(5, 5, '2026-09-12 21:30:00', 'ENTREGUE',  12.00),
(6, 6, '2026-09-20 08:45:00', 'PENDENTE',  30.00),
(2, 2, '2026-09-28 14:10:00', 'ENTREGUE',  15.00),
(7, 7, '2026-10-01 11:55:00', 'PAGO',      22.00),
(3, 3, '2026-10-05 16:25:00', 'ENTREGUE',  25.00);

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1899.90), (1, 3, 1, 249.90),
(2, 4, 3,   59.90), (2, 5, 1, 329.90),
(3, 2, 1, 4599.00),
(4, 9, 2,   89.90), (4, 10, 1, 109.90),
(5, 7, 1,  189.90),
(6, 11, 2,  99.90), (6, 12, 1, 179.90),
(7, 8, 1,  159.90), (7, 6, 1, 219.90),
(8, 3, 2,  249.90), (8, 4, 2,  59.90),
(9, 5, 1,  329.90), (9, 11, 1, 99.90),
(10, 10, 1, 109.90), (10, 9, 1, 89.90), (10, 7, 2, 189.90);

INSERT INTO forma_pagamento (nome, descricao) VALUES
('Cartão de Crédito', 'Pagamento com cartão de crédito, à vista ou parcelado'),
('PIX',               'Transferência instantânea'),
('Boleto',            'Boleto bancário com compensação em até 3 dias úteis');

INSERT INTO pagamento (id_pedido, id_forma_pagamento, valor, data_pagamento, status_pagamento) VALUES
( 1, 1,  2169.80, '2026-08-03 10:20:00', 'APROVADO'),
( 2, 2,   524.60, '2026-08-10 15:42:00', 'APROVADO'),
( 3, 1,  4624.00, '2026-08-15 09:10:00', 'APROVADO'),
( 4, 2,   309.70, '2026-09-02 19:22:00', 'APROVADO'),
( 5, 1,   207.90, NULL,                 'RECUSADO'),
( 6, 2,   391.70, '2026-09-12 21:32:00', 'APROVADO'),
( 7, 3,   409.80, NULL,                 'PENDENTE'),
( 8, 1,   634.60, '2026-09-28 14:12:00', 'APROVADO'),
( 9, 2,   451.80, '2026-10-01 11:57:00', 'APROVADO'),
(10, 3,   604.60, '2026-10-06 10:00:00', 'APROVADO');

INSERT INTO avaliacao (id_cliente, id_produto, nota, comentario, data_avaliacao) VALUES
(1, 1,  5, 'Excelente celular, chegou rápido',      '2026-08-10 10:00:00'),
(1, 3,  4, 'Bom som, bateria poderia durar mais',   '2026-08-10 10:05:00'),
(2, 5,  5, 'Muito confortável para correr',         '2026-08-18 18:00:00'),
(2, 3,  5, 'Cancelamento de ruído muito bom',       '2026-10-03 09:30:00'),
(3, 2,  4, 'Ótimo desempenho',                      '2026-08-25 20:00:00'),
(3, 10, 5, 'Conteúdo claro e didático',             '2026-10-10 19:00:00'),
(5, 11, 3, 'Bola boa, mas veio murcha',             '2026-09-20 17:00:00'),
(5, 12, 4, 'Custo-benefício bom',                   '2026-09-20 17:10:00');
