USE ColShop ;
SELECT * FROM Sesiones_De_Usuario;
SELECT * FROM Vista_UsuariosRegistrados;
SELECT * FROM AccionesDeUsuarios;

-- Update registration date of a product with scraping date if a better price is found for the same product ID
UPDATE PRODUCTO P
JOIN PRECIO PR ON P.pro_ID = PR.PRODUCTO_pro_ID
SET P.us_fechaReg = '2023-10-29 19:59:39.821854',
    P.pro_marca = 'Ipad',  --  new brand
    PR.pre_valor = 10000
WHERE P.pro_ID = 'MCO1991235718'  -- Replace 'ProductID' with the actual product ID
    AND PR.pre_valor > 10000;  -- Compare with the new price


-- Delete prices with dates earlier than today for a specific product
DELETE FROM PRECIO
WHERE PRODUCTO_pro_ID = 'MCO1991235718'  -- Replace 'ProductID' with the actual product ID
    AND pre_fechaHora < '2023-10-29 19:59:39.821854';  -- Delete prices with dates earlier than the current date and time

--  Delete users who have been inactive for a specified period (e.g., 6 months)
DELETE FROM USUARIO
WHERE us_username IN (
    SELECT us_username
    FROM SESION
    WHERE ses_fechaHoraOut < DATE_SUB(NOW(), INTERVAL 1 MONTH)
);
-- Update a record in the SESION table
UPDATE SESION
SET ses_fechaHoraIn = '2023-10-29 19:59:39.821854'
WHERE USUARIO_us_username = 'juan_perez';
