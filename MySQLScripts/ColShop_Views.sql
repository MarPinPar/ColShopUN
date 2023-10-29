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

-- Vista de listas de otros usuarios
DROP VIEW IF EXISTS listasVisibles;
CREATE VIEW listasVisibles AS
	SELECT lis_nombre AS 'Nombre', lis_fechaCreacion AS 'Fecha de Creación', lis_fechaUltAct AS 'Última Actualización',
		USUARIO_us_username AS 'Autor'
    FROM LISTA WHERE USUARIO_us_username != SUBSTRING_INDEX(USER(), '@', 1);


/*----------------------- ADMIN ------------------------*/


-- Vista de Usuarios Registrados
CREATE VIEW Vista_UsuariosRegistrados AS
SELECT us_username, us_alias, us_correo, us_fechaReg
FROM USUARIO;

-- Vista de sesión:
CREATE VIEW Sesiones_De_Usuario AS
SELECT
    S.USUARIO_us_username AS Username,
    S.ses_fechaHoraIn AS SesionIniciada,
    S.ses_fechaHoraOut AS SesionFinalizada,
    TIMESTAMPDIFF(SECOND, S.ses_fechaHoraIn, S.ses_fechaHoraOut) AS SessionDurationInSeconds
FROM SESION S;
SELECT * FROM Sesiones_De_Usuario;

-- Vista de Acciones de Usuarios:
CREATE VIEW AccionesDeUsuarios AS
SELECT
    A.ac_ID AS ID_Accion,
    U.us_username AS Nombre_Usuario,
    A.ac_fechaHora AS Fecha_Hora_Accion,
    'Busqueda' AS Tipo_Accion,
    B.bus_palabrasClave AS Detalles
FROM ACCION A
JOIN SESION_has_ACCION SA ON A.ac_ID = SA.ACCION_ac_ID
JOIN USUARIO U ON SA.SESION_USUARIO_us_username = U.us_username
LEFT JOIN BUSQUEDA B ON A.ac_ID = B.ACCION_ac_ID

UNION

SELECT
    A.ac_ID AS ID_Accion,
    U.us_username AS Nombre_Usuario,
    A.ac_fechaHora AS Fecha_Hora_Accion,
    'Comparacion' AS Tipo_Accion,
    NULL AS Detalles
FROM ACCION A
JOIN SESION_has_ACCION SA ON A.ac_ID = SA.ACCION_ac_ID
JOIN USUARIO U ON SA.SESION_USUARIO_us_username = U.us_username
LEFT JOIN COMPARACION C ON A.ac_ID = C.ACCION_ac_ID

UNION

SELECT
    A.ac_ID AS ID_Accion,
    U.us_username AS Nombre_Usuario,
    A.ac_fechaHora AS Fecha_Hora_Accion,
    'Reseña' AS Tipo_Accion,
    NULL AS Detalles
FROM ACCION A
JOIN SESION_has_ACCION SA ON A.ac_ID = SA.ACCION_ac_ID
JOIN USUARIO U ON SA.SESION_USUARIO_us_username = U.us_username
LEFT JOIN RESEÑA R ON A.ac_ID = R.ACCION_ac_ID;
SELECT * FROM AccionesDeUsuarios;


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