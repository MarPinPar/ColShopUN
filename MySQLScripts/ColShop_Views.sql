-- -----------------------------------------------------------------------
-- CREACION VISTAS
-- -----------------------------------------------------------------------
/*----------------------- USER ------------------------*/

-- Vista del perfil del propio usuario, incluye contraseña
DROP VIEW IF EXISTS miPerfil;
CREATE VIEW miPerfil AS
	SELECT us_username AS 'Nombre de Usuario', us_alias AS 'Alias', us_correo AS 'Correo', 
		us_contraseña AS 'Contraseña', us_fechaReg AS 'Fecha Registro'
    FROM USUARIO WHERE us_username = SUBSTRING_INDEX(USER(), '@', 1);

-- Vista del perfil de otros usuarios, no incluye contraseñas
DROP VIEW IF EXISTS perfiles;
CREATE VIEW perfiles AS
	SELECT us_username, us_alias, us_correo, us_fechaReg FROM USUARIO WHERE us_username != SUBSTRING_INDEX(USER(), '@', 1);


/*----------------------- ADMIN ------------------------*/


-- Vista de Usuarios Registrados
CREATE VIEW Vista_UsuariosRegistrados AS
SELECT us_username, us_alias, us_correo, us_fechaReg
FROM USUARIO;

-- Vista de Acciones de Usuarios:



-- Vista de Tiendas Registradas:
CREATE VIEW Vista_TiendasRegistradas AS
SELECT tie_ID AS Tienda_ID, tie_nombre AS Nombre_Tienda, tie_URL AS URL
FROM TIENDA;
SELECT * FROM Vista_TiendasRegistradas;

-- Vista de categorías registradas:
CREATE VIEW Vista_CategoriasProductos AS
SELECT cat_ID AS Categoria_ID, cat_nombre AS Nombre_Categoria
FROM CATEGORIA;
SELECT * FROM Vista_CategoriasProductos;

-- Vista de estadisticas:
CREATE VIEW Vista_EstadisticasSistema AS
SELECT
    (SELECT COUNT(*) FROM USUARIO) AS Total_Usuarios,
    (SELECT COUNT(*) FROM PRODUCTO) AS Total_Productos;

SELECT * FROM Vista_EstadisticasSistema ;

-- Vista de listas de otros usuarios
DROP VIEW IF EXISTS listasVisibles;
CREATE VIEW listasVisibles AS
	SELECT lis_nombre AS 'Nombre', lis_fechaCreacion AS 'Fecha de Creación', lis_fechaUltAct AS 'Última Actualización',
		USUARIO_us_username AS 'Autor'
    FROM LISTA WHERE USUARIO_us_username != SUBSTRING_INDEX(USER(), '@', 1);
-- -----------------------------------------------------------------------
-- CREACION ROLES
-- -----------------------------------------------------------------------

DROP ROLE IF EXISTS 'usuario'@'localhost';
CREATE ROLE 'usuario'@'localhost';
GRANT SELECT, UPDATE ON miPerfil TO 'usuario'@'localhost';
GRANT SELECT ON perfiles TO 'usuario'@'localhost';
GRANT SELECT ON listasVisibles TO 'usuario'@'localhost';

-- -----------------------------------------------------------------------
-- CREACION USUARIOS
-- -----------------------------------------------------------------------

DROP USER IF EXISTS 'juan_perez'@'localhost';
CREATE USER 'juan_perez'@'localhost' IDENTIFIED BY 'Cl4v3#123';
GRANT 'usuario'@'localhost' TO 'juan_perez'@'localhost';
SET DEFAULT ROLE ALL TO 'juan_perez'@'localhost';