USE ecommerce;

-- Mostra os produtos de cada pedido, com cliente e categoria.
SELECT p.id_pedido,
       c.nome       AS cliente,
       pr.nome      AS produto,
       cat.nome     AS categoria,
       ip.quantidade,
       ip.preco_unitario,
       (ip.quantidade * ip.preco_unitario) AS subtotal
FROM item_pedido ip
JOIN pedido    p   ON p.id_pedido     = ip.id_pedido
JOIN cliente   c   ON c.id_cliente    = p.id_cliente
JOIN produto   pr  ON pr.id_produto   = ip.id_produto
JOIN categoria cat ON cat.id_categoria = pr.id_categoria
ORDER BY p.id_pedido, pr.nome;
