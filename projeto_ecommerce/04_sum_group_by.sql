USE ecommerce;

-- Soma as unidades e o valor dos itens por categoria, sem pedidos cancelados.
SELECT cat.nome AS categoria,
       SUM(ip.quantidade)                    AS unidades_vendidas,
       SUM(ip.quantidade * ip.preco_unitario) AS faturamento
FROM item_pedido ip
JOIN pedido    p   ON p.id_pedido      = ip.id_pedido
JOIN produto   pr  ON pr.id_produto    = ip.id_produto
JOIN categoria cat ON cat.id_categoria = pr.id_categoria
WHERE p.status <> 'CANCELADO'
GROUP BY cat.nome
ORDER BY faturamento DESC;
