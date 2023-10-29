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
('sergio_diaz', 'Sergio', 'sergio.diaz@outlook.com', 'S3gur0123!', '2023-10-30 21:30:00'),
('luis_gomez', 'Luis', 'luis@example.com', 'luispass123', '2023-10-25 15:50:00'),
('ana_perez', 'Ana', 'ana@example.com', 'anapass', '2023-10-25 15:51:00'),
('carlos_rodriguez', 'Carlos', 'carlos@example.com', 'mipassword', '2023-10-25 15:52:00'),
('maria_lopez', 'Maria', 'maria@example.com', 'mariapass123', '2023-10-25 15:53:00'),
('juan_hernandez', 'Juan', 'juan@example.com', 'juanpass', '2023-10-25 15:54:00');

SELECT * FROM USUARIO;

DELETE FROM CATEGORIA;
DELETE FROM PRODUCTO;
DELETE FROM USUARIO;
DELETE FROM TIENDA;
DELETE FROM PRECIO;
DELETE FROM PRECIO WHERE PRODUCTO_pro_ID IN (SELECT pro_ID FROM PRODUCTO);
-- -----------------------------------------------------
-- Llenado de PRODUCTO
-- -----------------------------------------------------
ALTER TABLE PRODUCTO MODIFY pro_ID VARCHAR(20);



-- Insertar nuevos productos
INSERT INTO PRODUCTO (pro_ID, pro_nombre, pro_marca)
VALUES 
  ('MCO1991235718', 'Apple iPhone 14 Pro Max (256 GB) - Morado oscuro', 'iPhone'),
  ('MCO1991235660', 'Apple iPhone 14 Pro Max 128 GB Morado oscuro', 'iPhone'),
  ('194253488224', 'iPhone 14 128 GB Azul Medianoche', 'iPhone'),
  ('194253486770', 'iPhone 14 Pro Max 128 GB Morado Oscuro', 'iPhone'),
  ('102378158', 'Iphone 14 Pro Max 128Gb 5G Negro', 'iPhone'),
  ('3103350', 'iPhone 14 128 GB Medianoche', 'iPhone'),
  ('MCO1134011449', 'Computador Gamer Hp Victus Core I5 32gb 512gb Gtx 1650 W11', 'HP'),
  ('MCO1897008752', 'Computador Gamer Hp Victus Core I5 36gb 2tb Gtx 1650 W11', 'HP'),
  ('197497202632', 'Computador Portátil Gamer Victus HP 15,6" Pulgadas Fa0000la Intel Core I5- RAM 16GB - Disco SSD 512GB - Azul', 'HP'),
  ('197497272383', 'Computador Portátil Gamer Victus HP 15.6" Pulgadas fb0102la - AMD Ryzen 5 - RAM 8GB- Disco SSD 512 GB - Gris', 'HP'),
  ('MCO18518359', 'Smart TV Samsung The Frame QN55LS03AAGXZD QLED Tizen 4K 55" 100V/240V', 'Samsung'),
  ('MCO21817325', 'Televisor Samsung Smart 55 The Frame Qled 4k 55ls03b', 'Samsung'),
  ('8806095058290', 'TV SAMSUNG 55" Pulgadas 139.7 cm F-QN55LS03BAK1 4K-UHD QLED THE FRAME Smart TV (Incluye marco color caoba VG-SCFA55TKBRU)', 'Samsung'),
  ('MCO18577601', 'Nevecón inverter no frost Samsung RS22T5200 refined inox con freezer 623L 127V', 'Samsung'),
  ('MCO811229346','Nevecón Samsung Side By Side 628 Litros Rs22t5200s9/co Gris', 'Samsung'),
  ('8806092234468', 'Nevecón SAMSUNG Side by Side 628 Litros RS22T5200B1/CO Grafito', 'Samsung'),
  ('3103340', 'Nevecón SAMSUNG Side By Side 628 litros RS22T5200S9/CO', 'Samsung'),
  ('MCO1931313794', 'Parlante JBL Go Essential JBL-GOESBLK portátil con bluetooth waterproof negra 110V/220V', 'Otra'),
  ('MCO1960108692', 'Parlante JBL Go Essential JBL-GOESBLK portátil con bluetooth waterproof roja 110V/220V', 'Otra'),
  ('6925281995613', 'Parlante JBL Inalámbrico Bluetooth GO Essential 3.1W Negro', 'Otra'),
  ('6925281995637', 'Parlante JBL Inalámbrico Bluetooth GO Essential 3.1W Rojo', 'Otra'),
  ('3043574', 'Parlante Go 3 BT Neg JBL JBLGO3BLKAM', 'JBL'),
  ('3043573', 'Parlante Go 3 BT Azul JBL JBLGO3BLUAM', 'JBL'),
  ('MCO1940674356', 'Sony PlayStation 5 825GB Marvel’s Spider Man 2 Limited Edition color rojo y negro', 'Sony'),
  ('MCO1268357573', 'Control Ps5 Negro Midnight Black Original + Cable Usb', 'Otra'),
  ('711719566625', 'Consola PS5 Estándar 825GB + 1 Control Dualsense + Voucher de descarga Juego FC24', 'Otra'),
  ('101112640', 'Consola Playstation 5 Ps5 Digital Edition 825Gb Sony', 'Sony');

  
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

-- SELECT * FROM LISTA;


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
('Lista de manuel_ramirez', 'manuel_ramirez', 6),
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

-- SELECT * FROM LISTA_has_PRODUCTO;


-- -----------------------------------------------------
-- Llenado de TIENDA
-- -----------------------------------------------------

INSERT INTO TIENDA (tie_nombre, tie_URL) VALUES

('Ktronix', 'https://www.ktronix.com/'),
('Mercadolibre', 'https://www.mercadolibre.com.co/'),
('Éxito', 'https://www.exito.com/');

SELECT * FROM TIENDA;


-- -----------------------------------------------------
-- Llenado de PRECIO
-- -----------------------------------------------------
INSERT INTO PRECIO (PRODUCTO_pro_ID, TIENDA_tie_ID, pre_fechaHora, pre_valor, pre_URL, pre_imagen)
VALUES
  ('MCO1991235718', 2, '2023-10-28 20:40:02.364496', 5590000, 'https://www.mercadolibre.com.co/apple-iphone-14-pro-max-256-gb-morado-oscuro/p/MCO19615354?pdp_filters=category:MCO1055#searchVariation=MCO19615354&position=1&search_layout=stack&type=product&tracking_id=d7425eed-0e49-4618-9917-21be614a5b12', 'placeholder_image_url1'),
  ('MCO1991235660', 2, '2023-10-28 20:40:02.364496', 5490000, 'https://www.mercadolibre.com.co/apple-iphone-14-pro-max-128-gb-morado-oscuro/p/MCO19615329?pdp_filters=category:MCO1055#searchVariation=MCO19615329&position=3&search_layout=stack&type=product&tracking_id=d7425eed-0e49-4618-9917-21be614a5b12', 'placeholder_image_url2'),
  ('194253488224', 1, '2023-10-28 20:40:23.774478', 4029000, 'https://www.ktronix.com/iphone14-128gb-azul-medianoche/p/194253488224', 'placeholder_image_url3'),
  ('194253486770', 1, '2023-10-28 20:40:23.774478', 6099000, 'https://www.ktronix.com/iphone-14-pro-max-128gb-morado-oscuro/p/194253486770', 'placeholder_image_url4'),
  ('102378158', 3, '2023-10-28 20:41:05.259697', 5859900, 'https://exitocol.vtexassets.com/arquivos/ids/15562745-500-auto?v=638043813455730000&width=500&height=auto&aspect=true', 'placeholder_image_url5'),
  ('3103350', 3, '2023-10-28 20:41:05.259697', 4889900, 'https://exitocol.vtexassets.com/arquivos/ids/19708177-500-auto?v=638304163880600000&width=500&height=auto&aspect=true', 'placeholder_image_url6'),
  ('MCO1134011449', 2, '2023-10-28 21:03:48.646819', 3699999, 'https://articulo.mercadolibre.com.co/MCO-1134011449-computador-gamer-hp-victus-core-i5-32gb-512gb-gtx-1650-w11-_JM#position=4&search_layout=stack&type=item&tracking_id=51be0221-73cc-42d6-9d7b-99f4fe0201bf', 'https://http2.mlstatic.com/D_NQ_NP_962770-MLM54029806942_022023-V.webp'),
  ('MCO1897008752', 2, '2023-10-28 21:03:48.646819', 4099900, 'https://articulo.mercadolibre.com.co/MCO-1897008752-computador-gamer-hp-victus-core-i5-36gb-2tb-gtx-1650-w11-_JM#position=5&search_layout=stack&type=item&tracking_id=51be0221-73cc-42d6-9d7b-99f4fe0201bf', 'https://http2.mlstatic.com/D_NQ_NP_962770-MLM54029806942_022023-V.webp'),
  ('197497202632', 1, '2023-10-28 21:04:07.612527', 4149000, 'https://www.ktronix.com/computador-portatil-gamer-victus-hp-156-pulgadas-fa0000la-intel-core-i5-ram-16gb-disco-ssd-512gb-azul/p/197497202632', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
  ('197497272383', 1, '2023-10-28 21:04:07.612527', 3399000, 'https://www.ktronix.com/computador-portatil-gamer-victus-hp-156-pulgadas-fb0102la-amd-ryzen-5-ram-8gb-disco-ssd-512-gb-gris/p/197497272383', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
  ('MCO18518359', 2, '2023-10-28 21:13:43.155206', 3999900, 'https://www.mercadolibre.com.co/smart-tv-samsung-the-frame-qn55ls03aagxzd-qled-tizen-4k-55-100v240v/p/MCO18518359#searchVariation=MCO18518359&position=1&search_layout=stack&type=product&tracking_id=34a23d45-f7a9-4728-bd10-9718a38ef233', 'https://http2.mlstatic.com/D_NQ_NP_602843-MLA48624638731_122021-V.webp'),
  ('MCO21817325', 2, '2023-10-28 21:13:43.155206', 3699900, 'https://www.mercadolibre.com.co/televisor-samsung-smart-55-the-frame-qled-4k-55ls03b/p/MCO21817325#searchVariation=MCO21817325&position=2&search_layout=stack&type=product&tracking_id=34a23d45-f7a9-4728-bd10-9718a38ef233', 'https://http2.mlstatic.com/D_NQ_NP_602843-MLA48624638731_122021-V.webp'),
  ('8806095058290', 1, '2023-10-28 21:13:57.530012', 3899900, 'https://www.ktronix.com/tv-samsung-55-pulgadas-1397-cm-f-qn55ls03bak1-4k-uhd-qled-the-frame-smart-tv-incluye-marco-color-caoba-vg-scfa55tkbru/p/8806095058290', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
  ('MCO18577601', 2, '2023-10-28 21:25:00.610739', 6009900, 'https://www.mercadolibre.com.co/nevecon-inverter-no-frost-samsung-rs22t5200-refined-inox-con-freezer-623l-127v/p/MCO18577601?pdp_filters=category:MCO115334#searchVariation=MCO18577601&position=1&search_layout=stack&type=product&tracking_id=7fe0438a-9173-479d-a28c-d1b23443a380', 'https://http2.mlstatic.com/D_NQ_NP_940993-MLA48256464464_112021-V.webp'),
  ('MCO811229346', 2, '2023-10-28 21:25:00.610739', 6009900, 'https://articulo.mercadolibre.com.co/MCO-811229346-nevecon-samsung-side-by-side-628-litros-rs22t5200s9co-gris/_JM#position=4&search_layout=stack&type=item&tracking_id=7fe0438a-9173-479d-a28c-d1b23443a380', 'https://http2.mlstatic.com/D_NQ_NP_940993-MLA48256464464_112021-V.webp'),
  ('8806092234468', 1, '2023-10-28 21:25:14.822621', 6099900, 'https://www.ktronix.com/nevecon-samsung-side-by-side-628-litros-rs22t5200b1-co-grafito/p/8806092234468', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
  ('3103340', 3, '2023-10-28 21:25:56.216440', 6629000, 'https://exitocol.vtexassets.com/arquivos/ids/20006994-500-auto?v=638333517823030000&width=500&height=auto&aspect=true', 'https://tienda.exito.com/nevecon-649litros-brutos-silve-samsung-rs22t5200s9co-3034389/p'),
  ('MCO1931313794', 2, '2023-10-28 21:35:20.802840', 144000, 'https://www.mercadolibre.com.co/parlante-jbl-go-essential-jbl-goesblk-portatil-con-bluetooth-waterproof-negra-110v220v/p/MCO19561887?pdp_filters=category:MCO3835#searchVariation=MCO19561887&position=1&search_layout=stack&type=product&tracking_id=1087432b-55cd-4879-bf18-6c9884e01e04', 'https://http2.mlstatic.com/D_NQ_NP_718513-MLA51457677647_092022-V.webp'),
  ('MCO1960108692', 2, '2023-10-28 21:35:20.802840', 179900, 'https://www.mercadolibre.com.co/parlante-jbl-go-essential-jbl-goesblk-portatil-con-bluetooth-waterproof-roja-110v220v/p/MCO19561890?pdp_filters=category:MCO3835#searchVariation=MCO19561890&position=2&search_layout=stack&type=product&tracking_id=1087432b-55cd-4879-bf18-6c9884e01e04', 'https://http2.mlstatic.com/D_NQ_NP_718513-MLA51457677647_092022-V.webp'),
  ('6925281995613', 1, '2023-10-28 21:35:39.930595', 189900, 'https://www.ktronix.com/parlante-jbl-inalambrico-bluetooth-go-essential-31w-negro/p/6925281995613', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
  ('6925281995637', 1, '2023-10-28 21:35:39.930595', 189900, 'https://www.ktronix.com/parlante-jbl-inalambrico-bluetooth-go-essential-31w-rojo/p/6925281995637', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
  ('3043574', 3, '2023-10-28 21:36:43.322452', 362900, 'https://exitocol.vtexassets.com/arquivos/ids/19579248-500-auto?v=638289502403400000&width=500&height=auto&aspect=true', 'https://tienda.exito.com/parlante-go-3-bt-neg-jbl-jblgo3blkam-3043574/p'),
  ('3043573', 3, '2023-10-28 21:36:43.322452', 362900, 'https://exitocol.vtexassets.com/arquivos/ids/19579243-500-auto?v=638289502362400000&width=500&height=auto&aspect=true', 'https://tienda.exito.com/parlante-go-3-bt-azu-jbl-jblgo3bluam-3043573/p'),
  ('MCO1940674356', 2, '2023-10-28 21:46:43.485171', 3057221, 'https://www.mercadolibre.com.co/sony-playstation-5-825gb-marvels-spider-man-2-limited-edition-color-rojo-y-negro/p/MCO26081587#searchVariation=MCO26081587&position=1&search_layout=stack&type=product&tracking_id=e18dd6a8-e621-420c-b834-568e2e6d2d9f', 'https://http2.mlstatic.com/D_NQ_NP_983860-MLA71086105152_082023-V.webp'),
  ('MCO1268357573',2, '2023-10-28 21:46:43.485171', 357900, 'https://articulo.mercadolibre.com.co/MCO-1268357573-control-ps5-negro-midnight-black-original-cable-usb-_JM#position=23&search_layout=stack&type=item&tracking_id=e18dd6a8-e621-420c-b834-568e2e6d2d9f', 'https://http2.mlstatic.com/D_NQ_NP_983860-MLA71086105152_082023-V.webp'),
  ('711719566625', 1, '2023-10-28 21:47:00.348019', 3599900, 'https://www.ktronix.com/consola-ps5-estandar-825gb-1-control-dualsense-voucher-descarga-juego-fc24/p/711719566625', 'https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg'),
  ('101112640', 3, '2023-10-28 21:47:48.28766', 2279889, 'https://exitocol.vtexassets.com/arquivos/ids/9154831-500-auto?v=637631028265630000&width=500&height=auto&aspect=true', 'https://tienda.exito.com/consola-playstation-5-ps5-digital-edition-sony-101112640-mp/p')
  ;

-- SELECT * FROM PRECIO;


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

INSERT INTO PRODUCTO_has_CATEGORIA (PRODUCTO_pro_ID, CATEGORIA_cat_ID) VALUES
(1, 1), -- Producto 1 pertenece a la categoría Celulares
(2, 1), -- Producto 2 pertenece a la categoría Celulares
(3, 1), -- Producto 3 pertenece a la categoría Celulares
(4, 1), -- Producto 4 pertenece a la categoría Celulares
(5, 1), -- Producto 5 pertenece a la categoría Celulares
(6, 1), -- Producto 6 pertenece a la categoría Celulares
(7, 1), -- Producto 7 pertenece a la categoría Celulares
(8, 1), -- Producto 8 pertenece a la categoría Celulares
(9, 1), -- Producto 9 pertenece a la categoría Celulares
(10, 1), -- Producto 10 pertenece a la categoría Celulares
(11, 2), -- Producto 11 pertenece a la categoría Computadores
(12, 2), -- Producto 12 pertenece a la categoría Computadores
(13, 2), -- Producto 13 pertenece a la categoría Computadores
(14, 2), -- Producto 14 pertenece a la categoría Computadores
(15, 2), -- Producto 15 pertenece a la categoría Computadores
(16, 2), -- Producto 16 pertenece a la categoría Computadores
(17, 2), -- Producto 17 pertenece a la categoría Computadores
(18, 2), -- Producto 18 pertenece a la categoría Computadores
(19, 3), -- Producto 19 pertenece a la categoría Televisores
(20, 3), -- Producto 20 pertenece a la categoría Televisores
(21, 3), -- Producto 21 pertenece a la categoría Televisores
(22, 2), -- Producto 22 pertenece a la categoría Computadores
(23, 2), -- Producto 23 pertenece a la categoría Computadores
(24, 2), -- Producto 24 pertenece a la categoría Computadores
(25, 4), -- Producto 25 pertenece a la categoría Electrodomésticos
(26, 4), -- Producto 26 pertenece a la categoría Electrodomésticos
(27, 3), -- Producto 27 pertenece a la categoría Televisores
(28, 4), -- Producto 28 pertenece a la categoría Electrodomésticos
(29, 4), -- Producto 29 pertenece a la categoría Electrodomésticos
(30, 4), -- Producto 30 pertenece a la categoría Electrodomésticos
(31, 5), -- Producto 31 pertenece a la categoría Audio
(32, 5), -- Producto 32 pertenece a la categoría Audio
(33, 5), -- Producto 33 pertenece a la categoría Audio
(34, 6), -- Producto 34 pertenece a la categoría Videojuegos
(35, 6), -- Producto 35 pertenece a la categoría Videojuegos
(36, 6), -- Producto 36 pertenece a la categoría Videojuegos
(37, 7), -- Producto 37 pertenece a la categoría Tablets
(38, 7); -- Producto 38 pertenece a la categoría Tablets

-- SELECT * FROM PRODUCTO_has_CATEGORIA;
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
('2023-10-30 20:45:00', '2023-10-30 21:45:00', 'sergio_diaz'),
('2023-10-25 15:50:00', '2023-10-25 16:50:00', 'luis_gomez'),
('2023-10-25 15:51:00', '2023-10-25 16:51:00', 'ana_perez'),
('2023-10-25 15:52:00', '2023-10-25 16:52:00', 'carlos_rodriguez'),
('2023-10-25 15:53:00', '2023-10-25 16:53:00', 'maria_lopez'),
('2023-10-25 15:54:00', '2023-10-25 16:54:00', 'juan_hernandez');

-- SELECT * FROM SESION;

-- -----------------------------------------------------
-- Llenado de  ACCIONES
-- -----------------------------------------------------
INSERT INTO ACCION (ac_fechaHora) VALUES 
('2023-10-28 18:00:10'),
('2023-10-28 19:30:10'),
('2023-10-28 20:45:10'),
('2023-10-28 22:00:10'),
('2023-10-28 23:15:10'),
('2023-10-29 12:00:10'),
('2023-10-29 13:15:10'),
('2023-10-29 14:30:10'),
('2023-10-29 15:45:10'),
('2023-10-29 17:00:10'),
('2023-10-29 18:15:10'),
('2023-10-29 19:30:10'),
('2023-10-30 12:00:10'),
('2023-10-30 13:15:10'),
('2023-10-30 14:30:10'),
('2023-10-30 15:45:10'),
('2023-10-30 17:00:10'),
('2023-10-30 18:15:10'),
('2023-10-30 19:30:10'),
('2023-10-30 20:45:10'),
('2023-10-25 15:50:10'),
('2023-10-25 15:51:10'),
('2023-10-25 15:52:10'),
('2023-10-25 15:53:10'),
('2023-10-25 15:54:10')
;

SELECT * FROM ACCION;

-- -----------------------------------------------------
-- Table SESION_has_ACCION
-- -----------------------------------------------------
INSERT INTO SESION_has_ACCION VALUES
('2023-10-28 18:00:00', '2023-10-28 19:00:00', 'juan_perez', 1),
('2023-10-28 19:30:00', '2023-10-28 20:30:00', 'maria_gomez', 2),
('2023-10-28 20:45:00', '2023-10-28 21:45:00', 'roberto_jimenez', 3),
('2023-10-28 22:00:00', '2023-10-28 23:00:00', 'susana_rodriguez', 4),
('2023-10-28 23:15:00', '2023-10-28 00:15:00', 'david_lopez', 5),
('2023-10-29 12:00:00', '2023-10-29 13:00:00', 'laura_sanchez', 6),
('2023-10-29 13:15:00', '2023-10-29 14:15:00', 'carlos_martin', 7),
('2023-10-29 14:30:00', '2023-10-29 15:30:00', 'isabel_hernandez', 8),
('2023-10-29 15:45:00', '2023-10-29 16:45:00', 'jose_luis', 9),
('2023-10-29 17:00:00', '2023-10-29 18:00:00', 'ana_garcia', 10),
('2023-10-29 18:15:00', '2023-10-29 19:15:00', 'pedro_ruiz', 11),
('2023-10-29 19:30:00', '2023-10-29 20:30:00', 'teresa_martinez', 12),
('2023-10-30 12:00:00', '2023-10-30 13:00:00', 'raul_gonzalez', 13),
('2023-10-30 13:15:00', '2023-10-30 14:15:00', 'luis_fernandez', 14),
('2023-10-30 14:30:00', '2023-10-30 15:30:00', 'carmen_lopez', 15),
('2023-10-30 15:45:00', '2023-10-30 16:45:00', 'javier_molina', 16),
('2023-10-30 17:00:00', '2023-10-30 18:00:00', 'patricia_santos', 17),
('2023-10-30 18:15:00', '2023-10-30 19:15:00', 'manuel_ramirez',18),
('2023-10-30 19:30:00', '2023-10-30 20:30:00', 'rosa_gutierrez', 19),
('2023-10-30 20:45:00', '2023-10-30 21:45:00', 'sergio_diaz', 20),
('2023-10-25 15:50:00', '2023-10-25 16:50:00', 'luis_gomez', 21),
('2023-10-25 15:51:00', '2023-10-25 16:51:00', 'ana_perez', 22),
('2023-10-25 15:52:00', '2023-10-25 16:52:00', 'carlos_rodriguez', 23),
('2023-10-25 15:53:00', '2023-10-25 16:53:00', 'maria_lopez', 24),
('2023-10-25 15:54:00', '2023-10-25 16:54:00', 'juan_hernandez', 25)
;

-- -----------------------------------------------------
-- Llenado de BUSQUEDA
-- -----------------------------------------------------
INSERT INTO BUSQUEDA VALUES
(1, 'IPhone 14'),
(2, 'Computador Gamer'),
(3, 'Smart TV'),
(4, 'TV Samsung'),
(5, 'Nevecón'),
(6, 'Parlante'),
(7, 'Control'),
(8, 'Playstation')
;

-- -----------------------------------------------------
-- Llenado de BUSQUEDA_has_PRODUCTO
-- -----------------------------------------------------
INSERT INTO BUSQUEDA_has_PRODUCTO VALUES
(1, 'MCO1991235718'),
(1, 'MCO1991235660'),
(1, '194253488224'),
(1, '194253486770'),
(1, '102378158'),
(1, '3103350'),
(2, 'MCO1134011449'),
(2, 'MCO1897008752'),
(2, '197497202632'),
(2, '197497272383'),
(3, 'MCO18518359'),
(3, '8806095058290'),
(4, 'MCO18518359'),
(4, '8806095058290'),
(5, 'MCO18577601'),
(5, 'MCO811229346'),
(5, '8806092234468'),
(5, '3103340'),
(6, 'MCO1931313794'),
(6, 'MCO1960108692'),
(6, '6925281995613'),
(6, '6925281995637'),
(6, '3043574'),
(6, '3043573'),
(7, 'MCO1268357573'),
(7, '711719566625'),
(8, 'MCO1940674356'),
(8, '101112640')
;

-- -----------------------------------------------------
-- Llenado de COMPARACION
-- -----------------------------------------------------
INSERT INTO COMPARACION VALUES
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17)
;

-- -----------------------------------------------------
-- Llenado de COMPARACION_has_PRODUCTO
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Llenado de RESEÑA
-- -----------------------------------------------------