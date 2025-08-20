-- Continuación del script de datos ficticios - Parte 2
-- Recetas destacadas para el resto de los chefs

USE la_delicatesse;

-- Continuar insertando recetas destacadas
INSERT INTO recetas (chef_id, titulo, descripcion, ingredientes, instrucciones, tiempo_preparacion, dificultad, precio, imagen, fecha_publicacion, activa) VALUES
-- Receta de Hiroshi Tanaka (Cocina Asiática)
(5, 'Sushi Omakase Premium', 'Selección de sushi premium estilo omakase con pescados de temporada. Incluye técnicas tradicionales de corte y preparación del arroz shari.', 'Arroz sushi, vinagre de arroz, azúcar, sal, atún bluefin, salmón noruego, pargo, pulpo, wasabi fresco, jengibre encurtido, nori, salsa de soja', '1. Preparar arroz shari con vinagre. 2. Cortar pescado con técnica yanagiba. 3. Formar nigiri con presión correcta. 4. Servir inmediatamente con wasabi fresco. 5. Acompañar con jengibre y soja de calidad.', 45, 'difícil', 45.99, 'recipe_6_final_1751080309.jpg', '2024-05-30 12:20:00', 1),
-- Receta de Carlos Mendoza (Cocina Mexicana)
(6, 'Mole Poblano Tradicional', 'El auténtico mole poblano con más de 20 ingredientes, preparado según la receta ancestral de Puebla. Un platillo que representa la complejidad de la cocina mexicana.', 'Chiles mulato, ancho, chipotle, pasilla, tomate, cebolla, ajo, almendras, cacahuates, ajonjolí, canela, clavo, pimienta, chocolate, pollo, tortillas', '1. Tostar y desvenar chiles. 2. Freír ingredientes por separado. 3. Moler en metate tradicional. 4. Cocinar a fuego lento 2 horas. 5. Agregar chocolate al final. 6. Servir con pollo y tortillas calientes.', 240, 'difícil', 38.99, 'recipe_7_final_1751080666.jpg', '2024-06-05 16:45:00', 1),
-- Receta de Isabella Rodriguez (Repostería)
(7, 'Macarons Franceses de Lavanda', 'Delicados macarons franceses con sabor a lavanda y ganache de chocolate blanco. Técnica perfecta para lograr la textura ideal y el "pie" característico.', 'Harina de almendra, azúcar glass, claras de huevo, azúcar, colorante violeta, lavanda seca, chocolate blanco, crema, mantequilla', '1. Tamizar harina de almendra y azúcar glass. 2. Hacer merengue francés. 3. Macaronage hasta punto letra. 4. Formar discos y reposar. 5. Hornear con vapor. 6. Rellenar con ganache de lavanda.', 120, 'difícil', 28.99, 'recipe_8_final_1751081093.jpg', '2024-06-10 14:30:00', 1),
-- Receta de Jean-Pierre Laurent (Cocina Francesa)
(8, 'Bouillabaisse Marseillaise', 'La auténtica bouillabaisse de Marsella con pescados mediterráneos y rouille tradicional. Preparada según la receta protegida de la Charte de la Bouillabaisse.', 'Pescado de roca, rape, dorada, langostinos, mejillones, tomate, cebolla, hinojo, azafrán, aceite de oliva, ajo, pan, pimentón', '1. Preparar fumet con espinas de pescado. 2. Sofreír verduras con azafrán. 3. Agregar pescados por orden de cocción. 4. Preparar rouille con ajo y pimentón. 5. Servir con pan tostado y rouille.', 90, 'intermedio', 42.99, NULL, '2024-06-15 11:15:00', 1),
-- Receta de Mei Chen (Cocina Asiática)
(9, 'Dim Sum Variado Tradicional', 'Selección de dim sum tradicional cantonés incluyendo har gow, siu mai y char siu bao. Técnicas de vapor y masa perfectas.', 'Harina de trigo, fécula de tapioca, camarones, cerdo, cebollín, jengibre, salsa de soja, aceite de sésamo, azúcar, vino de arroz', '1. Preparar masas translúcidas. 2. Hacer rellenos con técnicas específicas. 3. Formar dim sum con pliegues tradicionales. 4. Cocinar al vapor en cestas de bambú. 5. Servir caliente con salsas.', 75, 'intermedio', 26.99, NULL, '2024-06-20 09:30:00', 1),
-- Receta de Antonio Silva (Parrilladas)
(10, 'Picanha Brasileña a la Parrilla', 'La auténtica picanha brasileña con sal gruesa, cocinada en parrilla de carbón. Técnica tradicional del sur de Brasil.', 'Picanha de 1.5kg, sal gruesa, carbón, farofa, vinagrete, pão de açúcar, cerveja gelada', '1. Cortar picanha en el sentido de la fibra. 2. Salar con sal gruesa 30 min antes. 3. Asar en parrilla bien caliente. 4. Cortar en fatias finas. 5. Servir con farofa y vinagrete tradicional.', 60, 'fácil', 35.99, NULL, '2024-06-25 17:20:00', 1),
-- Receta de Emma Thompson (Cocina Saludable)
(11, 'Bowl Buddha Nutritivo', 'Bowl completo con superalimentos, proteínas vegetales y dressing de tahini. Perfecto equilibrio nutricional y sabores frescos.', 'Quinoa, kale, aguacate, garbanzos, remolacha, zanahoria, semillas de chía, tahini, limón, aceite de oliva, miel, jengibre', '1. Cocinar quinoa y garbanzos. 2. Preparar vegetales frescos y asados. 3. Hacer dressing de tahini con limón. 4. Componer bowl con colores balanceados. 5. Terminar con semillas y dressing.', 30, 'fácil', 18.99, NULL, '2024-06-30 13:45:00', 1),
-- Receta de Giuseppe Rossi (Cocina Italiana)
(12, 'Osso Buco alla Milanese', 'El tradicional osso buco milanés con gremolata y risotto amarillo. Cocción lenta que logra la textura perfecta.', 'Jarrete de ternera, cebolla, zanahoria, apio, vino blanco, caldo de carne, tomate, limón, ajo, perejil, azafrán, arroz', '1. Enharinar y dorar los jarretes. 2. Sofreír sofrito de verduras. 3. Agregar vino y caldo. 4. Cocinar a fuego lento 2 horas. 5. Preparar gremolata. 6. Servir con risotto al azafrán.', 150, 'intermedio', 48.99, NULL, '2024-07-05 15:10:00', 1),
-- Receta de Sakura Yamamoto (Cocina Asiática)
(13, 'Ramen Tonkotsu Artesanal', 'Ramen tonkotsu con caldo de 24 horas, chashu, huevo marinado y vegetales frescos. La esencia del ramen japonés.', 'Huesos de cerdo, miso, fideos ramen, panceta de cerdo, huevos, cebollín, nori, brotes de bambú, ajo negro, aceite de chile', '1. Hervir huesos 24 horas para caldo cremoso. 2. Preparar chashu marinado. 3. Cocinar huevos 6 minutos y marinar. 4. Cocinar fideos al dente. 5. Montar ramen con todos los elementos.', 1440, 'difícil', 22.99, NULL, '2024-07-10 10:25:00', 1),
-- Receta de Diego Fernandez (Cocina Mexicana)
(14, 'Tacos al Pastor Auténticos', 'Tacos al pastor con trompo tradicional, marinada especial y piña asada. La esencia del taco mexicano.', 'Carne de cerdo, chiles guajillo, achiote, piña, cebolla, cilantro, tortillas de maíz, salsa verde, salsa roja', '1. Marinar carne con chiles y especias. 2. Armar trompo tradicional. 3. Asar en trompo vertical. 4. Cortar carne fina con piña. 5. Servir en tortillas calientes con salsas.', 480, 'intermedio', 16.99, NULL, '2024-07-15 18:40:00', 1),
-- Receta de Amélie Moreau (Cocina Francesa)
(15, 'Soufflé au Grand Marnier', 'Soufflé clásico francés con Grand Marnier, ligero y aromático. Técnica perfecta para lograr la altura ideal.', 'Huevos, azúcar, harina, leche, mantequilla, Grand Marnier, vainilla, azúcar glass', '1. Preparar crema pastelera base. 2. Batir claras a punto de nieve. 3. Incorporar con movimientos envolventes. 4. Hornear sin abrir el horno. 5. Servir inmediatamente con azúcar glass.', 45, 'difícil', 24.99, NULL, '2024-07-20 16:55:00', 1),
-- Receta de Raj Patel (Cocina Internacional)
(16, 'Curry de Cordero Kashmiri', 'Curry aromático de cordero con especias de Kashmir, yogur y almendras. Cocción lenta que desarrolla sabores complejos.', 'Cordero, yogur, cebolla, jengibre, ajo, garam masala, cúrcuma, comino, cardamomo, canela, almendras, azafrán, ghee', '1. Marinar cordero en yogur y especias. 2. Dorar carne en ghee. 3. Sofreír cebolla hasta dorada. 4. Agregar especias y cocinar lentamente. 5. Terminar con almendras y azafrán.', 120, 'intermedio', 34.99, NULL, '2024-07-25 12:30:00', 1),
-- Receta de Olivia Martinez (Cocina Internacional)
(17, 'BBQ Ribs Estilo Kansas City', 'Costillas de cerdo con rub seco y salsa BBQ dulce, ahumadas lentamente. El estilo clásico americano.', 'Costillas de cerdo, azúcar morena, pimentón, comino, ajo en polvo, mostaza en polvo, salsa BBQ, miel, vinagre', '1. Aplicar rub seco 4 horas antes. 2. Ahumar a 110°C por 6 horas. 3. Envolver en papel aluminio. 4. Continuar cocción 2 horas más. 5. Glasear con salsa BBQ al final.', 480, 'intermedio', 29.99, NULL, '2024-07-30 14:15:00', 1),
-- Receta de Klaus Mueller (Cocina Internacional)
(18, 'Sauerbraten Tradicional Alemán', 'Asado alemán marinado en vinagre con especias, acompañado de spätzle y col roja. Tradición culinaria alemana.', 'Carne de res, vinagre, vino tinto, cebolla, zanahoria, laurel, enebro, clavo, canela, pan de jengibre, spätzle', '1. Marinar carne 3 días en vinagre y especias. 2. Dorar y asar lentamente. 3. Preparar salsa con marinada. 4. Hacer spätzle frescos. 5. Servir con col roja agridulce.', 4320, 'difícil', 36.99, NULL, '2024-08-05 11:50:00', 1),
-- Receta de Lucia Bianchi (Cocina Italiana)
(19, 'Risotto al Nero di Seppia', 'Risotto veneciano con tinta de calamar, cremoso y aromático. Especialidad de la cocina del norte de Italia.', 'Arroz Carnaroli, calamar con tinta, caldo de pescado, vino blanco, cebolla, ajo, perejil, aceite de oliva, mantequilla', '1. Limpiar calamares reservando tinta. 2. Preparar sofrito con cebolla. 3. Tostar arroz y agregar vino. 4. Incorporar tinta y caldo gradualmente. 5. Terminar con mantequilla y perejil.', 40, 'intermedio', 31.99, NULL, '2024-08-10 16:20:00', 1),
-- Receta de Yuki Sato (Cocina Asiática)
(20, 'Tempura de Vegetales de Temporada', 'Tempura ligera y crujiente con vegetales frescos de temporada. Técnica japonesa tradicional con masa perfecta.', 'Harina tempura, agua helada, huevo, calabacín, berenjena, pimiento, shiitake, aceite para freír, salsa tentsuyu', '1. Preparar masa tempura muy fría. 2. Cortar vegetales uniformemente. 3. Freír en aceite a 170°C. 4. Escurrir sobre papel. 5. Servir inmediatamente con salsa tentsuyu.', 25, 'intermedio', 19.99, NULL, '2024-08-15 13:35:00', 1);

-- Insertar más servicios completados para otros chefs
INSERT INTO servicios (cliente_id, chef_id, fecha_servicio, hora_servicio, ubicacion_servicio, numero_comensales, precio_total, estado, descripcion_evento, fecha_solicitud) VALUES
-- Servicios adicionales para completar el historial
(68, 8, '2024-06-18', '20:00:00', 'Salamanca 234, Madrid', 8, 1120.00, 'completado', 'Cena francesa molecular para gourmets', '2024-06-13 15:30:00'),
(69, 9, '2024-07-02', '19:30:00', 'Poblenou 567, Barcelona', 6, 408.00, 'completado', 'Degustación de dim sum tradicional', '2024-06-27 11:45:00'),
(70, 10, '2024-07-20', '18:00:00', 'Lavapiés 890, Madrid', 10, 600.00, 'completado', 'Parrillada brasileña para cumpleaños', '2024-07-15 14:20:00'),
(71, 11, '2024-08-05', '12:00:00', 'Sarrià 123, Barcelona', 4, 220.00, 'completado', 'Almuerzo saludable para ejecutivos', '2024-07-31 09:15:00'),
(72, 12, '2024-08-22', '19:00:00', 'Chamberí 456, Madrid', 12, 1080.00, 'completado', 'Cena italiana tradicional familiar', '2024-08-17 16:30:00');

-- Insertar más calificaciones
INSERT INTO calificaciones (servicio_id, cliente_id, chef_id, puntuacion, titulo, comentario, aspectos_positivos, aspectos_mejora, recomendaria, fecha_calificacion) VALUES
(10, 62, 6, 5, 'Fiesta mexicana auténtica', 'Carlos nos preparó un mole espectacular. La experiencia fue completamente auténtica y deliciosa.', 'Autenticidad, sabores intensos, presentación tradicional', 'Nada que mejorar', 1, '2024-06-06 21:45:00'),
(11, 63, 6, 4, 'Celebración mexicana exitosa', 'Excelente comida mexicana, todos los invitados quedaron satisfechos. Carlos es muy profesional.', 'Variedad de platillos, sazón perfecta, puntualidad', 'Podría incluir más opciones picantes', 1, '2024-07-19 20:30:00'),
(12, 64, 6, 5, 'Cena íntima perfecta', 'Una velada mexicana inolvidable. Los sabores eran auténticos y la presentación impecable.', 'Atención personalizada, calidad excepcional, ambiente', 'Todo perfecto', 1, '2024-08-31 22:15:00'),
(13, 65, 7, 5, 'Taller de repostería increíble', 'Isabella nos enseñó técnicas profesionales mientras disfrutábamos de postres exquisitos.', 'Didáctica excelente, postres deliciosos, muy profesional', 'Nada que mejorar', 1, '2024-06-13 18:30:00'),
(14, 66, 7, 5, 'Macarons perfectos', 'La clase de macarons fue extraordinaria. Isabella domina la técnica a la perfección.', 'Técnica impecable, explicaciones claras, resultados perfectos', 'Todo estuvo excelente', 1, '2024-07-26 17:45:00'),
(15, 67, 7, 4, 'Postres artísticos', 'Los postres de Isabella son verdaderas obras de arte. Sabor y presentación excepcionales.', 'Creatividad, presentación artística, sabores únicos', 'Podría ofrecer más variedad sin gluten', 1, '2024-09-09 19:20:00');

-- Actualizar estadísticas de los chefs
UPDATE perfiles_chef SET 
    calificacion_promedio = 4.8,
    total_servicios = 156
WHERE usuario_id = 3;

UPDATE perfiles_chef SET 
    calificacion_promedio = 4.9,
    total_servicios = 203
WHERE usuario_id = 4;

UPDATE perfiles_chef SET 
    calificacion_promedio = 4.7,
    total_servicios = 134
WHERE usuario_id = 5;

UPDATE perfiles_chef SET 
    calificacion_promedio = 4.6,
    total_servicios = 98
WHERE usuario_id = 6;

UPDATE perfiles_chef SET 
    calificacion_promedio = 4.8,
    total_servicios = 167
WHERE usuario_id = 7;

-- Insertar algunas preferencias de usuarios
INSERT INTO preferencias_usuario (usuario_id, tipo, preferencia, fecha_agregada) VALUES
(53, 'dietary', 'Sin gluten', '2024-03-15 10:30:00'),
(54, 'cuisine', 'Cocina Italiana', '2024-03-16 14:20:00'),
(55, 'dietary', 'Vegetariano', '2024-03-17 16:45:00'),
(56, 'cuisine', 'Cocina Francesa', '2024-03-18 11:15:00'),
(57, 'dietary', 'Sin lactosa', '2024-03-19 09:30:00'),
(58, 'cuisine', 'Cocina Asiática', '2024-03-20 13:50:00'),
(59, 'dietary', 'Vegano', '2024-03-21 15:25:00'),
(60, 'cuisine', 'Cocina Mexicana', '2024-03-22 12:10:00');

-- Insertar algunos chefs favoritos
INSERT INTO chefs_favoritos (cliente_id, chef_id, fecha_agregado) VALUES
(53, 3, '2024-05-16 21:30:00'),
(53, 4, '2024-06-01 10:15:00'),
(54, 3, '2024-06-21 10:15:00'),
(54, 5, '2024-07-01 14:30:00'),
(55, 4, '2024-07-01 21:45:00'),
(56, 4, '2024-05-23 22:00:00'),
(57, 4, '2024-07-01 21:45:00'),
(58, 4, '2024-08-13 23:30:00'),
(59, 5, '2024-05-29 20:30:00'),
(60, 5, '2024-07-16 14:20:00'),
(61, 5, '2024-08-26 22:15:00'),
(62, 6, '2024-06-06 21:45:00'),
(63, 6, '2024-07-19 20:30:00'),
(64, 6, '2024-08-31 22:15:00'),
(65, 7, '2024-06-13 18:30:00'),
(66, 7, '2024-07-26 17:45:00'),
(67, 7, '2024-09-09 19:20:00');

COMMIT;

-- Mensaje de finalización
SELECT 'Datos ficticios insertados correctamente:' as mensaje,
       '50 chefs con perfiles completos' as chefs,
       '30 clientes registrados' as clientes,
       'Servicios completados con reseñas' as servicios,
       'Recetas destacadas por especialidad' as recetas;