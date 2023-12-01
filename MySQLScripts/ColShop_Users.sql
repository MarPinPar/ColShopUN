-- -----------------------------------------------------------------------
--                  !!! CREACION ROLES !!!!
-- -----------------------------------------------------------------------

-- -----------------------------------------------------------------------
-- Rol USUARIO
-- -----------------------------------------------------------------------
DROP ROLE IF EXISTS 'usuario'@'localhost';
CREATE ROLE 'usuario'@'localhost';

-- Permisos sobre tablas/vistas
GRANT SELECT, UPDATE ON miPerfil TO 'usuario'@'localhost';
GRANT SELECT ON perfiles TO 'usuario'@'localhost';
GRANT SELECT ON listasVisibles TO 'usuario'@'localhost';
GRANT SELECT ON contenidoListas TO 'usuario'@'localhost';
GRANT SELECT ON historialBusqueda TO 'usuario'@'localhost';
GRANT SELECT ON historialComparaciones TO 'usuario'@'localhost';
GRANT SELECT ON comentariosProducto TO 'usuario'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON misListas TO 'usuario'@'localhost';

GRANT SELECT, CREATE ON sesion TO 'usuario'@'localhost';
GRANT CREATE ON sesion_has_accion TO 'usuario'@'localhost';
GRANT CREATE ON accion TO 'usuario'@'localhost';
GRANT CREATE ON comparacion TO 'usuario'@'localhost';
GRANT CREATE ON comparacion_has_producto TO 'usuario'@'localhost';
GRANT CREATE ON busqueda TO 'usuario'@'localhost';
GRANT CREATE ON busqueda_has_producto TO 'usuario'@'localhost';

GRANT SELECT ON categoria TO 'usuario'@'localhost';
GRANT SELECT ON producto_has_categoria TO 'usuario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON producto TO 'usuario'@'localhost';
GRANT SELECT, INSERT ON precio TO 'usuario'@'localhost';
GRANT SELECT ON tienda TO 'usuario'@'localhost';

GRANT CREATE, DELETE ON lista_has_producto TO 'usuario'@'localhost';
GRANT CREATE, UPDATE, DELETE ON reseña TO 'usuario'@'localhost';

-- Permisos sobre procedimientos/funciones
GRANT EXECUTE ON PROCEDURE sp_create_action TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_create_busqueda TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_create_comparacion TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_create_list TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_create_reseña TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_create_session TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_delete_from_comparacion TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_delete_list TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_delete_product_from_list TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_delete_reseña TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_fill_comparacion TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_get_list TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_GetLowestPriceByProductName TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_GetPriceHistoryForProductInStore TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_GetPricesForProductsBySearch TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_insert_product_into_list TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_modify_user TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_set_session_end TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_view_list TO 'usuario'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_getMostRecentPriceByProductName TO 'usuario'@'localhost';

GRANT EXECUTE ON FUNCTION fn_getCurrentSession TO 'usuario'@'localhost';

-- -----------------------------------------------------------------------
-- Rol ADMINISTRADOR
-- -----------------------------------------------------------------------
DROP ROLE IF EXISTS 'admin'@'localhost';
CREATE ROLE 'admin'@'localhost';

GRANT SELECT ON AccionesDeUsuarios TO 'admin'@'localhost';
GRANT SELECT ON Vista_EstadisticasSistema TO 'admin'@'localhost';
GRANT SELECT, DELETE ON Vista_UsuariosRegistrados TO 'admin'@'localhost';

GRANT SELECT, UPDATE, DELETE, INSERT ON accion TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON busqueda TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON busqueda_has_producto TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON categoria TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON comparacion TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON comparacion_has_producto TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON lista TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON lista_has_producto TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON precio TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON producto TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON producto_has_categoria TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON reseña TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON sesion TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON sesion_has_accion TO 'admin'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON tienda TO 'admin'@'localhost';

-- Permisos sobre procedimientos/funciones
GRANT EXECUTE ON PROCEDURE sp_delete_list TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_delete_product_from_list TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_delete_reseña TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_get_list TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_GetLowestPriceByProductName TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_GetPriceHistoryForProductInStore TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_GetPricesForProductsBySearch TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_set_session_end TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_view_list TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_add_product_category TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_create_category TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_delete_product_category TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_create_user TO 'admin'@'localhost';

-- -----------------------------------------------------------------------
-- Rol MODERADOR
-- -----------------------------------------------------------------------
DROP ROLE IF EXISTS 'moderador'@'localhost';
CREATE ROLE 'moderador'@'localhost';

GRANT SELECT ON categoria TO 'moderador'@'localhost';
GRANT SELECT ON producto_has_categoria TO 'moderador'@'localhost';
GRANT SELECT ON producto TO 'moderador'@'localhost';
GRANT SELECT ON precio TO 'moderador'@'localhost';
GRANT SELECT ON tienda TO 'moderador'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON comentariosProducto TO 'moderador'@'localhost';
GRANT SELECT, UPDATE, DELETE, INSERT ON reseña TO 'moderador'@'localhost';

-- Permisos sobre procedimientos/funciones
GRANT EXECUTE ON PROCEDURE sp_delete_list TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_delete_reseña TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_get_list TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_view_list TO 'admin'@'localhost';

-- -----------------------------------------------------------------------
-- CREACION USUARIOS
-- -----------------------------------------------------------------------
DROP USER IF EXISTS 'juan_perez'@'localhost';
CREATE USER 'juan_perez'@'localhost' IDENTIFIED BY 'Cl4v3#123';
GRANT 'usuario'@'localhost' TO 'juan_perez'@'localhost';
SET DEFAULT ROLE ALL TO 'juan_perez'@'localhost';

-- -----------------------------------------------------------------------
-- CREACION MODERADOR
-- -----------------------------------------------------------------------
DROP USER IF EXISTS 'mod_test'@'localhost';
CREATE USER 'mod_test'@'localhost' IDENTIFIED BY 'key_test';
GRANT 'moderador'@'localhost' TO 'mod_test'@'localhost';
SET DEFAULT ROLE ALL TO 'mod_test'@'localhost';

-- -----------------------------------------------------------------------
-- CREACION ADMIN
-- -----------------------------------------------------------------------
DROP USER IF EXISTS 'admin1'@'localhost';
CREATE USER 'admin1'@'localhost' IDENTIFIED BY 'Uno2tres**';
GRANT 'admin'@'localhost' TO 'admin1'@'localhost';
SET DEFAULT ROLE ALL TO 'admin1'@'localhost';