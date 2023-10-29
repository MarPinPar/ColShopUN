-- -----------------------------------------------------------------------
--                  !!! CONSULTAS !!!!
-- -----------------------------------------------------------------------

-- 1. Consulta para un ADMINISTRADOR que busca el recuento de Usuarios Registrados por Mes:
SELECT DATE_FORMAT(us_fechaReg, '%Y-%m') AS Mes_Registro, COUNT(*) AS Total_Usuarios
FROM 
	USUARIO
GROUP BY 
	Mes_Registro;


-- 2. Consulta para un COMPRADOR que busca productos por nombre y marca con un rango de precios:
SELECT 
	pro_nombre, pro_marca
FROM 
	PRODUCTO
WHERE 
	pro_nombre LIKE '%Apple iPhone 14%' 
  AND 
	pro_marca = 'Iphone'
  AND 
	pro_ID IN (
		SELECT 
			PRODUCTO_pro_ID
		FROM 
			PRECIO
		WHERE 
			pre_valor >= 4000000
      AND 
		pre_valor <= 6000000
  );
  

-- 3. Consulta para un COMPRADOR que busca el precio más bajo de un producto y en que tienda esta
SELECT
    MIN(pre_valor) AS Precio_Más_Bajo,
    tie_nombre AS Tienda
FROM
    PRODUCTO 
INNER JOIN
    PRECIO ON pro_ID = PRODUCTO_pro_ID
INNER JOIN
    TIENDA  ON TIENDA_tie_ID = tie_ID
WHERE
    pro_nombre LIKE '%Parlante JBL Go%'
GROUP BY
	tie_nombre
ORDER BY
    Precio_Más_Bajo;


-- 4. Consulta para un COMPRADOR que busca la última actualizaciòn de algún producto
SELECT 
	pro_nombre AS Producto, pre_fechaHora AS Ultima_Actualizacion, pre_valor AS Precio
FROM 
	PRODUCTO 
INNER JOIN 
	PRECIO ON pro_ID = PRODUCTO_pro_ID
WHERE 
	pro_ID = 'MCO1940674356'
ORDER BY 
	pre_fechaHora DESC
LIMIT 
	1;


-- 5. Consulta para un ADMINISTRADOR que quiere ver las estadísticas de precios por tienda
SELECT tie_nombre, MAX(pre_valor), MIN(pre_valor), AVG(pre_valor)
FROM TIENDA JOIN PRECIO ON tie_ID = TIENDA_tie_ID
GROUP BY tie_ID;


-- 6. Consulta para un USUARIO que quiere ver las listas que tienen al menos un producto que contengan "Iphone"
SELECT * FROM contenidolistas WHERE Nombre in
(SELECT Nombre FROM (SELECT Nombre, COUNT(`Nombre Producto`) c
FROM contenidolistas
WHERE LOWER(`Nombre Producto`) LIKE '%iphone%'
GROUP BY Nombre
HAVING c > 1) AS t);


-- 7. Consulta de un USUARIO que quiere ver el comentario mas antiguo de cada producto
SELECT * FROM comentariosProducto WHERE Fecha IN 
(SELECT MIN(FECHA) FROM comentariosProducto GROUP BY Nombre);


-- 8. Consulta de un USUARIO que quiere ver la calificacion promedio por producto
SELECT Nombre, AVG(Calificacion) AS 'Puntaje Promedio' FROM comentariosProducto GROUP BY Nombre;

-- 9. Consulta de todos los productos con la misma marca que un producto determinado
SELECT * FROM PRODUCTO
WHERE pro_marca = (SELECT pro_marca FROM PRODUCTO WHERE pro_ID = 'id_deseado');

-- 10. Seleccionar las reseñas de un producto que tengan una calificación mayor a 3
SELECT
    p.pro_nombre AS 'Nombre del Producto',
    r.res_calificacion AS 'Calificacion',
    r.res_comentario AS 'Comentario'
FROM reseña r
JOIN
    producto p ON r.PRODUCTO_pro_ID = p.pro_ID
JOIN
    accion a ON r.ACCION_ac_ID = a.ac_ID
JOIN
    sesion_has_accion s ON a.ac_ID = s.ACCION_ac_ID
WHERE
    r.res_calificacion > 3 AND p.pro_ID = 'Product_ID';

-- 11. Consulta todas las reseñas de un producto determinado
SELECT * FROM comentariosProducto
WHERE Nombre = 'NOMBRE_PRODUCTO';

-- 12. Consulta los productos que cuentan con una imagen
SELECT DISTINCT p.* FROM PRODUCTO p
JOIN PRECIO pr ON p.pro_ID = pr.PRODUCTO_pro_ID
WHERE pr.pre_imagen IS NOT NULL