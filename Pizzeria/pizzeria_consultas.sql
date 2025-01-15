SELECT SUM(pv.cantidad) AS total_bebidas_vendidas
FROM producto_vendido pv
JOIN pedido p ON pv.id_pedido = p.id
JOIN producto prod ON pv.id_producto = prod.id
JOIN cliente c ON p.id_cliente = c.id
WHERE prod.categoria = 'bebida' AND c.localidad = 'Barcelona';

SELECT COUNT(*) AS total_bebidas_vendidas
FROM producto_vendido pv
JOIN pedido p ON pv.id_pedido = p.id
JOIN producto prod ON pv.id_producto = prod.id
JOIN cliente c ON p.id_cliente = c.id
WHERE prod.categoria = 'bebida' AND c.localidad = 'Barcelona';

