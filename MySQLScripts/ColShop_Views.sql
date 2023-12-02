-- -----------------------------------------------------------------------
--                     !!! CREACION VISTAS !!!!
-- -----------------------------------------------------------------------


-- -----------------------------------------------------------------------
-- Vistas para el rol USUARIO
-- -----------------------------------------------------------------------

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
    FROM LISTA WHERE USUARIO_us_username != SUBSTRING_INDEX(USER(), '@', 1) AND lis_esPublica = 0;

-- Vista de listas propias
DROP VIEW IF EXISTS misListas;
CREATE VIEW misListas AS
	SELECT lis_nombre AS 'Nombre', lis_fechaCreacion AS 'Fecha de Creación', lis_esPublica AS 'Privacidad',
		lis_fechaUltAct AS 'Última Actualización', USUARIO_us_username AS 'Autor'
    FROM LISTA WHERE USUARIO_us_username = SUBSTRING_INDEX(USER(), '@', 1);
    
-- Vista de articulos en cada lista
DROP VIEW IF EXISTS contenidoListas;
CREATE VIEW contenidoListas AS 
	SELECT pro_ID AS 'ID', lis_nombre AS 'Nombre', lis_fechaCreacion AS 'Fecha de Creación', lis_fechaUltAct AS 'Última Actualización',
		USUARIO_us_username AS 'Autor', pro_nombre AS 'Nombre Producto'
    FROM LISTA JOIN lista_has_producto ON LISTA_lis_nombre = lis_nombre AND LISTA_USUARIO_us_username = USUARIO_us_username
    JOIN PRODUCTO ON pro_ID = PRODUCTO_pro_ID
    WHERE USUARIO_us_username = SUBSTRING_INDEX(USER(), '@', 1) OR lis_esPublica = 0;
    
-- Historial de Búsqueda
DROP VIEW IF EXISTS historialBusqueda;
CREATE VIEW historialBusqueda AS
	SELECT ac_fechaHora AS 'Fecha', bus_palabrasClave AS 'Palabras Clave'
    FROM sesion_has_accion S JOIN accion ON ac_ID = S.ACCION_ac_ID JOIN busqueda B ON ac_ID = B.ACCION_ac_ID
    WHERE SESION_USUARIO_us_username = SUBSTRING_INDEX(USER(), '@', 1);

-- Historial de Comparaciones
DROP VIEW IF EXISTS historialComparaciones;
CREATE VIEW historialComparaciones AS
	SELECT ac_fechaHora AS 'Fecha', pro_nombre AS 'Nombre'
    FROM sesion_has_accion S JOIN accion ON ac_ID = S.ACCION_ac_ID JOIN comparacion C ON ac_ID = C.ACCION_ac_ID
		JOIN comparacion_has_producto ON COMPARACION_ACCION_ac_ID = C.ACCION_ac_ID JOIN producto ON PRODUCTO_pro_ID = pro_ID
    WHERE SESION_USUARIO_us_username = SUBSTRING_INDEX(USER(), '@', 1);
    
-- Comentarios de Producto
DROP VIEW IF EXISTS comentariosProducto;
CREATE VIEW comentariosProducto AS
	SELECT pro_ID AS ID, pro_nombre AS Nombre, ac_fechaHora AS Fecha, SESION_USUARIO_us_username 
	AS Username, res_calificacion AS Calificacion, res_comentario AS Comentario
	FROM producto JOIN reseña ON pro_ID = PRODUCTO_pro_ID JOIN accion ON reseña.ACCION_ac_ID = ac_ID 
	JOIN sesion_has_accion ON sesion_has_accion.ACCION_ac_ID = ac_ID;
    

-- -----------------------------------------------------------------------
-- Vistas para el rol ADMINISTRADOR
-- -----------------------------------------------------------------------

-- Vista de Usuarios Registrados
DROP VIEW IF EXISTS Vista_UsuariosRegistrados;
CREATE VIEW Vista_UsuariosRegistrados AS
SELECT us_username, us_alias, us_correo, us_fechaReg
FROM USUARIO;

-- Vista de sesión:
DROP VIEW IF EXISTS Sesiones_De_Usuario;
CREATE VIEW Sesiones_De_Usuario AS
SELECT
    S.USUARIO_us_username AS Username,
    S.ses_fechaHoraIn AS SesionIniciada,
    S.ses_fechaHoraOut AS SesionFinalizada,
    TIMESTAMPDIFF(SECOND, S.ses_fechaHoraIn, S.ses_fechaHoraOut) AS SessionDurationInSeconds
FROM SESION S;

-- Vista de Acciones de Usuarios:
DROP VIEW IF EXISTS AccionesDeUsuarios;
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


-- Vista de estadisticas:
DROP VIEW IF EXISTS Vista_EstadisticasSistema;
CREATE VIEW Vista_EstadisticasSistema AS
SELECT
    (SELECT COUNT(*) FROM USUARIO) AS Total_Usuarios,
    (SELECT COUNT(*) FROM PRODUCTO) AS Total_Productos;