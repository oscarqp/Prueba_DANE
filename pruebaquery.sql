----1.	Visualizar la ciudad y el código postal Colombia

SELECT ciudad, codigopostal 
FROM OFICINAS 
WHERE LOWER(pais) = 'colombia';


---- 2.	Visualizar el apellidos y nombre del jefe de la empresa

SELECT apellido1, apellido2, nombre 
FROM empleados 
WHERE codigojefe IS NULL;



----3.	Visualizar el nombre y cargo de los empleados que no sean directores de oficina.

SELECT nombre, puesto 
FROM empleados 
WHERE LOWER(puesto) <> 'director  de oficina';


----4.	Visualizar la gama de productos(código) más vendidos. Implementar una vista

CREATE OR REPLACE VIEW gamas_vendidas AS
SELECT p.gama, SUM(dp.cantidad) AS cantidad
FROM detallepedidos dp, productos p
WHERE p.codigoproducto = dp.codigoproducto
GROUP BY p.gama;
 
SELECT gv.gama, gv.cantidad
FROM gamas_vendidas gv
WHERE gv.CANTIDAD = (select MAX(gv.cantidad) 
                    FROM gamas_vendidas gv);

----5.	Visualizar el país(cliente) donde menos pedidos se hacen. Implementar una Vista

CREATE OR REPLACE VIEW pedidos_paises AS
SELECT c.pais, count(*) AS num_pedidos
FROM clientes c, pedidos p
WHERE c.codigocliente = p.codigocliente
GROUP BY c.pais;
 
SELECT pp.pais, pp.num_pedidos
FROM PEDIDOS_PAISES pp
WHERE pp.num_pedidos = (SELECT MIN(num_pedidos) 
                			FROM PEDIDOS_PAISES);


----6.	Visualizar los pedidos(código) donde se hayan vendido más de 10 productos

SELECT pe.codigopedido
FROM pedidos pe, detallepedidos dp
WHERE pe.codigopedido = dp.codigopedido
GROUP BY pe.codigopedido
HAVING COUNT(*)>10;

----7.	Visualizar los pedidos(código) donde el precio del pedido sea superior a la media de todos los pedidos.

SELECT pe.codigopedido
FROM pedidos pe
WHERE
(SELECT SUM(dp.cantidad * dp.PRECIOUNIDAD) AS total
      FROM pedidos p, detallepedidos dp
      WHERE p.codigopedido = dp.codigopedido and pe.codigopedido = p.codigopedido
      GROUP BY p.codigopedido)
>
(SELECT AVG(totalp.total)
FROM (SELECT p.codigopedido, SUM(dp.cantidad * dp.PRECIOUNIDAD) AS total
      FROM pedidos p, detallepedidos dp
      WHERE p.codigopedido = dp.codigopedido
      GROUP BY p.codigopedido) totalp);

----8.	Visualizar la cantidad de veces y el código; que se ha pedido un producto al menos una vez.

SELECT  SUM(dp.cantidad) AS "cantidad", p.codigoproducto
FROM productos p, detallepedidos dp 
WHERE p.codigoproducto = dp.codigoproducto 
GROUP BY p.codigoproducto;

----9.	Visualizar el producto(código) más vendido de la gama “Aromáticas”.

SELECT DISTINCT dp.codigoproducto
FROM pedidos pe, detallepedidos dp
WHERE pe.codigopedido = dp.codigopedido
AND dp.codigoproducto IN (SELECT codigoproducto
                          FROM productos 
                          WHERE precioventa = (SELECT max(precioventa)
                                              FROM productos p, gamasproductos g
                                              WHERE p.gama = g.gama
                                              AND LOWER(g.gama) = 'Aromáticas'))

----10.	Visualizar los pedidos(código) donde el precio del pedido sea superior a la media de todos los pedidos

SELECT pe.codigopedido
FROM pedidos pe
WHERE
(SELECT SUM(dp.cantidad * dp.PRECIOUNIDAD) AS total
      FROM pedidos p, detallepedidos dp
      WHERE p.codigopedido = dp.codigopedido and pe.codigopedido = p.codigopedido
      GROUP BY p.codigopedido)
>
(SELECT AVG(totalp.total)
FROM (SELECT p.codigopedido, SUM(dp.cantidad * dp.PRECIOUNIDAD) AS total
      FROM pedidos p, detallepedidos dp
      WHERE p.codigopedido = dp.codigopedido
      GROUP BY p.codigopedido) totalp);

