USE ColShop;

select  * from usuario;
select * from producto ;
select  * from precio;
select * from reseña;

-- View an specifc product:
-- Procedure to get product price information by ID
DROP PROCEDURE IF EXISTS GetProductInfo;

DELIMITER //

CREATE PROCEDURE GetProductInfo(IN productID VARCHAR(45))
BEGIN
  SELECT
    P.pro_ID,
    P.pro_nombre,
    P.pro_marca,
    PR.TIENDA_tie_ID,
    PR.pre_fechaHora,
    PR.pre_valor,
    PR.pre_URL,
    PR.pre_imagen
  FROM
    PRODUCTO P
  LEFT JOIN
    PRECIO PR ON P.pro_ID = PR.PRODUCTO_pro_ID
  WHERE
    P.pro_ID = productID;
END //

DELIMITER ;

-- CALL GetProductInfo('8806094837995');


-- Insert data into precio:
DROP PROCEDURE IF EXISTS sp_InsertDataIntoPrecio;
DELIMITER //
CREATE PROCEDURE sp_InsertDataIntoPrecio(
    IN pro_id_param VARCHAR(45),
    IN tie_id_param INT,
    IN pre_fechaHora_param DATETIME,
    IN pre_valor_param INT,
    IN pre_url_param VARCHAR(2048),
    IN pre_imagen_param LONGBLOB
)
BEGIN
START TRANSACTION;
    INSERT INTO PRECIO (PRODUCTO_pro_ID, TIENDA_tie_ID, pre_fechaHora, pre_valor, pre_URL, pre_imagen)
    VALUES (pro_id_param, tie_id_param, pre_fechaHora_param, pre_valor_param, pre_url_param, pre_imagen_param);
COMMIT;
END //
DELIMITER ;

-- Insert data into producto:
DROP PROCEDURE IF EXISTS sp_InsertDataIntoProducto;
DELIMITER //

CREATE PROCEDURE sp_InsertDataIntoProducto(
    IN pro_id_param VARCHAR(45),
    IN pro_nombre_param VARCHAR(300),
    IN pro_marca_param VARCHAR(45)
)
BEGIN
START TRANSACTION;
    INSERT INTO PRODUCTO (pro_ID, pro_nombre, pro_marca)
    VALUES (pro_id_param, pro_nombre_param, pro_marca_param);
COMMIT;
END //

DELIMITER ;

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

CALL sp_GetLowestPriceByProductName('Parlante JBL Go');

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

CALL sp_GetPricesForProductsBySearch('iPhone 14');

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

CALL sp_GetPriceHistoryForProductInStore('MCO1361345027', 2);

-- 4. CREATE USER
DROP PROCEDURE IF EXISTS sp_create_user;
DELIMITER $$
CREATE PROCEDURE sp_create_user (IN username VARCHAR(45), IN alias VARCHAR(45), IN correo VARCHAR(320), IN pswd VARCHAR(128))
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
    INSERT INTO usuario VALUES (username, alias, correo, pswd, NOW());
    SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- CALL sp_create_user("root", "prueba", "prueba@prueba.com", "12345");
-- SELECT * FROM usuario;


-- 5. Modify an user's information
DROP PROCEDURE IF EXISTS sp_modify_user;
DELIMITER $$
CREATE PROCEDURE sp_modify_user (IN new_alias VARCHAR(45), IN new_correo VARCHAR(320), IN new_pswd VARCHAR(128), IN hashed_pswd VARCHAR(300))
BEGIN
	DECLARE us VARCHAR(45);
    START TRANSACTION;
    SET us = SUBSTRING_INDEX(USER(), '@', 1);
    
	SET SQL_SAFE_UPDATES = 0;
    
    IF new_alias IS NOT NULL THEN
		UPDATE miperfil SET Alias = new_alias WHERE `Nombre de Usuario` = us;
    END IF;
    IF new_correo IS NOT NULL THEN
		UPDATE miperfil SET Correo = new_correo WHERE `Nombre de Usuario` = us;
    END IF;
    IF new_pswd IS NOT NULL THEN
		UPDATE miperfil SET Contraseña = new_pswd WHERE `Nombre de Usuario` = us;
    END IF;
    
    SET SQL_SAFE_UPDATES = 1;
    COMMIT;
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
	SELECT ID, `Nombre Producto` FROM contenidolistas WHERE Autor = username AND Nombre = list_name;
END $$

DELIMITER ;
-- SELECT * FROM contenidolistas;
-- CALL sp_view_list ("carlos_martin", 'Lista de carlos_martin');

-- 8. Insert product into List
DROP PROCEDURE IF EXISTS sp_insert_product_into_list;
DELIMITER $$
CREATE PROCEDURE sp_insert_product_into_list (IN id VARCHAR(45), IN list_name VARCHAR(30))
BEGIN
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        INSERT INTO lista_has_producto VALUES (list_name, SUBSTRING_INDEX(USER(), '@', 1), id);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;
END $$

DELIMITER ;

-- CALL sp_insert_product_into_list(1, 'Lista de carlos_martin');

-- 9. Delete Item From List
DROP PROCEDURE IF EXISTS sp_delete_product_from_list;
DELIMITER $$
CREATE PROCEDURE sp_delete_product_from_list (IN id VARCHAR(45), IN list_name VARCHAR(30))
BEGIN
	DECLARE flag_list_exists VARCHAR(45);
    SELECT Autor INTO flag_list_exists FROM mislistas WHERE Nombre = list_name;
    IF flag_list_exists IS NOT NULL THEN
    START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        DELETE FROM lista_has_producto WHERE LISTA_lis_nombre=list_name 
			AND LISTA_USUARIO_us_username = flag_list_exists AND PRODUCTO_pro_ID = id;
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    ELSE
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No está autorizado para eliminar elementos a esta lista o No existe esta lista';
    END IF;
END $$

DELIMITER ;

-- 10. Delete List
DROP PROCEDURE IF EXISTS sp_delete_list;
DELIMITER $$
CREATE PROCEDURE sp_delete_list (IN list_name VARCHAR(30))
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM mislistas WHERE Nombre=list_name;
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 11. Create List
DROP PROCEDURE IF EXISTS sp_create_list;
DELIMITER $$
CREATE PROCEDURE sp_create_list (IN list_name VARCHAR(30), IN privada TINYINT(1))
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO mislistas VALUES (list_name, NOW(), privada, NOW(), SUBSTRING_INDEX(USER(), '@', 1));
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 12. Create Category
DROP PROCEDURE IF EXISTS sp_create_category;
DELIMITER $$
CREATE PROCEDURE sp_create_category (IN cat_name VARCHAR(45))
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO categoria (cat_nombre) VALUES (cat_name);
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- CALL sp_create_category("prueba");
-- SELECT * FROM categoria;

-- 13. Delete Category
DROP PROCEDURE IF EXISTS sp_delete_category;
DELIMITER $$
CREATE PROCEDURE sp_delete_category (IN cat_name VARCHAR(45))
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM categoria WHERE cat_nombre = cat_name;
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- CALL sp_delete_category("prueba");
-- SELECT * FROM categoria;

-- 14. Add Category to Item
DROP PROCEDURE IF EXISTS sp_add_product_category;
DELIMITER $$
CREATE PROCEDURE sp_add_product_category (IN cat_id INT, IN pro_id INT)
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO producto_has_categoria VALUES (pro_id, cat_id);
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 15. Delete Category from Item
DROP PROCEDURE IF EXISTS sp_delete_product_category;
DELIMITER $$
CREATE PROCEDURE sp_delete_product_category (IN cat_id INT, IN pro_id INT)
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM producto_has_categoria WHERE PRODUCTO_pro_ID = pro_id AND CATEGORIA_cat_ID = cat_id;
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 16. Create Session
DROP PROCEDURE IF EXISTS sp_create_session;
DELIMITER $$
CREATE PROCEDURE sp_create_session (OUT current_session DATETIME)
BEGIN
	SET current_session = now();
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO sesion VALUES (current_session, current_session, SUBSTRING_INDEX(USER(), '@', 1));
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 17. Set sesion ending time
DROP PROCEDURE IF EXISTS sp_set_session_end;
DELIMITER $$
CREATE PROCEDURE sp_set_session_end(IN fecha_inicio DATETIME)
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	UPDATE sesion SET ses_fechaHoraOut = now() WHERE ses_fechaHoraIn = fecha_inicio AND ses_fechaHoraOut = fecha_inicio;
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
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
START TRANSACTION;
    CALL sp_create_action();
    SELECT last_insert_id() INTO id_autoinc;
    
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO busqueda (ACCION_ac_ID, bus_palabrasClave) VALUES (id_autoinc, palabras);
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 20. Create comparacion
DROP PROCEDURE IF EXISTS sp_create_comparacion;
DELIMITER $$
CREATE PROCEDURE sp_create_comparacion(OUT id_autoinc INT)
BEGIN
START TRANSACTION;
    CALL sp_create_action();
    SELECT last_insert_id() INTO id_autoinc;
    
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO comparacion (ACCION_ac_ID) VALUES (id_autoinc);
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 21. Fill comparacion
DROP PROCEDURE IF EXISTS sp_fill_comparacion;
DELIMITER $$
CREATE PROCEDURE sp_fill_comparacion(IN ac_id INT, IN pro_id INT)
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO comparacion_has_producto VALUES (ac_id, pro_id);
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 22. Delete item from comparacion
DROP PROCEDURE IF EXISTS sp_delete_from_comparacion;
DELIMITER $$
CREATE PROCEDURE sp_delete_from_comparacion(IN ac_id INT, IN pro_id INT)
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM comparacion_has_producto WHERE COMPARACION_ACCION_ac_ID = ac_id AND PRODUCTO_pro_ID = pro_id;
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 23. Create Reseña
DROP PROCEDURE IF EXISTS sp_create_reseña;
DELIMITER $$
CREATE PROCEDURE sp_create_reseña(IN pro_id VARCHAR(45), IN calificacion TINYINT(5), IN comentario VARCHAR(120), OUT id_autoinc INT)
BEGIN
START TRANSACTION;
    CALL sp_create_action();
    SELECT last_insert_id() INTO id_autoinc;
    
	SET SQL_SAFE_UPDATES = 0;
	INSERT INTO reseña VALUES (pro_id, id_autoinc, calificacion, comentario);
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 24. Delete Reseña 
DROP PROCEDURE IF EXISTS sp_delete_reseña;
DELIMITER $$
CREATE PROCEDURE sp_delete_reseña(IN pro_id VARCHAR(45), IN id_autoinc INT)
BEGIN
START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM reseña WHERE PRODUCTO_pro_ID = pro_id AND ACCION_ac_ID = id_autoinc;
	SET SQL_SAFE_UPDATES = 1;
COMMIT;
END $$

DELIMITER ;

-- 25. This procedure retrieves the most recent price of a product in each store
DROP PROCEDURE IF EXISTS sp_getMostRecentPriceByProductName;
DELIMITER $$

CREATE PROCEDURE sp_getMostRecentPriceByProductName
(
    IN p_PartialProductName VARCHAR(45)
)
BEGIN
    SELECT P.pro_nombre, TI.tie_nombre, PR.pre_valor, PR.pre_fechaHora
    FROM TIENDA TI
    INNER JOIN PRECIO PR ON TI.tie_ID = PR.TIENDA_tie_ID
    INNER JOIN (
			SELECT PRODUCTO_pro_ID, MAX(pre_fechaHora) as fh, TIENDA_tie_ID FROM PRECIO GROUP BY PRODUCTO_pro_ID, TIENDA_tie_ID)
            AS maxP ON maxP.PRODUCTO_pro_ID = PR.PRODUCTO_pro_ID
    INNER JOIN PRODUCTO P ON maxP.PRODUCTO_pro_ID = P.pro_ID
    WHERE P.pro_nombre LIKE CONCAT('%', p_PartialProductName, '%')
		AND maxP.fh = PR.pre_fechaHora;
END $$

DELIMITER ;

--  Call the most recent prices 
-- INSERT INTO PRECIO (PRODUCTO_pro_ID, TIENDA_tie_ID, pre_fechaHora, pre_valor, pre_URL, pre_imagen)
-- VALUES
-- ('MCO1991235718', 2, '2023-11-28 20:41:02.364496', 2, 'https://www.mercadolibre.com.co/apple-iphone-14-pro-max-256-gb-morado-oscuro/p/MCO19615354?pdp_filters=category:MCO1055#searchVariation=MCO19615354&position=1&search_layout=stack&type=product&tracking_id=d7425eed-0e49-4618-9917-21be614a5b12', 'placeholder_image_url1');

-- CALL sp_getMostRecentPriceByProductName('Iphone');

-- Create DataBase User

DROP PROCEDURE IF EXISTS sp_createDBuser;
DELIMITER $$
CREATE PROCEDURE sp_createDBuser (IN nombre VARCHAR(45), IN cta VARCHAR(128))
BEGIN
START TRANSACTION;
    SET @command = CONCAT("CREATE USER '",nombre, "'@'localhost' IDENTIFIED BY '", cta,"'");
    PREPARE stmt FROM @command;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @command = CONCAT("GRANT 'usuario'@'localhost' TO '",nombre, "'@'localhost'");
    PREPARE stmt FROM @command;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @command = CONCAT("SET DEFAULT ROLE ALL TO '",nombre, "'@'localhost'");
    PREPARE stmt FROM @command;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
COMMIT;
END $$

DELIMITER ;

-- Procedure to get the average on specific product
DROP FUNCTION IF EXISTS fn_GetProductAveragePrice;

DELIMITER $$
CREATE FUNCTION fn_GetProductAveragePrice(p_ProductID VARCHAR(45)) RETURNS DECIMAL(10, 2) DETERMINISTIC
BEGIN
    DECLARE averagePrice DECIMAL(10, 2);

    SELECT AVG(pre_valor) INTO averagePrice
    FROM PRECIO
    WHERE PRODUCTO_pro_ID = p_ProductID;

    RETURN averagePrice;
END $$
DELIMITER ;
SELECT fn_GetProductAveragePrice('097855137708') AS 'Promedio de Precios';

-- Get Current Sesion
DROP FUNCTION IF EXISTS fn_getCurrentSession;
DELIMITER $$
CREATE FUNCTION fn_getCurrentSession() RETURNS DATETIME DETERMINISTIC
BEGIN
	DECLARE current_session DATETIME;
    SELECT MAX(ses_fechaHoraIn) INTO current_session FROM sesion WHERE USUARIO_us_username = SUBSTRING_INDEX(USER(), '@', 1);
	RETURN current_session;
END $$
DELIMITER ;

-- Get MisListas
DROP PROCEDURE IF EXISTS sp_get_mis_listas;
DELIMITER $$
CREATE PROCEDURE sp_get_mis_listas()
BEGIN
	CALL sp_get_list(SUBSTRING_INDEX(USER(), '@', 1));
END $$
DELIMITER ;

-- Get comentarios from producto

DROP PROCEDURE IF EXISTS sp_get_review_by_product;

DELIMITER //
CREATE PROCEDURE sp_get_review_by_product(IN producto_pro_id VARCHAR(255))
BEGIN
    SELECT res_calificacion, res_comentario
    FROM reseña
    WHERE PRODUCTO_pro_ID = producto_pro_id;
END //
DELIMITER ;

-- CALL sp_get_review_by_product('MCO1319575303');
