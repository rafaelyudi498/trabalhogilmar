USE ecommerce;

-- Mostra os pedidos de agosto e setembro com o total dos itens e do frete.
SELECT p.id_pedido,
       c.nome AS cliente,
       p.data_pedido,
       p.status,
       SUM(ip.quantidade * ip.preco_unitario) + p.valor_frete AS valor_total
FROM pedido p
JOIN cliente     c  ON c.id_cliente = p.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
WHERE p.data_pedido BETWEEN '2026-08-01 00:00:00' AND '2026-09-30 23:59:59'
GROUP BY p.id_pedido, c.nome, p.data_pedido, p.status, p.valor_frete
ORDER BY valor_total DESC;
