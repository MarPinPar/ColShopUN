
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
