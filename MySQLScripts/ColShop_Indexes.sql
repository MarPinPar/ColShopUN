-- 1. Index on user's alias
CREATE INDEX idx_us_alias ON USUARIO (us_alias);
-- Query for user alias Octavio
SELECT SQL_NO_CACHE * FROM USUARIO
WHERE us_alias = 'Octavio';

-- 2.  Index on an user's sign-up date
CREATE INDEX idx_us_fechaReg ON USUARIO (us_fechaReg);
-- Query for an ADMINISTRATOR looking for the count of Registered Users per Month:
SELECT DATE_FORMAT(us_fechaReg, '%Y-%m') AS Mes_Registro, COUNT(*) AS Total_Usuarios
FROM 
	USUARIO
GROUP BY 
	Mes_Registro;
  
  -- 3. Index on a product's id and price
CREATE INDEX idx_precio_producto_tienda ON PRECIO (PRODUCTO_pro_ID, pre_valor);
-- Query for a BUYER looking for the lowest price of a product and in which shop is it:
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
    
-- 4. Index on a product's id, date and price prioritizing the date
CREATE INDEX idx_precio_producto_fecha_valor ON PRECIO (PRODUCTO_pro_ID, pre_fechaHora, pre_valor);
-- Query for a BUYER looking for the latest update of a product
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

-- 5 Index on a product's name
CREATE INDEX idx_producto_nombre ON PRODUCTO (pro_nombre);
-- Query for products that dont have Iphone in their names
SELECT * FROM PRODUCTO
	WHERE pro_nombre NOT LIKE '%Iphone%';

-- 6. Index on a each product's review scores
CREATE INDEX idx_reseña_calificacion ON RESEÑA (PRODUCTO_pro_ID, res_calificacion);
-- Query for reviews with a score lower than 3 for a specific product

 
SET profiling = 0;