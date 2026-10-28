USE ecommerce;

-- Mostra os pedidos com os dados do cliente e do pagamento.
SELECT p.id_pedido,
       c.nome            AS cliente,
       p.data_pedido,
       p.status          AS status_pedido,
       fp.nome           AS forma_pagamento,
       pg.valor          AS valor_pago
FROM pedido p
JOIN cliente         c  ON c.id_cliente = p.id_cliente
JOIN pagamento       pg ON pg.id_pedido = p.id_pedido
JOIN forma_pagamento fp ON fp.id_forma_pagamento = pg.id_forma_pagamento
ORDER BY p.data_pedido;
