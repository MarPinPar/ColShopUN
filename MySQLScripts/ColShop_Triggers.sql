-- -----------------------------------------------------------------------
--                  !!! TRIGGERS !!!!
-- -----------------------------------------------------------------------


-- Trigger after before a new action
DROP TRIGGER IF EXISTS tr_before_creacion_accion;
DELIMITER $$
CREATE TRIGGER tr_before_creacion_accion
AFTER INSERT ON ACCION
FOR EACH ROW
BEGIN
	DECLARE ses DATETIME;
    SET ses = fn_getCurrentSession();
    IF SUBSTRING_INDEX(USER(), '@', 1) != 'root' THEN
		INSERT INTO sesion_has_accion VALUES (ses, ses, SUBSTRING_INDEX(USER(), '@', 1), NEW.ac_ID);
	END IF;
END $$
DELIMITER ;

-- Trigger before inserting a new user:
DROP TRIGGER IF EXISTS tr_before_insert_usuario;
DELIMITER $$
CREATE TRIGGER tr_before_insert_usuario
BEFORE INSERT ON USUARIO
FOR EACH ROW
BEGIN
    -- Not duplicated email
    IF EXISTS (SELECT 1 FROM USUARIO WHERE us_correo = NEW.us_correo) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado.';
    END IF;
END $$
DELIMITER ;

-- Trigger only accept possitive values to price
DELIMITER $$
CREATE TRIGGER tr_before_insert_precio
BEFORE INSERT ON PRECIO
FOR EACH ROW
BEGIN
    IF NEW.pre_valor <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El valor del precio debe ser positivo.';
    END IF;
END $$

-- Trigger to update the average of a product;
DELIMITER $$
CREATE TRIGGER update_average_price_trigger
AFTER INSERT ON PRECIO
FOR EACH ROW
BEGIN
	DECLARE new_promedio DOUBLE;
    SET new_promedio = fn_GetProductAveragePrice(NEW.PRODUCTO_pro_ID);
    UPDATE PRODUCTO
    SET pro_precio_promedio = new_promedio
    WHERE pro_ID = NEW.PRODUCTO_pro_ID;
END $$

DELIMITER ;

-- Trigger to allow only users to create review
DELIMITER $$
CREATE TRIGGER tr_before_create_review
BEFORE INSERT ON reseña
FOR EACH ROW
BEGIN
	IF NOT EXISTS(SELECT us_username FROM vista_usuariosregistrados WHERE us_username = SUBSTRING_INDEX(USER(), '@', 1)) AND 
		@flag = 1 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No está autorizado para crear una reseña';
    END IF;
END $$

DELIMITER ;

-- Trigger to allow only creators of a review or the other roles (root not included) to delete review
DROP TRIGGER IF EXISTS tr_before_delete_review;

DELIMITER $$

CREATE TRIGGER tr_before_delete_review
BEFORE DELETE ON reseña
FOR EACH ROW
BEGIN
	IF SUBSTRING_INDEX(USER(), '@', 1) = "root" OR 
		(EXISTS(SELECT us_username FROM vista_usuariosregistrados WHERE us_username = SUBSTRING_INDEX(USER(), '@', 1)) 
			AND NOT EXISTS (SELECT mis_reviews.ACCION_ac_ID FROM mis_reviews WHERE mis_reviews.ACCION_ac_ID = OLD.ACCION_ac_ID))
		THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No está autorizado para eliminar esta reseña';
    END IF;
END $$

DELIMITER ;

-- Trigger to throw error when trying to insert item into a list that doesn´t exist/is not owned by the current user
SELECT LISTA_lis_nombre FROM lista_has_producto;
DROP TRIGGER IF EXISTS tr_before_insert_product_into_list;

DELIMITER $$

CREATE TRIGGER tr_before_insert_product_into_list
BEFORE INSERT ON lista_has_producto
FOR EACH ROW
BEGIN
	IF (NOT EXISTS(SELECT mislistas.Nombre FROM mislistas WHERE mislistas.Nombre = NEW.LISTA_lis_nombre) AND 
		@flag = 1) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No está autorizado para añadir elementos a esta lista o No existe esta lista';
    END IF;
    IF NOT EXISTS(SELECT pro_ID FROM producto WHERE pro_ID = NEW.PRODUCTO_pro_ID) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No existe este producto';
    END IF;
    
END $$

DELIMITER ;

-- Trigger to allow only users to create search
DELIMITER $$

CREATE TRIGGER tr_before_create_search
BEFORE INSERT ON busqueda
FOR EACH ROW
BEGIN
	IF NOT EXISTS(SELECT us_username FROM vista_usuariosregistrados WHERE us_username = SUBSTRING_INDEX(USER(), '@', 1)) AND 
		@flag = 1 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No está autorizado para crear una busqueda';
    END IF;
END $$

DELIMITER ;

-- Trigger to allow list deletion
DROP TRIGGER IF EXISTS tr_before_delete_list;

DELIMITER $$

CREATE TRIGGER tr_before_delete_list
BEFORE DELETE ON lista
FOR EACH ROW
BEGIN
    DELETE FROM lista_has_producto WHERE LISTA_lis_nombre = OLD.lis_nombre AND LISTA_USUARIO_us_username = SUBSTRING_INDEX(USER(), '@', 1);
END $$

DELIMITER ;