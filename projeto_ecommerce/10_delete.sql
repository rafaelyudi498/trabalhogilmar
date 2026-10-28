USE ecommerce;

-- Remove o pagamento recusado do pedido cancelado 5.
DELETE FROM pagamento
WHERE id_pedido = 5
  AND status_pagamento = 'RECUSADO';

-- Confere os pagamentos.
SELECT * FROM pagamento ORDER BY id_pedido;
