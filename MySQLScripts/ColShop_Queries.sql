
-- Consulta para un ADMINISTRADOR que busca el recuento de Usuarios Registrados por Mes:
SELECT DATE_FORMAT(us_fechaReg, '%Y-%m') AS Mes_Registro, COUNT(*) AS Total_Usuarios
FROM 
	USUARIO
GROUP BY 
	Mes_Registro;

-- Consulta para un COMPRADOR que busca productos por nombre y marca con un rango de precios:
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
-- Consulta para un COMPRADOR que busca el precio más bajo de un producto y en que tienda esta

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




