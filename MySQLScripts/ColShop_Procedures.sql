USE ColShop;

-- 1. This procedure retrieves the  lowest price of a product 
DELIMITER $$

CREATE PROCEDURE GetLowestPriceByProductName
(
    IN p_PartialProductName VARCHAR(45)
)
BEGIN
    SELECT TI.tie_nombre, PR.pre_valor
    FROM TIENDA TI
    INNER JOIN PRECIO PR ON TI.tie_ID = PR.TIENDA_tie_ID
    INNER JOIN PRODUCTO P ON PR.PRODUCTO_pro_ID = P.pro_ID
    WHERE P.pro_nombre LIKE CONCAT('%', p_PartialProductName, '%')
    ORDER BY PR.pre_valor ASC
    LIMIT 1;
END $$

DELIMITER ;

--  Call the lowest prices 

CALL GetLowestPriceByProductName('Parlante JBL Go');




-- 2. This procedure retrieves prices for all products that match a given search term in their names
DELIMITER $$

CREATE PROCEDURE GetPricesForProductsBySearch(IN p_SearchTerm VARCHAR(255))
BEGIN
    SELECT TI.tie_nombre, P.pro_nombre, PR.pre_valor, PR.pre_fechaHora
    FROM TIENDA TI
    INNER JOIN PRECIO PR ON TI.tie_ID = PR.TIENDA_tie_ID
    INNER JOIN PRODUCTO P ON PR.PRODUCTO_pro_ID = P.pro_ID
    WHERE P.pro_nombre LIKE CONCAT('%', p_SearchTerm, '%');
END $$

DELIMITER ;

CALL GetPricesForProductsBySearch('iPhone 14');

