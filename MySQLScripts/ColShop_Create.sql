-- -----------------------------------------------------
-- Schema ColShop
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS ColShop ;
CREATE SCHEMA IF NOT EXISTS ColShop DEFAULT CHARACTER SET utf8 ;
USE ColShop  ;


-- -----------------------------------------------------
-- Table USUARIO
-- -----------------------------------------------------
DROP TABLE IF EXISTS USUARIO ;

CREATE TABLE IF NOT EXISTS USUARIO (
  `us_username` VARCHAR(45) NOT NULL,
  `us_alias` VARCHAR(45) NOT NULL,
  `us_correo` VARCHAR(320) NOT NULL,
  `us_contraseña` VARCHAR(128) NOT NULL,
  `us_fechaReg` DATETIME NOT NULL,
  PRIMARY KEY (`us_username`)
  );
  
  
-- -----------------------------------------------------
-- PRODUCTO
-- -----------------------------------------------------
DROP TABLE IF EXISTS PRODUCTO ;

CREATE TABLE IF NOT EXISTS PRODUCTO (
  `pro_ID` VARCHAR(45) NOT NULL,
  `pro_nombre` VARCHAR(300) NOT NULL,
  `pro_marca` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`pro_ID`)
  );
  
  
  
-- -----------------------------------------------------
-- Table LISTA
-- -----------------------------------------------------
DROP TABLE IF EXISTS LISTA ;

CREATE TABLE IF NOT EXISTS LISTA (
  `lis_nombre` VARCHAR(30) NOT NULL DEFAULT 'Lista de Deseos',
  `lis_fechaCreacion` DATETIME NOT NULL,
  `lis_esPublica` TINYINT(1) NOT NULL DEFAULT 0,
  `lis_fechaUltAct` DATETIME NOT NULL,
  `USUARIO_us_username` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`lis_nombre`, `USUARIO_us_username`),
  FOREIGN KEY (`USUARIO_us_username`) REFERENCES USUARIO (`us_username`)
  );


-- -----------------------------------------------------
-- Table LISTA_has_PRODUCTO
-- -----------------------------------------------------
DROP TABLE IF EXISTS LISTA_has_PRODUCTO ;

CREATE TABLE IF NOT EXISTS LISTA_has_PRODUCTO (
  `LISTA_lis_nombre` VARCHAR(30) NOT NULL,
  `LISTA_USUARIO_us_username` VARCHAR(30) NOT NULL,
  `PRODUCTO_pro_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`LISTA_lis_nombre`, `LISTA_USUARIO_us_username`, `PRODUCTO_pro_ID`),
  FOREIGN KEY (`LISTA_lis_nombre` , `LISTA_USUARIO_us_username`) REFERENCES LISTA (`lis_nombre` , `USUARIO_us_username`),
  FOREIGN KEY (`PRODUCTO_pro_ID`) REFERENCES PRODUCTO (`pro_ID`)
  );


-- -----------------------------------------------------
-- Table TIENDA
-- -----------------------------------------------------
DROP TABLE IF EXISTS TIENDA ;

CREATE TABLE IF NOT EXISTS TIENDA (
  `tie_ID` INT NOT NULL AUTO_INCREMENT,
  `tie_nombre` VARCHAR(45) NOT NULL,
  `tie_URL` VARCHAR(2048) NOT NULL,
  PRIMARY KEY (`tie_ID`));
  
  
-- -----------------------------------------------------
-- Table PRECIO
-- -----------------------------------------------------
DROP TABLE IF EXISTS PRECIO ;

CREATE TABLE IF NOT EXISTS PRECIO (
  `PRODUCTO_pro_ID` VARCHAR(45) NOT NULL,
  `TIENDA_tie_ID` INT NOT NULL,
  `pre_fechaHora` DATETIME NOT NULL,
  `pre_valor` INT NOT NULL,
  `pre_URL` VARCHAR(2048) NOT NULL,
  `pre_imagen` LONGBLOB NULL,
  PRIMARY KEY (`PRODUCTO_pro_ID`, `TIENDA_tie_ID`, `pre_fechaHora`),
  FOREIGN KEY (`PRODUCTO_pro_ID`) REFERENCES PRODUCTO (`pro_ID`),
  FOREIGN KEY (`TIENDA_tie_ID`) REFERENCES TIENDA (`tie_ID`)
  );
  
  
-- -----------------------------------------------------
-- Table CATEGORIA
-- -----------------------------------------------------
DROP TABLE IF EXISTS CATEGORIA ;

CREATE TABLE IF NOT EXISTS CATEGORIA (
  `cat_ID` INT NOT NULL AUTO_INCREMENT,
  `cat_nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cat_ID`));
  
  
-- -----------------------------------------------------
-- Table PRODUCTO_has_CATEGORIA
-- -----------------------------------------------------
DROP TABLE IF EXISTS PRODUCTO_has_CATEGORIA ;

CREATE TABLE IF NOT EXISTS PRODUCTO_has_CATEGORIA (
  `PRODUCTO_pro_ID` VARCHAR(45) NOT NULL,
  `CATEGORIA_cat_ID` INT NOT NULL,
  PRIMARY KEY (`PRODUCTO_pro_ID`, `CATEGORIA_cat_ID`),
  FOREIGN KEY (`PRODUCTO_pro_ID`) REFERENCES PRODUCTO (`pro_ID`),
  FOREIGN KEY (`CATEGORIA_cat_ID`) REFERENCES CATEGORIA (`cat_ID`)
  );


-- -----------------------------------------------------
-- Table SESION
-- -----------------------------------------------------
DROP TABLE IF EXISTS SESION ;

CREATE TABLE IF NOT EXISTS SESION (
  `ses_fechaHoraIn` DATETIME NOT NULL,
  `ses_fechaHoraOut` DATETIME NOT NULL,
  `USUARIO_us_username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ses_fechaHoraIn`, `ses_fechaHoraOut`, `USUARIO_us_username`),
  FOREIGN KEY (`USUARIO_us_username`) REFERENCES USUARIO (`us_username`)
  );


-- -----------------------------------------------------
-- Table ACCION
-- -----------------------------------------------------
DROP TABLE IF EXISTS ACCION ;

CREATE TABLE IF NOT EXISTS ACCION (
  `ac_ID` INT AUTO_INCREMENT,
  `ac_fechaHora` DATETIME NOT NULL,
  PRIMARY KEY (`ac_ID`)
  );


-- -----------------------------------------------------
-- Table SESION_has_ACCION
-- -----------------------------------------------------
DROP TABLE IF EXISTS SESION_has_ACCION ;

CREATE TABLE IF NOT EXISTS SESION_has_ACCION (
  `SESION_ses_fechaHoraIn` DATETIME NOT NULL,
  `SESION_ses_fechaHoraOut` DATETIME NOT NULL,
  `SESION_USUARIO_us_username` VARCHAR(30) NOT NULL,
  `ACCION_ac_ID` INT,
  PRIMARY KEY (`SESION_ses_fechaHoraIn`, `SESION_ses_fechaHoraOut`, `SESION_USUARIO_us_username`, `ACCION_ac_ID`),
  FOREIGN KEY (`SESION_ses_fechaHoraIn` , `SESION_ses_fechaHoraOut` , `SESION_USUARIO_us_username`) 
	REFERENCES SESION (`ses_fechaHoraIn` , `ses_fechaHoraOut` , `USUARIO_us_username`),
  FOREIGN KEY (`ACCION_ac_ID`)
    REFERENCES ACCION (`ac_ID`)
    );


-- -----------------------------------------------------
-- Table BUSQUEDA
-- -----------------------------------------------------
DROP TABLE IF EXISTS BUSQUEDA ;

CREATE TABLE IF NOT EXISTS BUSQUEDA (
  `ACCION_ac_ID` INT,
  `bus_palabrasClave` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`ACCION_ac_ID`),
  FOREIGN KEY (`ACCION_ac_ID`) REFERENCES ACCION (`ac_ID`)
);


-- -----------------------------------------------------
-- Table BUSQUEDA_has_PRODUCTO
-- -----------------------------------------------------
DROP TABLE IF EXISTS BUSQUEDA_has_PRODUCTO ;

CREATE TABLE IF NOT EXISTS BUSQUEDA_has_PRODUCTO (
  `BUSQUEDA_ACCION_ac_ID` INT,
  `PRODUCTO_pro_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`BUSQUEDA_ACCION_ac_ID`, `PRODUCTO_pro_ID`),
  FOREIGN KEY (`BUSQUEDA_ACCION_ac_ID`) REFERENCES BUSQUEDA (`ACCION_ac_ID`),
  FOREIGN KEY (`PRODUCTO_pro_ID`) REFERENCES PRODUCTO (`pro_ID`)
);


-- -----------------------------------------------------
-- Table COMPARACION
-- -----------------------------------------------------
DROP TABLE IF EXISTS COMPARACION ;

CREATE TABLE IF NOT EXISTS COMPARACION (
  `ACCION_ac_ID` INT,
  PRIMARY KEY (`ACCION_ac_ID`),
  FOREIGN KEY (`ACCION_ac_ID`) REFERENCES ACCION (`ac_ID`)
);


-- -----------------------------------------------------
-- Table COMPARACION_has_PRODUCTO
-- -----------------------------------------------------
DROP TABLE IF EXISTS COMPARACION_has_PRODUCTO ;

CREATE TABLE IF NOT EXISTS COMPARACION_has_PRODUCTO (
  `COMPARACION_ACCION_ac_ID` INT,
  `PRODUCTO_pro_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`COMPARACION_ACCION_ac_ID`, `PRODUCTO_pro_ID`),
  FOREIGN KEY (`COMPARACION_ACCION_ac_ID`) REFERENCES COMPARACION (`ACCION_ac_ID`),
  FOREIGN KEY (`PRODUCTO_pro_ID`) REFERENCES PRODUCTO (`pro_ID`)
  );
  

-- -----------------------------------------------------
-- Table RESEÑA
-- -----------------------------------------------------
DROP TABLE IF EXISTS RESEÑA ;

CREATE TABLE IF NOT EXISTS RESEÑA (
  `PRODUCTO_pro_ID` VARCHAR(45) NOT NULL,
  `ACCION_ac_ID` INT,
  `res_calificacion` TINYINT(6) NOT NULL,
  `res_comentario` VARCHAR(120) NULL,
  PRIMARY KEY (`ACCION_ac_ID`),
  FOREIGN KEY (`ACCION_ac_ID`) REFERENCES ACCION (`ac_ID`),
  FOREIGN KEY (`PRODUCTO_pro_ID`) REFERENCES PRODUCTO (`pro_ID`)
  );