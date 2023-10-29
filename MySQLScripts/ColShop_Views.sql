DROP VIEW IF EXISTS myProfile;
CREATE VIEW myProfile AS
SELECT * FROM USUARIO WHERE us_username = SUBSTRING_INDEX(USER(), '@', 1);

DROP ROLE IF EXISTS 'usuario'@'localhost';
CREATE ROLE 'usuario'@'localhost';
GRANT SELECT ON myProfile TO 'usuario'@'localhost';

DROP USER IF EXISTS 'juan_perez'@'localhost';
CREATE USER 'juan_perez'@'localhost' IDENTIFIED BY 'Cl4v3#123';

GRANT 'usuario'@'localhost' TO 'juan_perez'@'localhost';
SET DEFAULT ROLE ALL TO 'juan_perez'@'localhost';