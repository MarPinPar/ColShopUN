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
  `pro_ID` INT NOT NULL AUTO_INCREMENT,
  `pro_nombre` VARCHAR(45) NOT NULL,
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
  `PRODUCTO_pro_ID` INT NOT NULL,
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
  `PRODUCTO_pro_ID` INT NOT NULL,
  `TIENDA_tie_ID` INT NOT NULL,
  `pre_fechaHora` DATETIME NOT NULL,
  `pre_valor` INT NOT NULL,
  `pre_URL` VARCHAR(2048) NOT NULL,
  `pre_imagen` LONGBLOB NULL,
  PRIMARY KEY (`PRODUCTO_pro_ID`, `TIENDA_tie_ID`),
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
  `PRODUCTO_pro_ID` INT NOT NULL,
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
  `USUARIO_us_username` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`ses_fechaHoraIn`, `ses_fechaHoraOut`, `USUARIO_us_username`),
  FOREIGN KEY (`USUARIO_us_username`) REFERENCES USUARIO (`us_username`)
  );


-- -----------------------------------------------------
-- Table ACCIONES
-- -----------------------------------------------------
DROP TABLE IF EXISTS ACCIONES ;

CREATE TABLE IF NOT EXISTS ACCIONES (
  `ac_ID` ENUM('BUS','COMP','RES'),
  `ac_fechaHora` DATETIME NOT NULL,
  PRIMARY KEY (`ac_ID`, `ac_fechaHora`)
  );


-- -----------------------------------------------------
-- Table SESION_has_ACCIONES
-- -----------------------------------------------------
DROP TABLE IF EXISTS SESION_has_ACCIONES ;

CREATE TABLE IF NOT EXISTS SESION_has_ACCIONES (
  `SESION_ses_fechaHoraIn` DATETIME NOT NULL,
  `SESION_ses_fechaHoraOut` DATETIME NOT NULL,
  `SESION_USUARIO_us_username` VARCHAR(30) NOT NULL,
  `ACCIONES_ac_ID` ENUM('BUS','COMP','RES'),
  `ACCIONES_ac_fechaHora` DATETIME NOT NULL,
  PRIMARY KEY (`SESION_ses_fechaHoraIn`, `SESION_ses_fechaHoraOut`, `SESION_USUARIO_us_username`, `ACCIONES_ac_ID`, `ACCIONES_ac_fechaHora`),
  FOREIGN KEY (`SESION_ses_fechaHoraIn` , `SESION_ses_fechaHoraOut` , `SESION_USUARIO_us_username`) 
	REFERENCES SESION (`ses_fechaHoraIn` , `ses_fechaHoraOut` , `USUARIO_us_username`),
  FOREIGN KEY (`ACCIONES_ac_ID` , `ACCIONES_ac_fechaHora`)
    REFERENCES ACCIONES (`ac_ID` , `ac_fechaHora`)
    );


-- -----------------------------------------------------
-- Table BUSQUEDA
-- -----------------------------------------------------
DROP TABLE IF EXISTS BUSQUEDA ;

CREATE TABLE IF NOT EXISTS BUSQUEDA (
  `bus_palabrasClave` VARCHAR(50) NOT NULL,
  `ACCIONES_ac_ID` ENUM('BUS','COMP','RES'),
  `ACCIONES_ac_fechaHora` DATETIME NOT NULL,
  PRIMARY KEY (`ACCIONES_ac_ID`, `ACCIONES_ac_fechaHora`),
  FOREIGN KEY (`ACCIONES_ac_ID` , `ACCIONES_ac_fechaHora`) REFERENCES ACCIONES (`ac_ID` , `ac_fechaHora`)
);


-- -----------------------------------------------------
-- Table BUSQUEDA_has_PRODUCTO
-- -----------------------------------------------------
DROP TABLE IF EXISTS BUSQUEDA_has_PRODUCTO ;

CREATE TABLE IF NOT EXISTS BUSQUEDA_has_PRODUCTO (
  `BUSQUEDA_ACCIONES_ac_ID` ENUM('BUS','COMP','RES'),
  `BUSQUEDA_ACCIONES_ac_fechaHora` DATETIME NOT NULL,
  `PRODUCTO_pro_ID` INT NOT NULL,
  PRIMARY KEY (`BUSQUEDA_ACCIONES_ac_ID`, `BUSQUEDA_ACCIONES_ac_fechaHora`, `PRODUCTO_pro_ID`),
  FOREIGN KEY (`BUSQUEDA_ACCIONES_ac_ID` , `BUSQUEDA_ACCIONES_ac_fechaHora`) REFERENCES BUSQUEDA (`ACCIONES_ac_ID` , `ACCIONES_ac_fechaHora`),
  FOREIGN KEY (`PRODUCTO_pro_ID`) REFERENCES PRODUCTO (`pro_ID`)
);


-- -----------------------------------------------------
-- Table COMPARACION
-- -----------------------------------------------------
DROP TABLE IF EXISTS COMPARACION ;

CREATE TABLE IF NOT EXISTS COMPARACION (
  `ACCIONES_ac_ID` ENUM('BUS','COMP','RES'),
  `ACCIONES_ac_fechaHora` DATETIME NOT NULL,
  PRIMARY KEY (`ACCIONES_ac_ID`, `ACCIONES_ac_fechaHora`),
  FOREIGN KEY (`ACCIONES_ac_ID` , `ACCIONES_ac_fechaHora`) REFERENCES ACCIONES (`ac_ID` , `ac_fechaHora`)
);


-- -----------------------------------------------------
-- Table COMPARACION_has_PRODUCTO
-- -----------------------------------------------------
DROP TABLE IF EXISTS COMPARACION_has_PRODUCTO ;

CREATE TABLE IF NOT EXISTS COMPARACION_has_PRODUCTO (
  `COMPARACION_ACCIONES_ac_ID` ENUM('BUS','COMP','RES'),
  `COMPARACION_ACCIONES_ac_fechaHora` DATETIME NOT NULL,
  `PRODUCTO_pro_ID` INT NOT NULL,
  PRIMARY KEY (`COMPARACION_ACCIONES_ac_ID`, `COMPARACION_ACCIONES_ac_fechaHora`, `PRODUCTO_pro_ID`),
  FOREIGN KEY (`COMPARACION_ACCIONES_ac_ID` , `COMPARACION_ACCIONES_ac_fechaHora`) REFERENCES COMPARACION (`ACCIONES_ac_ID` , `ACCIONES_ac_fechaHora`),
  FOREIGN KEY (`PRODUCTO_pro_ID`) REFERENCES PRODUCTO (`pro_ID`)
  );
  

-- -----------------------------------------------------
-- Table RESEÑA
-- -----------------------------------------------------
DROP TABLE IF EXISTS RESEÑA ;

CREATE TABLE IF NOT EXISTS RESEÑA (
  `res_comentario` VARCHAR(120) NULL,
  `res_calificación` TINYINT(5) NOT NULL,
  `ACCIONES_ac_ID` ENUM('BUS','COMP','RES'),
  `ACCIONES_ac_fechaHora` DATETIME NOT NULL,
  `PRODUCTO_pro_ID` INT NOT NULL,
  PRIMARY KEY (`ACCIONES_ac_ID`, `ACCIONES_ac_fechaHora`),
  FOREIGN KEY (`ACCIONES_ac_ID` , `ACCIONES_ac_fechaHora`) REFERENCES ACCIONES (`ac_ID` , `ac_fechaHora`),
  FOREIGN KEY (`PRODUCTO_pro_ID`) REFERENCES PRODUCTO (`pro_ID`)
  );
  
-- add values from Scrapping --

ALTER TABLE PRODUCTO MODIFY COLUMN pro_nombre VARCHAR(100);

INSERT INTO PRODUCTO (pro_nombre, pro_marca) VALUES

('Apple iPhone 14 Pro (128 GB) - Morado oscuro', 'iPhone'),
('Apple iPhone 14 Pro Max (256 GB) - Morado oscuro', 'iPhone'),
('Apple iPhone 14 (512 GB) - Morado', 'iPhone'),
('Apple iPhone 14 Plus (512 GB) - Azul', 'iPhone'),
('Apple iPhone 14 (128 GB) - Medianoche', 'iPhone'),
('Iphone 14 Pro Max 128Gb 5G Negro', 'iPhone'),
('iPhone 14 128 GB Medianoche', 'iPhone'),
('iPhone 14 128 GB Azul', 'iPhone'),
('iPhone 14 Pro Max 128 GB Morado', 'iPhone'),
('Apple Iphone 14 Pro Max 128Gb Space Black (Nuevo)', 'iPhone'),
('iPhone 14 128 GB Azul Medianoche', 'iPhone'),
('iPhone 14 128 GB Morado', 'iPhone'),
('iPhone 14 Pro Max 128 GB Morado Oscuro', 'iPhone'),
('iPhone 14 Pro 128 GB Negro Espacial', 'iPhone'),
('iPhone 14 128 GB Azul', 'iPhone');

SELECT * FROM PRODUCTO;

INSERT INTO TIENDA (tie_nombre, tie_URL) VALUES

('Ktronix', 'https://www.ktronix.com/'),
('Mercadolibre', 'https://www.mercadolibre.com.co/'),
('Éxito', 'https://www.exito.com/');

SELECT * FROM TIENDA;

INSERT INTO PRECIO (PRODUCTO_pro_ID, TIENDA_tie_ID, pre_fechaHora, pre_valor, pre_URL,pre_imagen) VALUES
(1, 2, '2023-10-25 15:46:57.848482', 4960000, 'https://www.mercadolibre.com.co/apple-iphone-14-pro-128-gb-morado-oscuro/p/MCO19615353?pdp_filters=category:MCO1055#searchVariation=MCO19615353&position=1&search_layout=stack&type=product&tracking_id=6ef7b206-05b1-4608-a826-bd0db409f598', 'https://http2.mlstatic.com/D_NQ_NP_726811-MLM51559388195_092022-V.webp'),
(2, 2, '2023-10-25 15:46:57.848482', 5780000, 'https://www.mercadolibre.com.co/apple-iphone-14-pro-max-256-gb-morado-oscuro/p/MCO19615354?pdp_filters=category:MCO1055#searchVariation=MCO19615354&position=2&search_layout=stack&type=product&tracking_id=6ef7b206-05b1-4608-a826-bd0db409f598', 'https://http2.mlstatic.com/D_NQ_NP_726811-MLM51559388195_092022-V.webp'),
(3, 2, '2023-10-25 15:46:57.848482', 4479000, 'https://www.mercadolibre.com.co/apple-iphone-14-512-gb-morado/p/MCO19615374?pdp_filters=category:MCO1055#searchVariation=MCO19615374&position=3&search_layout=stack&type=product&tracking_id=6ef7b206-05b1-4608-a826-bd0db409f598','https://http2.mlstatic.com/D_NQ_NP_726811-MLM51559388195_092022-V.webp'),
(4, 2, '2023-10-25 15:46:57.848482', 4499900, 'https://www.mercadolibre.com.co/apple-iphone-14-plus-512-gb-azul/p/MCO19615368?pdp_filters=category:MCO1055#searchVariation=MCO19615368&position=4&search_layout=stack&type=product&tracking_id=6ef7b206-05b1-4608-a826-bd0db409f598', 'https://http2.mlstatic.com/D_NQ_NP_726811-MLM51559388195_092022-V.webp'),
(5, 2, '2023-10-25 15:46:57.848482', 3490000, 'https://www.mercadolibre.com.co/apple-iphone-14-128-gb-medianoche/p/MCO19615360?pdp_filters=category:MCO1055#searchVariation=MCO19615360&position=5&search_layout=stack&type=product&tracking_id=6ef7b206-05b1-4608-a826-bd0db409f598','https://http2.mlstatic.com/D_NQ_NP_726811-MLM51559388195_092022-V.webp'),
(6, 3, '2023-10-25 15:47:46.173929', 5869600, 'https://tienda.exito.com/iphone-14-pro-max-128gb-5g-negro-102378158-mp/p', 'https://exitocol.vtexassets.com/arquivos/ids/15562745-500-auto?v=638043813455730000&width=500&height=auto&aspect=true'),
(7, 3, '2023-10-25 15:47:46.173929', 4889900, 'https://tienda.exito.com/celular-apple-mpuf3bea-128-gb-medianoche-3103350/p', 'https://exitocol.vtexassets.com/arquivos/ids/19708177-500-auto?v=638304163880600000&width=500&height=auto&aspect=true'),
(8, 3, '2023-10-25 15:47:46.173929', 4889900, 'https://tienda.exito.com/celular-apple-mpvn3bea-128-gb-azul-3103354/p', 'https://exitocol.vtexassets.com/arquivos/ids/19707953-500-auto?v=638304159981700000&width=500&height=auto&aspect=true'),
(9, 3, '2023-10-25 15:47:46.173929', 6859900, 'https://tienda.exito.com/celular-apple-mq9t3bea-128-gb-morado-3103338/p', 'https://exitocol.vtexassets.com/arquivos/ids/19715930-500-auto?v=638306373877570000&width=500&height=auto&aspect=true'),
(10, 3, '2023-10-25 15:47:46.173929', 6099900, 'https://tienda.exito.com/apple-iphone-14-pro-max-128gb-space-black-nuevo-102440347-mp/p', 'https://exitocol.vtexassets.com/arquivos/ids/16304461-500-auto?v=638098326936600000&width=500&height=auto&aspect=true'),
(11, 1, '2023-10-25 15:48:07.566115', 4029000, 'https://www.ktronix.com/iphone14-128gb-azul-medianoche/p/194253488224', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
(12, 1, '2023-10-25 15:48:07.566115', 4029000, 'https://www.ktronix.com/iphone14-128gb-morado/p/194253488248', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
(13, 1, '2023-10-25 15:48:07.566115', 6099000, 'https://www.ktronix.com/iphone-14-pro-max-128gb-morado-oscuro/p/194253486770', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
(14, 1, '2023-10-25 15:48:07.566115', 5579000, 'https://www.ktronix.com/iphone-14-pro-128gb-negro-espacial/p/194253488378', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
(15, 1, '2023-10-25 15:48:07.566115', 4029000, 'https://www.ktronix.com/iphone14-128gb-azul/p/194253488262', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg');

SELECT * FROM PRECIO;