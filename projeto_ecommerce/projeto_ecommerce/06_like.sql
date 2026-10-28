USE ecommerce;

-- Busca produtos com "Livro" ou "Fone" no nome.
SELECT id_produto, nome, preco, estoque
FROM produto
WHERE nome LIKE '%Livro%'
   OR nome LIKE 'Fone%'
ORDER BY nome;
