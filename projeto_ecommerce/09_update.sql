USE ecommerce;

-- Aprova o pagamento do pedido 7 e atualiza o status do pedido.
UPDATE pagamento
SET status_pagamento = 'APROVADO',
    data_pagamento   = NOW()
WHERE id_pedido = 7;

UPDATE pedido
SET status = 'PAGO'
WHERE id_pedido = 7;

-- Confere as alterações.
SELECT p.id_pedido, p.status, pg.status_pagamento, pg.data_pagamento
FROM pedido p
JOIN pagamento pg ON pg.id_pedido = p.id_pedido
WHERE p.id_pedido = 7;
