USE ColShop;

-- 1. This procedure retrieves the lowest price of a product 

DELIMITER $$

CREATE PROCEDURE sp_GetLowestPriceByProductName
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
CREATE PROCEDURE sp_GetPricesForProductsBySearch(IN p_SearchTerm VARCHAR(255))
BEGIN
    SELECT TI.tie_nombre, P.pro_nombre, PR.pre_valor, PR.pre_fechaHora
    FROM TIENDA TI
    INNER JOIN PRECIO PR ON TI.tie_ID = PR.TIENDA_tie_ID
    INNER JOIN PRODUCTO P ON PR.PRODUCTO_pro_ID = P.pro_ID
    WHERE P.pro_nombre LIKE CONCAT('%', p_SearchTerm, '%');
END $$

DELIMITER ;

CALL GetPricesForProductsBySearch('iPhone 14');

-- 3. This procedure retrieve the price history of a specific product in a particular store,

DELIMITER $$

CREATE PROCEDURE sp_GetPriceHistoryForProductInStore
(
    IN p_ProductID VARCHAR(45),
    IN p_StoreID INT
)
BEGIN
    SELECT pre_valor, pre_fechaHora
    FROM PRECIO
    WHERE PRODUCTO_pro_ID = p_ProductID AND TIENDA_tie_ID = p_StoreID
    ORDER BY pre_fechaHora DESC;
END $$

DELIMITER ;

CALL GetPriceHistoryForProductInStore('194253488224', 1);

-- 4. CREATE USER
DELIMITER $$
CREATE PROCEDURE sp_create_user (IN username VARCHAR(45), IN alias VARCHAR(45), IN correo VARCHAR(320), IN pswd VARCHAR(128))
BEGIN
	SET SQL_SAFE_UPDATES = 0;
    INSERT INTO usuario VALUES (username, alias, correo, pswd, NOW());
    SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

CALL sp_create_user("root", "prueba", "prueba@prueba.com", "12345");
SELECT * FROM usuario;


-- 5. Modify an user's information
DROP PROCEDURE sp_modify_user;
DELIMITER $$
CREATE PROCEDURE sp_modify_user (IN new_alias VARCHAR(45), IN new_correo VARCHAR(320), IN new_pswd VARCHAR(128))
BEGIN
	DECLARE us VARCHAR(45);
    SET us = SUBSTRING_INDEX(USER(), '@', 1);
    
	SET SQL_SAFE_UPDATES = 0;
    
    IF new_alias IS NOT NULL THEN
		SELECT miperfil.Alias FROM miperfil WHERE `Nombre de Usuario` = 'root';
		UPDATE miperfil SET Alias = new_alias WHERE `Nombre de Usuario` = us;
    END IF;
    IF new_correo IS NOT NULL THEN
		UPDATE miperfil SET Correo = new_correo WHERE `Nombre de Usuario` = us;
    END IF;
    IF new_pswd IS NOT NULL THEN
		UPDATE miperfil SET Contraseña = new_pswd WHERE `Nombre de Usuario` = us;
    END IF;
    
    SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- Can be tested through other users
CALL sp_modify_user("prueba1", NULL, NULL);
SELECT * FROM usuario;

-- 6. Get the lists from a specified user
DROP PROCEDURE sp_get_list;
DELIMITER $$
CREATE PROCEDURE sp_get_list (IN username VARCHAR(45))
BEGIN
	IF username = SUBSTRING_INDEX(USER(), '@', 1) THEN
		SELECT * FROM mislistas;
	ELSE 
		SELECT * FROM listasvisibles WHERE Autor = username;
    END IF;
END $$

DELIMITER ;

CALL sp_get_list("sergio_diaz");

-- 7. View List Content
DROP PROCEDURE sp_view_list;
DELIMITER $$
CREATE PROCEDURE sp_view_list (IN username VARCHAR(45), IN name VARCHAR(30))
BEGIN
	SELECT `Nombre Producto` FROM contenidolistas WHERE Autor = username AND Nombre = name;
END $$

DELIMITER ;
SELECT * FROM contenidolistas;
CALL sp_view_list ("carlos_martin", 'Lista de carlos_martin');

-- 8. Insert product into List