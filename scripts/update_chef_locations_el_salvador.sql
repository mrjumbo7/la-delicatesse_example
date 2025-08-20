-- Script para actualizar las ubicaciones de los chefs con municipios y departamentos de El Salvador
-- Actualizar ubicaciones de chefs con datos reales de El Salvador

UPDATE perfiles_chef SET ubicacion = 'San Salvador, San Salvador' WHERE usuario_id = 3;
UPDATE perfiles_chef SET ubicacion = 'Santa Ana, Santa Ana' WHERE usuario_id = 4;
UPDATE perfiles_chef SET ubicacion = 'San Miguel, San Miguel' WHERE usuario_id = 5;
UPDATE perfiles_chef SET ubicacion = 'Soyapango, San Salvador' WHERE usuario_id = 6;
UPDATE perfiles_chef SET ubicacion = 'Mejicanos, San Salvador' WHERE usuario_id = 7;
UPDATE perfiles_chef SET ubicacion = 'Santa Tecla, La Libertad' WHERE usuario_id = 8;
UPDATE perfiles_chef SET ubicacion = 'Apopa, San Salvador' WHERE usuario_id = 9;
UPDATE perfiles_chef SET ubicacion = 'Delgado, San Salvador' WHERE usuario_id = 10;
UPDATE perfiles_chef SET ubicacion = 'Ahuachapán, Ahuachapán' WHERE usuario_id = 11;
UPDATE perfiles_chef SET ubicacion = 'Usulután, Usulután' WHERE usuario_id = 12;
UPDATE perfiles_chef SET ubicacion = 'Cojutepeque, Cuscatlán' WHERE usuario_id = 13;
UPDATE perfiles_chef SET ubicacion = 'Zacatecoluca, La Paz' WHERE usuario_id = 14;
UPDATE perfiles_chef SET ubicacion = 'Sensuntepeque, Cabañas' WHERE usuario_id = 15;
UPDATE perfiles_chef SET ubicacion = 'Chalatenango, Chalatenango' WHERE usuario_id = 16;
UPDATE perfiles_chef SET ubicacion = 'La Unión, La Unión' WHERE usuario_id = 17;
UPDATE perfiles_chef SET ubicacion = 'Sonsonate, Sonsonate' WHERE usuario_id = 18;
UPDATE perfiles_chef SET ubicacion = 'San Vicente, San Vicente' WHERE usuario_id = 19;
UPDATE perfiles_chef SET ubicacion = 'Morazán, Morazán' WHERE usuario_id = 20;
UPDATE perfiles_chef SET ubicacion = 'Antiguo Cuscatlán, La Libertad' WHERE usuario_id = 21;
UPDATE perfiles_chef SET ubicacion = 'Ilopango, San Salvador' WHERE usuario_id = 22;
UPDATE perfiles_chef SET ubicacion = 'Acajutla, Sonsonate' WHERE usuario_id = 23;
UPDATE perfiles_chef SET ubicacion = 'Colón, La Libertad' WHERE usuario_id = 24;
UPDATE perfiles_chef SET ubicacion = 'Quezaltepeque, La Libertad' WHERE usuario_id = 25;
UPDATE perfiles_chef SET ubicacion = 'Tonacatepeque, San Salvador' WHERE usuario_id = 26;
UPDATE perfiles_chef SET ubicacion = 'Nejapa, San Salvador' WHERE usuario_id = 27;
UPDATE perfiles_chef SET ubicacion = 'Ayutuxtepeque, San Salvador' WHERE usuario_id = 28;
UPDATE perfiles_chef SET ubicacion = 'Cuscatancingo, San Salvador' WHERE usuario_id = 29;
UPDATE perfiles_chef SET ubicacion = 'San Marcos, San Salvador' WHERE usuario_id = 30;
UPDATE perfiles_chef SET ubicacion = 'Santo Tomás, San Salvador' WHERE usuario_id = 31;
UPDATE perfiles_chef SET ubicacion = 'Aguilares, San Salvador' WHERE usuario_id = 32;
UPDATE perfiles_chef SET ubicacion = 'El Paisnal, San Salvador' WHERE usuario_id = 33;
UPDATE perfiles_chef SET ubicacion = 'Guazapa, San Salvador' WHERE usuario_id = 34;
UPDATE perfiles_chef SET ubicacion = 'Opico, La Libertad' WHERE usuario_id = 35;
UPDATE perfiles_chef SET ubicacion = 'Ciudad Arce, La Libertad' WHERE usuario_id = 36;
UPDATE perfiles_chef SET ubicacion = 'Comasagua, La Libertad' WHERE usuario_id = 37;
UPDATE perfiles_chef SET ubicacion = 'Huizúcar, La Libertad' WHERE usuario_id = 38;
UPDATE perfiles_chef SET ubicacion = 'Jayaque, La Libertad' WHERE usuario_id = 39;
UPDATE perfiles_chef SET ubicacion = 'Jicalapa, La Libertad' WHERE usuario_id = 40;
UPDATE perfiles_chef SET ubicacion = 'La Libertad, La Libertad' WHERE usuario_id = 41;
UPDATE perfiles_chef SET ubicacion = 'Nuevo Cuscatlán, La Libertad' WHERE usuario_id = 42;
UPDATE perfiles_chef SET ubicacion = 'San José Villanueva, La Libertad' WHERE usuario_id = 43;
UPDATE perfiles_chef SET ubicacion = 'Talnique, La Libertad' WHERE usuario_id = 44;
UPDATE perfiles_chef SET ubicacion = 'Tamanique, La Libertad' WHERE usuario_id = 45;
UPDATE perfiles_chef SET ubicacion = 'Teotepeque, La Libertad' WHERE usuario_id = 46;
UPDATE perfiles_chef SET ubicacion = 'Tepecoyo, La Libertad' WHERE usuario_id = 47;
UPDATE perfiles_chef SET ubicacion = 'Zaragoza, La Libertad' WHERE usuario_id = 48;
UPDATE perfiles_chef SET ubicacion = 'Chalchuapa, Santa Ana' WHERE usuario_id = 49;
UPDATE perfiles_chef SET ubicacion = 'Coatepeque, Santa Ana' WHERE usuario_id = 50;
UPDATE perfiles_chef SET ubicacion = 'El Congo, Santa Ana' WHERE usuario_id = 51;
UPDATE perfiles_chef SET ubicacion = 'El Porvenir, Santa Ana' WHERE usuario_id = 52;

-- Mensaje de confirmación
SELECT 'Ubicaciones de chefs actualizadas con municipios y departamentos de El Salvador' as mensaje;

-- Verificar las actualizaciones
SELECT u.nombre, pc.ubicacion, pc.especialidad 
FROM usuarios u 
JOIN perfiles_chef pc ON u.id = pc.usuario_id 
WHERE u.tipo_usuario = 'chef' 
ORDER BY u.id 
LIMIT 10;