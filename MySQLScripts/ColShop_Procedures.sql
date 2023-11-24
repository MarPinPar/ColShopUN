USE ColShop;

-- 1. This procedure retrieves the lowest price of a product 
DROP PROCEDURE IF EXISTS sp_GetLowestPriceByProductName;
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

-- CALL sp_GetLowestPriceByProductName('Parlante JBL Go');

-- 2. This procedure retrieves prices for all products that match a given search term in their names
DROP PROCEDURE IF EXISTS sp_GetPricesForProductsBySearch;
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

-- CALL sp_GetPricesForProductsBySearch('iPhone 14');

-- 3. This procedure retrieve the price history of a specific product in a particular store
DROP PROCEDURE IF EXISTS sp_GetPriceHistoryForProductInStore;
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

-- CALL sp_GetPriceHistoryForProductInStore('194253488224', 1);

-- 4. CREATE USER
DROP PROCEDURE IF EXISTS sp_create_user;
DELIMITER $$
CREATE PROCEDURE sp_create_user (IN username VARCHAR(45), IN alias VARCHAR(45), IN correo VARCHAR(320), IN pswd VARCHAR(128))
BEGIN
	SET SQL_SAFE_UPDATES = 0;
    INSERT INTO usuario VALUES (username, alias, correo, pswd, NOW());
    SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- CALL sp_create_user("root", "prueba", "prueba@prueba.com", "12345");
-- SELECT * FROM usuario;


-- 5. Modify an user's information
DROP PROCEDURE IF EXISTS sp_modify_user;
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
-- CALL sp_modify_user("prueba1", NULL, NULL);
-- SELECT * FROM usuario;

-- 6. Get the lists from a specified user
DROP PROCEDURE IF EXISTS sp_get_list;
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

-- CALL sp_get_list("sergio_diaz");

-- 7. View List Content
DROP PROCEDURE IF EXISTS sp_view_list;
DELIMITER $$
CREATE PROCEDURE sp_view_list (IN username VARCHAR(45), IN list_name VARCHAR(30))
BEGIN
	SELECT `Nombre Producto` FROM contenidolistas WHERE Autor = username AND Nombre = list_name;
END $$

DELIMITER ;
-- SELECT * FROM contenidolistas;
-- CALL sp_view_list ("carlos_martin", 'Lista de carlos_martin');

-- 8. Insert product into List
DROP PROCEDURE IF EXISTS sp_insert_product_into_list;
DELIMITER $$
CREATE PROCEDURE sp_insert_product_into_list (IN id INT, IN list_name VARCHAR(30))
BEGIN
	DECLARE flag_list_exists VARCHAR(45);
    SELECT Autor INTO flag_list_exists FROM mislistas WHERE Nombre = list_name;
    IF flag_list_exists IS NOT NULL THEN
		SET SQL_SAFE_UPDATES = 0;
        INSERT INTO lista_has_producto VALUES (list_name, flag_list_exists, id);
        SET SQL_SAFE_UPDATES = 1;
    END IF;
    
END $$

DELIMITER ;

-- CALL sp_insert_product_into_list(1, 'Lista de carlos_martin');

-- 9. Delete Item From List
DROP PROCEDURE IF EXISTS sp_delete_product_from_list;
DELIMITER $$
CREATE PROCEDURE sp_delete_product_from_list (IN id INT, IN list_name VARCHAR(30))
BEGIN
	DECLARE flag_list_exists VARCHAR(45);
    SELECT Autor INTO flag_list_exists FROM mislistas WHERE Nombre = list_name;
    IF flag_list_exists IS NOT NULL THEN
		SET SQL_SAFE_UPDATES = 0;
        DELETE FROM lista_has_producto WHERE LISTA_lis_nombre=list_name 
			AND LISTA_USUARIO_us_username = flag_list_exists AND PRODUCTO_pro_ID = id;
        SET SQL_SAFE_UPDATES = 1;
    END IF;
    
END $$

DELIMITER ;

-- 10. Delete List
DROP PROCEDURE IF EXISTS sp_delete_list;
DELIMITER $$
CREATE PROCEDURE sp_delete_list (IN list_name VARCHAR(30))
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM mislistas WHERE Nombre=list_name;
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 11. Create List
DROP PROCEDURE IF EXISTS sp_create_list;
DELIMITER $$
CREATE PROCEDURE sp_create_list (IN list_name VARCHAR(30), IN privada TINYINT(1))
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO mislistas VALUES (list_name, NOW(), privada, NOW(), SUBSTRING_INDEX(USER(), '@', 1));
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 12. Create Category
DROP PROCEDURE IF EXISTS sp_create_category;
DELIMITER $$
CREATE PROCEDURE sp_create_category (IN cat_name VARCHAR(45))
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO categoria (cat_nombre) VALUES (cat_name);
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- CALL sp_create_category("prueba");
-- SELECT * FROM categoria;

-- 13. Delete Category
DROP PROCEDURE IF EXISTS sp_delete_category;
DELIMITER $$
CREATE PROCEDURE sp_delete_category (IN cat_name VARCHAR(45))
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM categoria WHERE cat_nombre = cat_name;
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- CALL sp_delete_category("prueba");
-- SELECT * FROM categoria;

-- 14. Add Category to Item
DROP PROCEDURE IF EXISTS sp_add_product_category;
DELIMITER $$
CREATE PROCEDURE sp_add_product_category (IN cat_id INT, IN pro_id INT)
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO producto_has_categoria VALUES (pro_id, cat_id);
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 15. Delete Category from Item
DROP PROCEDURE IF EXISTS sp_delete_product_category;
DELIMITER $$
CREATE PROCEDURE sp_delete_product_category (IN cat_id INT, IN pro_id INT)
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM producto_has_categoria WHERE PRODUCTO_pro_ID = pro_id AND CATEGORIA_cat_ID = cat_id;
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 16. Create Session
DROP PROCEDURE IF EXISTS sp_create_session;
DELIMITER $$
CREATE PROCEDURE sp_create_session ()
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO sesion VALUES (now(), now(), SUBSTRING_INDEX(USER(), '@', 1));
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 17. Set sesion ending time
DROP PROCEDURE IF EXISTS sp_set_session_end;
DELIMITER $$
CREATE PROCEDURE sp_set_session_end(IN fecha_inicio DATETIME)
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	UPDATE sesion SET ses_fechaHoraOut = now() WHERE ses_fechaHoraIn = fecha_inicio AND ses_fechaHoraOut = fecha_inicio;
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 18. Create Action
DROP PROCEDURE IF EXISTS sp_create_action;
DELIMITER $$
CREATE PROCEDURE sp_create_action()
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO accion (ac_fechaHora) VALUES (now());
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 19. Create busqueda
DROP PROCEDURE IF EXISTS sp_create_busqueda;
DELIMITER $$
CREATE PROCEDURE sp_create_busqueda(IN palabras VARCHAR(50), OUT id_autoinc INT)
BEGIN
    CALL sp_create_action();
    SELECT last_insert_id() INTO id_autoinc;
    
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO busqueda (ACCION_ac_ID, bus_palabrasClave) VALUES (id_autoinc, palabras);
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 20. Create comparacion
DROP PROCEDURE IF EXISTS sp_create_comparacion;
DELIMITER $$
CREATE PROCEDURE sp_create_comparacion(OUT id_autoinc INT)
BEGIN
    CALL sp_create_action();
    SELECT last_insert_id() INTO id_autoinc;
    
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO comparacion (ACCION_ac_ID) VALUES (id_autoinc);
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 21. Fill comparacion
DROP PROCEDURE IF EXISTS sp_fill_comparacion;
DELIMITER $$
CREATE PROCEDURE sp_fill_comparacion(IN ac_id INT, IN pro_id INT)
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO comparacion_has_producto VALUES (ac_id, pro_id);
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 22. Delete item from comparacion
DROP PROCEDURE IF EXISTS sp_delete_from_comparacion;
DELIMITER $$
CREATE PROCEDURE sp_delete_from_comparacion(IN ac_id INT, IN pro_id INT)
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM comparacion_has_producto WHERE COMPARACION_ACCION_ac_ID = ac_id AND PRODUCTO_pro_ID = pro_id;
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 23. Create Reseña
DROP PROCEDURE IF EXISTS sp_create_reseña;
DELIMITER $$
CREATE PROCEDURE sp_create_reseña(IN pro_id INT, IN calificacion TINYINT(5), IN comentario VARCHAR(120), OUT id_autoinc INT)
BEGIN
    CALL sp_create_action();
    SELECT last_insert_id() INTO id_autoinc;
    
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO reseña VALUES (pro_id, id_autoinc, calificacion, comentario);
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;

-- 24. Delete Reseña 
DROP PROCEDURE IF EXISTS sp_delete_reseña;
DELIMITER $$
CREATE PROCEDURE sp_delete_reseña(IN pro_id INT, IN id_autoinc INT)
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM reseña WHERE PRODUCTO_pro_ID = pro_id AND ACCION_ac_ID = id_autoinc;
	SET SQL_SAFE_UPDATES = 1;
END $$

DELIMITER ;