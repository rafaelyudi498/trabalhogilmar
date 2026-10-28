USE ecommerce;

-- Conta os pedidos por status.
SELECT status,
       COUNT(*) AS total_pedidos
FROM pedido
GROUP BY status
ORDER BY total_pedidos DESC;
