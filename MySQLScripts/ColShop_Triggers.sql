-- Trigger after creating a new review



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

-- Trigger to upload "alias" that only contain numbers and letters
DELIMITER $$
CREATE TRIGGER tr_before_update_alias_usuario
BEFORE UPDATE ON USUARIO
FOR EACH ROW
BEGIN
    IF NEW.us_alias REGEXP '[^a-zA-Z0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El alias debe contener solo letras y números.';
    END IF;
END $$
DELIMITER ;


-- Trigger only accept possitive values to price
DELIMITER $$
CREATE TRIGGER tr_before_insert_precio
BEFORE INSERT ON PRECIO
FOR EACH ROW
BEGIN
    -- Asegurarse de que el valor del precio sea positivo
    IF NEW.pre_valor <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El valor del precio debe ser positivo.';
    END IF;
END $$


