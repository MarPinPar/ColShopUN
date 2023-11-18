
-- 1.  Query for an ADMINISTRATOR looking for the count of Registered Users per Month:
CREATE INDEX idx_us_fechaReg ON USUARIO (us_fechaReg);
SELECT DATE_FORMAT(us_fechaReg, '%Y-%m') AS Mes_Registro, COUNT(*) AS Total_Usuarios
FROM 
	USUARIO
GROUP BY 
	Mes_Registro;

-- 2. Query for a BUYER looking for products by name and brand with a price range:(2)
CREATE INDEX idx_producto_busqueda ON PRODUCTO (pro_nombre, pro_marca, pro_ID);
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
  
  
  
  -- 3. Query for a BUYER looking for the lowest price of a product and in which shop is it:
CREATE INDEX idx_precio_producto_tienda ON PRECIO (PRODUCTO_pro_ID, pre_valor, TIENDA_tie_ID);

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
    

    
-- 4. Query for a BUYER looking for the latest update of a product
CREATE INDEX idx_precio_producto_fecha_valor ON PRECIO (PRODUCTO_pro_ID, pre_fechaHora, pre_valor);
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


  