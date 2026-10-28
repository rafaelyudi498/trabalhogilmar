USE ecommerce;

-- Mostra os clientes que ainda não fizeram pedidos.
SELECT c.id_cliente, c.nome, c.email, c.data_cadastro
FROM cliente c
LEFT JOIN pedido p ON p.id_cliente = c.id_cliente
WHERE p.id_pedido IS NULL;
