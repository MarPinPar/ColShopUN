-- -----------------------------------------------------
--              LLENADO DE TABLAS
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Llenado de USUARIO
-- -----------------------------------------------------
INSERT INTO USUARIO (us_username, us_alias, us_correo, us_contraseña, us_fechaReg) VALUES
('juan_perez', 'Juan', 'juan.perez@gmail.com', 'Cl4v3#123', '2023-10-26 12:00:00'),
('maria_gomez', 'María', 'maria.gomez@hotmail.com', 'S3cr3t0&456', '2023-10-26 13:00:00'),
('roberto_jimenez', 'Roberto', 'roberto.jimenez@outlook.com', 'S3gur0!789', '2023-10-27 14:00:00'),
('susana_rodriguez', 'Susana', 'susana.rodriguez@testmail.com', 'Pr1vad0@abc', '2023-10-27 15:00:00'),
('david_lopez', 'David', 'david.lopez@gmail.com', 'S3cr3t0xyz#', '2023-10-28 16:00:00'),
('laura_sanchez', 'Laura', 'laura.sanchez@hotmail.com', 'C0nf1d3nc1al#123', '2023-10-28 17:00:00'),
('carlos_martin', 'Carlos', 'carlos.martin@outlook.com', 'Clav3&456', '2023-10-29 18:00:00'),
('isabel_hernandez', 'Isabel', 'isabel.hernandez@testmail.com', 'S3gur0&789', '2023-10-29 19:00:00'),
('jose_luis', 'José', 'jose.luis@gmail.com', 'S3cr3t0@abc', '2023-10-30 20:00:00'),
('ana_garcia', 'Ana', 'ana.garcia@hotmail.com', 'Pr1vad0xyz#', '2023-10-30 21:00:00'),
('pedro_ruiz', 'Pedro', 'pedro.ruiz@gmail.com', 'S3cr3t0123#', '2023-10-26 12:30:00'),
('teresa_martinez', 'Teresa', 'teresa.martinez@hotmail.com', 'C0nf1d3nc1al&456', '2023-10-26 13:30:00'),
('raul_gonzalez', 'Raúl', 'raul.gonzalez@outlook.com', 'Clav3!456', '2023-10-27 14:30:00'),
('luis_fernandez', 'Luis', 'luis.fernandez@gmail.com', 'S3cr3t0@456', '2023-10-27 15:30:00'),
('carmen_lopez', 'Carmen', 'carmen.lopez@hotmail.com', 'Pr1vad0&123', '2023-10-28 16:30:00'),
('javier_molina', 'Javier', 'javier.molina@outlook.com', 'Clav3123#', '2023-10-28 17:30:00'),
('patricia_santos', 'Patricia', 'patricia.santos@testmail.com', 'S3gur0@abc', '2023-10-29 18:30:00'),
('manuel_ramirez', 'Manuel', 'manuel.ramirez@gmail.com', 'S3cr3t0xyz&', '2023-10-29 19:30:00'),
('rosa_gutierrez', 'Rosa', 'rosa.gutierrez@hotmail.com', 'C0nf1d3nc1al123#', '2023-10-30 20:30:00'),
('sergio_diaz', 'Sergio', 'sergio.diaz@outlook.com', 'S3gur0123!', '2023-10-30 21:30:00');
('luis_gomez', 'Luis', 'luis@example.com', 'luispass123', '2023-10-25 15:50:00'),
('ana_perez', 'Ana', 'ana@example.com', 'anapass', '2023-10-25 15:51:00'),
('carlos_rodriguez', 'Carlos', 'carlos@example.com', 'mipassword', '2023-10-25 15:52:00'),
('maria_lopez', 'Maria', 'maria@example.com', 'mariapass123', '2023-10-25 15:53:00'),
('juan_hernandez', 'Juan', 'juan@example.com', 'juanpass', '2023-10-25 15:54:00');

SELECT * FROM USUARIO;


-- -----------------------------------------------------
-- Llenado de PRODUCTO
-- -----------------------------------------------------
-- Modificar la columna pro_nombre a VARCHAR(100)
ALTER TABLE PRODUCTO MODIFY COLUMN pro_nombre VARCHAR(300);
ALTER TABLE PRODUCTO AUTO_INCREMENT = 1;

-- Insertar nuevos productos
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
('iPhone 14 128 GB Azul', 'iPhone'),
('Portátil gamer Asus TUF Gaming F15 FX506HC eclipse gray 15.6 Intel Core i5', 'Asus'),
('Portatil Gamer Asus Tuf Gaming A15 Fa507xv-bs93 Mecha Gray 15.6, Amd Ryzen 9 7940hs, 16gb De Ram, 512gb Ssd, Nvidia Geforce Rtx 4060 8gb, 144hz 1920x1080px Windows 11 Home', 'Asus'),
('Computador Portátil Asus Gamer Fx516pc Corei7 16gb Ssd 1tb', 'Asus'),
('Computador ASUS Vivobook 16 Intel Core i5 1135G7 RAM 8 GB 1 TB SSD X1605EAMB186W', 'Asus'),
('Computador ASUS Intel Core i3 1115G4 RAM 12 GB 512 GB SSD X515EABR3779W', 'Asus'),	
('Computador ASUS Vivobook Go 15 AMD Ryzen 5 7520U RAM 8 GB 512 GB SSD E1504FANJ475W', 'Asus'),
('Computador Portátil Gamer ASUS TUF 15,6" Pulgadas FX506 - Intel Core i5 - RAM 8GB - Disco SSD 512 GB - Negro', 'LG'),
('Computador Portátil Gamer ASUS TUF A15 15.6" Pulgadas FA507NU - AMD Ryzen 7 - RAM 16GB - Disco SSD 512 GB - Gris', 'LG'),
('Computador Portátil Gamer ASUS TUF Dash 15.6" Pulgadas FX517ZM - Intel Core i7 - RAM 16GB - Disco SSD 512 GB - Negro', 'LG');

SELECT * FROM PRODUCTO;


-- -----------------------------------------------------
-- Llenado de LISTA
-- -----------------------------------------------------
INSERT INTO LISTA (lis_nombre, lis_fechaCreacion, lis_fechaUltAct, USUARIO_us_username) VALUES
('Lista de juan_perez', '2023-10-26 12:00:00', '2023-10-31 14:00:00', 'juan_perez'),
('Lista de maria_gomez', '2023-10-26 13:00:00', '2023-10-31 15:00:00', 'maria_gomez'),
('Lista de roberto_jimenez', '2023-10-27 14:00:00', '2023-10-31 16:00:00', 'roberto_jimenez'),
('Lista de susana_rodriguez', '2023-10-27 15:00:00', '2023-10-31 17:00:00', 'susana_rodriguez'),
('Lista de david_lopez', '2023-10-28 16:00:00', '2023-10-31 18:00:00', 'david_lopez'),
('Lista de laura_sanchez', '2023-10-28 17:00:00', '2023-10-31 19:00:00', 'laura_sanchez'),
('Lista de carlos_martin', '2023-10-29 18:00:00', '2023-10-31 20:00:00', 'carlos_martin'),
('Lista de isabel_hernandez', '2023-10-29 19:00:00', '2023-10-31 21:00:00', 'isabel_hernandez'),
('Lista de jose_luis', '2023-10-30 20:00:00', '2023-10-31 22:00:00', 'jose_luis'),
('Lista de ana_garcia', '2023-10-30 21:00:00', '2023-10-31 23:00:00', 'ana_garcia'),
('Lista de pedro_ruiz', '2023-10-26 12:30:00', '2023-10-31 14:30:00', 'pedro_ruiz'),
('Lista de teresa_martinez', '2023-10-26 13:30:00', '2023-10-31 15:30:00', 'teresa_martinez'),
('Lista de raul_gonzalez', '2023-10-27 14:30:00', '2023-10-31 16:30:00', 'raul_gonzalez'),
('Lista de luis_fernandez', '2023-10-27 15:30:00', '2023-10-31 17:30:00', 'luis_fernandez'),
('Lista de carmen_lopez', '2023-10-28 16:30:00', '2023-10-31 18:30:00', 'carmen_lopez'),
('Lista de javier_molina', '2023-10-28 17:30:00', '2023-10-31 19:30:00', 'javier_molina'),
('Lista de patricia_santos', '2023-10-29 18:30:00', '2023-10-31 20:30:00', 'patricia_santos'),
('Lista de manuel_ramirez', '2023-10-29 19:30:00', '2023-10-31 21:30:00', 'manuel_ramirez'),
('Lista de rosa_gutierrez', '2023-10-30 20:30:00', '2023-10-31 22:30:00', 'rosa_gutierrez'),
('Lista de sergio_diaz', '2023-10-30 21:30:00', '2023-10-31 23:30:00', 'sergio_diaz'),
('Lista de luis_gomez', '2023-10-25 15:50:00', '2023-10-31 14:00:00', 'luis_gomez'),
('Lista de ana_perez', '2023-10-25 15:51:00', '2023-10-31 15:00:00', 'ana_perez'),
('Lista de carlos_rodriguez', '2023-10-25 15:52:00', '2023-10-31 16:00:00', 'carlos_rodriguez'),
('Lista de maria_lopez', '2023-10-25 15:53:00', '2023-10-31 17:00:00', 'maria_lopez'),
('Lista de juan_hernandez', '2023-10-25 15:54:00', '2023-10-31 18:00:00', 'juan_hernandez');

SELECT * FROM LISTA;


-- -----------------------------------------------------
-- Llenado de LISTA_has_PRODUCTO
-- -----------------------------------------------------
INSERT INTO LISTA_has_PRODUCTO (LISTA_lis_nombre, LISTA_USUARIO_us_username, PRODUCTO_pro_ID) VALUES
('Lista de juan_perez', 'juan_perez', 17),
('Lista de maria_gomez', 'maria_gomez', 2),
('Lista de maria_gomez', 'maria_gomez', 3),
('Lista de roberto_jimenez', 'roberto_jimenez', 4),
('Lista de roberto_jimenez', 'roberto_jimenez', 5),
('Lista de roberto_jimenez', 'roberto_jimenez', 6),
('Lista de susana_rodriguez', 'susana_rodriguez', 7),
('Lista de david_lopez', 'david_lopez', 18),
('Lista de laura_sanchez', 'laura_sanchez', 1),
('Lista de laura_sanchez', 'laura_sanchez', 24),
('Lista de carlos_martin', 'carlos_martin', 12),
('Lista de carlos_martin', 'carlos_martin', 3),
('Lista de carlos_martin', 'carlos_martin', 21),
('Lista de isabel_hernandez', 'isabel_hernandez', 15),
('Lista de jose_luis', 'jose_luis', 19),
('Lista de ana_garcia', 'ana_garcia', 16),
('Lista de pedro_ruiz', 'pedro_ruiz', 17),
('Lista de teresa_martinez', 'teresa_martinez', 4),
('Lista de teresa_martinez', 'teresa_martinez', 17),
('Lista de teresa_martinez', 'teresa_martinez', 11),
('Lista de raul_gonzalez', 'raul_gonzalez', 21),
('Lista de luis_fernandez', 'luis_fernandez', 22),
('Lista de carmen_lopez', 'carmen_lopez', 23),
('Lista de javier_molina', 'javier_molina', 24),
('Lista de patricia_santos', 'patricia_santos', 5),
('Lista de manuel_ramirez', 'manuel_ramirez', 6);
('Lista de rosa_gutierrez', 'rosa_gutierrez', 18),
('Lista de rosa_gutierrez', 'rosa_gutierrez', 12),
('Lista de sergio_diaz', 'sergio_diaz', 13),
('Lista de sergio_diaz', 'sergio_diaz', 20),
('Lista de sergio_diaz', 'sergio_diaz', 22),
('Lista de luis_gomez', 'luis_gomez', 10),
('Lista de ana_perez', 'ana_perez', 8),
('Lista de carlos_rodriguez', 'carlos_rodriguez', 4),
('Lista de maria_lopez', 'maria_lopez', 1),
('Lista de maria_lopez', 'maria_lopez', 22),
('Lista de juan_hernandez', 'juan_hernandez', 24);

SELECT * FROM LISTA_has_PRODUCTO;


-- -----------------------------------------------------
-- Llenado de TIENDA
-- -----------------------------------------------------

INSERT INTO TIENDA (tie_nombre, tie_URL) VALUES

('Ktronix', 'https://www.ktronix.com/'),
('Mercadolibre', 'https://www.mercadolibre.com.co/'),
('Éxito', 'https://www.exito.com/');

SELECT * FROM TIENDA;


-- -----------------------------------------------------
-- Llenado de TIENDA
-- -----------------------------------------------------
ALTER TABLE TIENDA AUTO_INCREMENT = 1;
INSERT INTO TIENDA (tie_nombre, tie_URL) VALUES

('Ktronix', 'https://www.ktronix.com/'),
('Mercadolibre', 'https://www.mercadolibre.com.co/'),
('Éxito', 'https://www.exito.com/');


-- -----------------------------------------------------
-- Llenado de PRECIO
-- -----------------------------------------------------
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


------------------------------------------------
-- Llenado de CATEGORÍA
-- -----------------------------------------------------
ALTER TABLE CATEGORIA AUTO_INCREMENT = 1;
INSERT INTO CATEGORIA (cat_nombre) VALUES

('Celulares'),
('Computadores'),
('Televisores'),
('Electrodomésticos'),
('Audio'),
('Videojuegos'),
('Tablets'),
('Impresoras'),
('Cámaras'),
('Netflix y Pines'),
('Dispositivos Inteligentes'),
('Deportes'),
('Impresoras y Escáneres'),
('Accesorios'),
('Casa Inteligente'),
('SmarthWatch'),
('Instalaciones'),
('Seguros');

SELECT * FROM CATEGORIA;


-- -----------------------------------------------------
-- Llenado de  PRODUCTO_has_CATEGORIA
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Llenado de SESION
-- -----------------------------------------------------
INSERT INTO SESION (ses_fechaHoraIn, ses_fechaHoraOut, USUARIO_us_username) VALUES
('2023-10-28 18:00:00', '2023-10-28 19:00:00', 'juan_perez'),
('2023-10-28 19:30:00', '2023-10-28 20:30:00', 'maria_gomez'),
('2023-10-28 20:45:00', '2023-10-28 21:45:00', 'roberto_jimenez'),
('2023-10-28 22:00:00', '2023-10-28 23:00:00', 'susana_rodriguez'),
('2023-10-28 23:15:00', '2023-10-28 00:15:00', 'david_lopez'),
('2023-10-29 12:00:00', '2023-10-29 13:00:00', 'laura_sanchez'),
('2023-10-29 13:15:00', '2023-10-29 14:15:00', 'carlos_martin'),
('2023-10-29 14:30:00', '2023-10-29 15:30:00', 'isabel_hernandez'),
('2023-10-29 15:45:00', '2023-10-29 16:45:00', 'jose_luis'),
('2023-10-29 17:00:00', '2023-10-29 18:00:00', 'ana_garcia'),
('2023-10-29 18:15:00', '2023-10-29 19:15:00', 'pedro_ruiz'),
('2023-10-29 19:30:00', '2023-10-29 20:30:00', 'teresa_martinez'),
('2023-10-30 12:00:00', '2023-10-30 13:00:00', 'raul_gonzalez'),
('2023-10-30 13:15:00', '2023-10-30 14:15:00', 'luis_fernandez'),
('2023-10-30 14:30:00', '2023-10-30 15:30:00', 'carmen_lopez'),
('2023-10-30 15:45:00', '2023-10-30 16:45:00', 'javier_molina'),
('2023-10-30 17:00:00', '2023-10-30 18:00:00', 'patricia_santos'),
('2023-10-30 18:15:00', '2023-10-30 19:15:00', 'manuel_ramirez'),
('2023-10-30 19:30:00', '2023-10-30 20:30:00', 'rosa_gutierrez'),
('2023-10-30 20:45:00', '2023-10-30 21:45:00', 'sergio_diaz');
('2023-10-25 15:50:00', '2023-10-25 16:50:00', 'luis_gomez'),
('2023-10-25 15:51:00', '2023-10-25 16:51:00', 'ana_perez'),
('2023-10-25 15:52:00', '2023-10-25 16:52:00', 'carlos_rodriguez'),
('2023-10-25 15:53:00', '2023-10-25 16:53:00', 'maria_lopez'),
('2023-10-25 15:54:00', '2023-10-25 16:54:00', 'juan_hernandez');

SELECT * FROM SESION;

-- -----------------------------------------------------
-- Llenado de  ACCIONES
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Llenado de BUSQUEDA
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Llenado de BUSQUEDA_has_PRODUCTO
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Llenado de COMPARACION
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Llenado de COMPARACION_has_PRODUCTO
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Llenado de RESEÑA
-- -----------------------------------------------------