SELECT SUM(pv.cantidad) AS total_bebidas_vendidas
FROM producto_vendido pv
JOIN pedido p ON pv.id_pedido = p.id
JOIN producto prod ON pv.id_producto = prod.id
JOIN cliente c ON p.id_cliente = c.id
WHERE prod.categoria = 'Begudes' AND c.localidad = 'NomDeLaTevaLocalitat';

Llista quantes comandes ha efectuat un determinat empleat/da.