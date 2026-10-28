USE ecommerce;

-- Mostra os produtos com nota média igual ou maior que 4.
SELECT pr.nome                  AS produto,
       COUNT(a.id_avaliacao)    AS qtd_avaliacoes,
       ROUND(AVG(a.nota), 2)    AS nota_media
FROM avaliacao a
JOIN produto pr ON pr.id_produto = a.id_produto
GROUP BY pr.id_produto, pr.nome
HAVING AVG(a.nota) >= 4
ORDER BY nota_media DESC, qtd_avaliacoes DESC;
