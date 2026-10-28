USE ecommerce;

-- Cria um resumo mensal das vendas por categoria.
CREATE OR REPLACE VIEW vw_dashboard_vendas AS
SELECT DATE_FORMAT(p.data_pedido, '%Y-%m')                AS ano_mes,
       cat.nome                                           AS categoria,
       COUNT(DISTINCT p.id_pedido)                        AS qtd_pedidos,
       COUNT(DISTINCT p.id_cliente)                       AS qtd_clientes,
       SUM(ip.quantidade)                                 AS unidades_vendidas,
       SUM(ip.quantidade * ip.preco_unitario)             AS faturamento,
       ROUND(SUM(ip.quantidade * ip.preco_unitario)
             / COUNT(DISTINCT p.id_pedido), 2)            AS ticket_medio
FROM pedido p
JOIN item_pedido ip ON ip.id_pedido     = p.id_pedido
JOIN produto     pr ON pr.id_produto    = ip.id_produto
JOIN categoria   cat ON cat.id_categoria = pr.id_categoria
WHERE p.status <> 'CANCELADO'
GROUP BY DATE_FORMAT(p.data_pedido, '%Y-%m'), cat.nome;

-- Mostra os dados do resumo.
SELECT * FROM vw_dashboard_vendas
ORDER BY ano_mes, faturamento DESC;
