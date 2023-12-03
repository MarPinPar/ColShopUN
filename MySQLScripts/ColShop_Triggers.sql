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
	IF NOT EXISTS(SELECT us_username FROM vista_usuariosregistrados WHERE us_username = SUBSTRING_INDEX(USER(), '@', 1)) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No está autorizado para crear una reseña';
    END IF;
END $$

DELIMITER ;


