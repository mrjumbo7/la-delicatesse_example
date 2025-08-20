-- Script para insertar datos ficticios de 50 chefs con perfiles completos
-- Incluye clientes, reseñas, servicios completados y recetas destacadas

USE la_delicatesse;

-- Insertar 50 chefs ficticios
INSERT INTO usuarios (nombre, email, password, telefono, direccion, fecha_nacimiento, tipo_usuario, fecha_registro, activo) VALUES
('Marco Antonelli', 'marco.antonelli@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-612-345-678', 'Calle Roma 15, Madrid', '1985-03-12', 'chef', '2024-01-15 10:30:00', 1),
('Sophie Dubois', 'sophie.dubois@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+33-145-678-901', 'Rue de la Paix 25, París', '1988-07-22', 'chef', '2024-01-16 11:15:00', 1),
('Hiroshi Tanaka', 'hiroshi.tanaka@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-1234-5678', 'Shibuya 2-3-1, Tokio', '1982-11-08', 'chef', '2024-01-17 09:45:00', 1),
('Carlos Mendoza', 'carlos.mendoza@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+52-55-1234-5678', 'Av. Reforma 123, Ciudad de México', '1990-05-15', 'chef', '2024-01-18 14:20:00', 1),
('Isabella Rodriguez', 'isabella.rodriguez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-678-901-234', 'Gran Vía 45, Barcelona', '1987-09-03', 'chef', '2024-01-19 16:30:00', 1),
('Jean-Pierre Laurent', 'jeanpierre.laurent@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+33-156-789-012', 'Boulevard Saint-Germain 78, París', '1983-12-18', 'chef', '2024-01-20 12:45:00', 1),
('Mei Chen', 'mei.chen@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+86-138-0013-8000', 'Nanjing Road 456, Shanghai', '1991-02-28', 'chef', '2024-01-21 08:15:00', 1),
('Antonio Silva', 'antonio.silva@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+55-11-98765-4321', 'Rua Augusta 789, São Paulo', '1986-06-10', 'chef', '2024-01-22 15:00:00', 1),
('Emma Thompson', 'emma.thompson@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+44-20-7946-0958', 'Baker Street 221B, Londres', '1989-04-25', 'chef', '2024-01-23 13:30:00', 1),
('Giuseppe Rossi', 'giuseppe.rossi@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+39-06-1234-5678', 'Via del Corso 100, Roma', '1984-08-14', 'chef', '2024-01-24 10:45:00', 1),
('Sakura Yamamoto', 'sakura.yamamoto@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-8765-4321', 'Ginza 4-5-6, Tokio', '1992-01-07', 'chef', '2024-01-25 11:20:00', 1),
('Diego Fernandez', 'diego.fernandez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+52-33-2345-6789', 'Av. Chapultepec 567, Guadalajara', '1988-10-12', 'chef', '2024-01-26 09:10:00', 1),
('Amélie Moreau', 'amelie.moreau@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+33-142-345-678', 'Champs-Élysées 89, París', '1985-12-30', 'chef', '2024-01-27 14:55:00', 1),
('Raj Patel', 'raj.patel@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+91-98765-43210', 'Marine Drive 234, Mumbai', '1987-03-18', 'chef', '2024-01-28 16:40:00', 1),
('Olivia Martinez', 'olivia.martinez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+1-555-123-4567', '5th Avenue 678, Nueva York', '1990-07-05', 'chef', '2024-01-29 12:25:00', 1),
('Klaus Mueller', 'klaus.mueller@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+49-30-12345678', 'Unter den Linden 45, Berlín', '1983-09-21', 'chef', '2024-01-30 08:50:00', 1),
('Lucia Bianchi', 'lucia.bianchi@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+39-02-3456-7890', 'Via Montenapoleone 12, Milán', '1991-11-16', 'chef', '2024-01-31 15:35:00', 1),
('Yuki Sato', 'yuki.sato@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-2468-1357', 'Harajuku 1-2-3, Tokio', '1989-05-09', 'chef', '2024-02-01 13:15:00', 1),
('Pablo Gutierrez', 'pablo.gutierrez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+54-11-4567-8901', 'Av. Corrientes 890, Buenos Aires', '1986-08-27', 'chef', '2024-02-02 10:05:00', 1),
('Charlotte Wilson', 'charlotte.wilson@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+44-161-234-5678', 'Oxford Street 345, Manchester', '1988-12-04', 'chef', '2024-02-03 11:50:00', 1),
('Francesco Conti', 'francesco.conti@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+39-055-678-9012', 'Ponte Vecchio 67, Florencia', '1984-04-13', 'chef', '2024-02-04 14:30:00', 1),
('Akiko Nakamura', 'akiko.nakamura@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-3579-2468', 'Kyoto Station 8-9-0, Kyoto', '1992-06-20', 'chef', '2024-02-05 09:25:00', 1),
('Miguel Santos', 'miguel.santos@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+351-21-345-6789', 'Rua Augusta 123, Lisboa', '1987-01-31', 'chef', '2024-02-06 16:10:00', 1),
('Camille Dubois', 'camille.dubois@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+33-147-890-123', 'Rue Rivoli 456, París', '1990-09-08', 'chef', '2024-02-07 12:45:00', 1),
('Arjun Sharma', 'arjun.sharma@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+91-11-2345-6789', 'Connaught Place 789, Nueva Delhi', '1985-11-25', 'chef', '2024-02-08 08:20:00', 1),
('Sofia Andersson', 'sofia.andersson@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+46-8-123-456-78', 'Gamla Stan 234, Estocolmo', '1989-03-14', 'chef', '2024-02-09 15:55:00', 1),
('Matteo Romano', 'matteo.romano@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+39-081-567-8901', 'Via Toledo 345, Nápoles', '1991-07-02', 'chef', '2024-02-10 13:40:00', 1),
('Kenji Watanabe', 'kenji.watanabe@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-4681-3579', 'Osaka Castle 5-6-7, Osaka', '1986-12-11', 'chef', '2024-02-11 10:15:00', 1),
('Elena Popov', 'elena.popov@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+7-495-123-45-67', 'Red Square 678, Moscú', '1988-05-29', 'chef', '2024-02-12 11:30:00', 1),
('James Anderson', 'james.anderson@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+1-416-234-5678', 'Queen Street 890, Toronto', '1984-10-17', 'chef', '2024-02-13 14:05:00', 1),
('Valentina Rossi', 'valentina.rossi@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+39-041-678-9012', 'Piazza San Marco 123, Venecia', '1990-02-06', 'chef', '2024-02-14 09:50:00', 1),
('Takeshi Kimura', 'takeshi.kimura@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-5792-4681', 'Nagoya Station 7-8-9, Nagoya', '1987-08-23', 'chef', '2024-02-15 16:25:00', 1),
('Natasha Volkov', 'natasha.volkov@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+7-812-345-67-89', 'Nevsky Prospect 456, San Petersburgo', '1989-04-12', 'chef', '2024-02-16 12:10:00', 1),
('David Kim', 'david.kim@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+82-2-1234-5678', 'Gangnam District 789, Seúl', '1985-09-19', 'chef', '2024-02-17 08:35:00', 1),
('Chiara Ferrari', 'chiara.ferrari@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+39-011-890-1234', 'Via Po 234, Turín', '1991-01-28', 'chef', '2024-02-18 15:20:00', 1),
('Ryo Suzuki', 'ryo.suzuki@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-6803-5792', 'Fukuoka Tower 0-1-2, Fukuoka', '1988-06-15', 'chef', '2024-02-19 13:45:00', 1),
('Anastasia Petrov', 'anastasia.petrov@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+7-383-456-78-90', 'Lenin Square 567, Novosibirsk', '1986-11-03', 'chef', '2024-02-20 10:55:00', 1),
('Michael O\'Connor', 'michael.oconnor@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+353-1-234-5678', 'Temple Bar 345, Dublín', '1990-03-21', 'chef', '2024-02-21 14:40:00', 1),
('Giulia Marino', 'giulia.marino@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+39-095-123-4567', 'Via Etnea 678, Catania', '1987-07-18', 'chef', '2024-02-22 11:25:00', 1),
('Hana Tanaka', 'hana.tanaka@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-7914-6803', 'Sapporo Snow 3-4-5, Sapporo', '1992-12-09', 'chef', '2024-02-23 09:15:00', 1),
('Viktor Kozlov', 'viktor.kozlov@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+7-343-567-89-01', 'Yeltsin Center 890, Ekaterimburgo', '1984-05-26', 'chef', '2024-02-24 16:00:00', 1),
('Sarah Mitchell', 'sarah.mitchell@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+61-2-9876-5432', 'Opera House 123, Sídney', '1989-08-07', 'chef', '2024-02-25 12:30:00', 1),
('Lorenzo Galli', 'lorenzo.galli@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+39-051-234-5678', 'Piazza Maggiore 456, Bolonia', '1985-10-14', 'chef', '2024-02-26 08:45:00', 1),
('Yui Takahashi', 'yui.takahashi@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-8025-7914', 'Hiroshima Peace 6-7-8, Hiroshima', '1991-04-01', 'chef', '2024-02-27 15:10:00', 1),
('Dmitri Volkov', 'dmitri.volkov@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+7-4212-678-90-12', 'Lenin Street 789, Jabárovsk', '1988-01-22', 'chef', '2024-02-28 13:55:00', 1),
('Rebecca Taylor', 'rebecca.taylor@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+64-9-123-4567', 'Queen Street 234, Auckland', '1986-09-30', 'chef', '2024-02-29 10:20:00', 1),
('Simone Ricci', 'simone.ricci@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+39-070-345-6789', 'Via Roma 567, Cagliari', '1990-06-17', 'chef', '2024-03-01 14:35:00', 1),
('Emi Hayashi', 'emi.hayashi@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+81-90-9136-8025', 'Sendai Castle 9-0-1, Sendai', '1987-11-24', 'chef', '2024-03-02 11:50:00', 1),
('Alexander Petrov', 'alexander.petrov@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+7-8442-789-01-23', 'Volga River 012, Volgogrado', '1983-03-11', 'chef', '2024-03-03 09:05:00', 1),
('Hannah Brown', 'hannah.brown@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+27-21-456-7890', 'Table Mountain 345, Ciudad del Cabo', '1989-12-28', 'chef', '2024-03-04 16:15:00', 1);

-- Insertar perfiles de chef para los 50 chefs
INSERT INTO perfiles_chef (usuario_id, especialidad, experiencia_anos, precio_por_hora, biografia, ubicacion, certificaciones, foto_perfil, calificacion_promedio, total_servicios) VALUES
(3, 'Cocina Italiana', 12, 85.00, 'Chef especializado en auténtica cocina italiana con formación en Roma y Milán. Experto en pastas artesanales, risottos y técnicas tradicionales del norte de Italia.', 'Madrid, España', 'Diploma Culinary Institute of Rome, Certificación Pasta Artesanal', 'profile_3_1751080747.jpg', 4.8, 156),
(4, 'Cocina Francesa', 15, 120.00, 'Maestro de la alta cocina francesa con experiencia en restaurantes Michelin. Especialista en salsas clásicas, técnicas de confitado y presentación elegante.', 'París, Francia', 'Le Cordon Bleu París, Certificación Sommelier Nivel 2', 'profile_4_1751080857.jpg', 4.9, 203),
(5, 'Cocina Asiática', 10, 75.00, 'Chef experto en cocina japonesa tradicional y fusión asiática. Maestro en sushi, tempura y técnicas de fermentación oriental.', 'Tokio, Japón', 'Tokyo Culinary Academy, Certificación Sushi Master', 'profile_5_1753721943.jpg', 4.7, 134),
(6, 'Cocina Mexicana', 8, 65.00, 'Especialista en cocina mexicana tradicional y contemporánea. Experto en moles, técnicas prehispánicas y maridajes con mezcal.', 'Ciudad de México, México', 'Instituto Culinario de México, Certificación Mole Tradicional', 'profile_6_1751037558.jpg', 4.6, 98),
(7, 'Repostería', 11, 70.00, 'Maestra pastelera especializada en repostería francesa y española. Experta en chocolatería, macarons y tartas artísticas.', 'Barcelona, España', 'École de Pâtisserie París, Certificación Chocolatier', 'profile_7_1751075273.jpg', 4.8, 167),
(8, 'Cocina Francesa', 18, 140.00, 'Chef ejecutivo con experiencia en restaurantes estrella Michelin. Especialista en cocina molecular y técnicas de vanguardia.', 'París, Francia', 'Institut Paul Bocuse, Certificación Cocina Molecular', 'profile_8_1755646598.jpg', 4.9, 245),
(9, 'Cocina Asiática', 9, 68.00, 'Experta en cocina china regional y dim sum. Especialista en técnicas de wok y cocina al vapor tradicional.', 'Shanghai, China', 'Shanghai Culinary Institute, Certificación Dim Sum Master', 'profile_9_1751036366.jpg', 4.5, 112),
(10, 'Parrilladas', 7, 60.00, 'Maestro parrillero especializado en carnes sudamericanas. Experto en técnicas de asado argentino y brasileño.', 'São Paulo, Brasil', 'Academia Brasileña de Parrilla, Certificación Asador Profesional', 'profile_10_1751036463.jpg', 4.7, 89),
(11, 'Cocina Saludable', 6, 55.00, 'Chef especializada en cocina saludable y nutritiva. Experta en superalimentos, cocina plant-based y dietas especiales.', 'Londres, Reino Unido', 'Institute of Nutritional Cooking, Certificación Plant-Based', 'profile_11_1751079973.jpg', 4.6, 76),
(12, 'Cocina Italiana', 14, 90.00, 'Especialista en cocina del sur de Italia. Maestro en pizzas napolitanas, pasta fresca y cocina siciliana tradicional.', 'Roma, Italia', 'Accademia Italiana della Cucina, Certificación Pizza Napoletana', NULL, 4.8, 178),
(13, 'Cocina Asiática', 11, 72.00, 'Experta en cocina japonesa kaiseki y técnicas de presentación artística. Especialista en ingredientes de temporada.', 'Tokio, Japón', 'Kyoto Culinary Academy, Certificación Kaiseki Master', NULL, 4.7, 145),
(14, 'Cocina Mexicana', 9, 58.00, 'Chef especializado en cocina regional mexicana. Experto en chiles, salsas tradicionales y técnicas ancestrales.', 'Guadalajara, México', 'Universidad Gastronómica Mexicana, Certificación Salsas Tradicionales', NULL, 4.5, 103),
(15, 'Cocina Francesa', 16, 125.00, 'Maestra en patisserie francesa y chocolatería artesanal. Especialista en técnicas clásicas y creaciones modernas.', 'París, Francia', 'École Ferrandi París, Certificación Maître Chocolatier', NULL, 4.9, 198),
(16, 'Cocina Internacional', 13, 80.00, 'Chef especializado en fusión india-europea. Experto en especias, curries y técnicas tandoor.', 'Mumbai, India', 'Indian Culinary Institute, Certificación Spice Master', NULL, 4.6, 156),
(17, 'Cocina Internacional', 10, 75.00, 'Especialista en cocina americana contemporánea. Experta en BBQ, comfort food y técnicas de ahumado.', 'Nueva York, EE.UU.', 'Culinary Institute of America, Certificación BBQ Master', NULL, 4.7, 134),
(18, 'Cocina Internacional', 12, 85.00, 'Chef alemán especializado en cocina centroeuropea. Experto en embutidos artesanales y técnicas de conservación.', 'Berlín, Alemania', 'Deutsche Kochschule, Certificación Charcuterie', NULL, 4.6, 167),
(19, 'Cocina Italiana', 8, 65.00, 'Especialista en cocina del norte de Italia. Maestra en risottos, polenta y cocina de montaña.', 'Milán, Italia', 'Scuola di Cucina Italiana, Certificación Risotto Master', NULL, 4.8, 98),
(20, 'Cocina Asiática', 7, 62.00, 'Experta en cocina japonesa moderna. Especialista en ramen artesanal y técnicas de fermentación.', 'Tokio, Japón', 'Ramen Academy Tokyo, Certificación Ramen Master', NULL, 4.5, 87),
(21, 'Cocina Mexicana', 11, 68.00, 'Chef especializado en cocina argentina. Maestro en empanadas, asados y técnicas de parrilla.', 'Buenos Aires, Argentina', 'Instituto Gastronómico Argentino, Certificación Parrillero', NULL, 4.7, 123),
(22, 'Cocina Internacional', 9, 70.00, 'Especialista en cocina británica moderna. Experta en fish & chips, pies y técnicas de horneado.', 'Manchester, Reino Unido', 'British Culinary Institute, Certificación Traditional British', NULL, 4.6, 109),
(23, 'Cocina Italiana', 15, 95.00, 'Maestro en cocina toscana tradicional. Experto en carnes a la parrilla, vinos y aceites de oliva.', 'Florencia, Italia', 'Accademia del Gusto Toscano, Certificación Sommelier', NULL, 4.9, 189),
(24, 'Cocina Asiática', 6, 58.00, 'Especialista en cocina japonesa de Kyoto. Experta en tofu artesanal, vegetales de temporada y té.', 'Kyoto, Japón', 'Kyoto Traditional Cooking School, Certificación Tea Master', NULL, 4.4, 76),
(25, 'Cocina Internacional', 10, 72.00, 'Chef portugués especializado en mariscos. Experto en bacalao, caldeiradas y vinos del Duero.', 'Lisboa, Portugal', 'Escola de Hotelaria de Lisboa, Certificación Mariscos', NULL, 4.7, 134),
(26, 'Cocina Francesa', 14, 110.00, 'Especialista en cocina provenzal. Maestra en hierbas aromáticas, ratatouille y técnicas mediterráneas.', 'París, Francia', 'École de Cuisine Provençale, Certificación Herbes de Provence', NULL, 4.8, 176),
(27, 'Cocina Internacional', 8, 65.00, 'Chef indio especializado en cocina del norte. Experto en tandoor, naan y especias aromáticas.', 'Nueva Delhi, India', 'Delhi Culinary Academy, Certificación Tandoor Master', NULL, 4.6, 98),
(28, 'Cocina Internacional', 11, 78.00, 'Especialista en cocina escandinava. Experta en pescados ahumados, técnicas de conservación nórdica.', 'Estocolmo, Suecia', 'Nordic Culinary Institute, Certificación Nordic Cuisine', NULL, 4.7, 145),
(29, 'Cocina Italiana', 13, 88.00, 'Maestro en cocina napolitana. Experto en pizza al taglio, mozzarella di bufala y cocina de Campania.', 'Nápoles, Italia', 'Università della Pizza, Certificación Pizzaiolo Napoletano', NULL, 4.8, 167),
(30, 'Cocina Asiática', 9, 70.00, 'Especialista en cocina japonesa de Osaka. Experto en okonomiyaki, takoyaki y street food japonés.', 'Osaka, Japón', 'Osaka Culinary School, Certificación Street Food Master', NULL, 4.6, 112),
(31, 'Cocina Internacional', 12, 82.00, 'Chef rusa especializada en cocina eslava. Experta en borscht, blinis y técnicas de fermentación.', 'Moscú, Rusia', 'Moscow Culinary Institute, Certificación Slavic Cuisine', NULL, 4.7, 156),
(32, 'Cocina Internacional', 7, 63.00, 'Especialista en cocina canadiense. Experto en maple syrup, poutine y cocina de los bosques.', 'Toronto, Canadá', 'Canadian Culinary Federation, Certificación Forest Cuisine', NULL, 4.5, 89),
(33, 'Cocina Italiana', 16, 98.00, 'Maestra en cocina veneciana. Especialista en risotto al nero di seppia, cicchetti y vinos del Véneto.', 'Venecia, Italia', 'Scuola di Cucina Veneziana, Certificación Cicchetti Master', NULL, 4.9, 201),
(34, 'Cocina Asiática', 10, 74.00, 'Chef japonés especializado en cocina de Nagoya. Experto en miso katsu, hitsumabushi y cocina regional.', 'Nagoya, Japón', 'Nagoya Culinary Academy, Certificación Regional Japanese', NULL, 4.6, 123),
(35, 'Cocina Internacional', 14, 86.00, 'Especialista en cocina rusa moderna. Experta en caviar, vodka y técnicas de conservación en frío.', 'San Petersburgo, Rusia', 'St. Petersburg Culinary Institute, Certificación Caviar Expert', NULL, 4.8, 178),
(36, 'Cocina Asiática', 8, 66.00, 'Chef coreano especializado en kimchi y fermentados. Experto en BBQ coreano y banchan tradicional.', 'Seúl, Corea del Sur', 'Seoul Culinary Academy, Certificación Kimchi Master', NULL, 4.5, 98),
(37, 'Cocina Italiana', 11, 79.00, 'Especialista en cocina piamontesa. Maestra en trufas, agnolotti y vinos de Piamonte.', 'Turín, Italia', 'Università di Scienze Gastronomiche, Certificación Truffle Expert', NULL, 4.7, 134),
(38, 'Cocina Asiática', 9, 68.00, 'Experto en cocina japonesa de Fukuoka. Especialista en ramen tonkotsu, mentaiko y cocina de Kyushu.', 'Fukuoka, Japón', 'Fukuoka Ramen Academy, Certificación Tonkotsu Master', NULL, 4.6, 109),
(39, 'Cocina Internacional', 13, 84.00, 'Chef rusa especializada en cocina siberiana. Experta en pescados de río, técnicas de ahumado en frío.', 'Novosibirsk, Rusia', 'Siberian Culinary Institute, Certificación Cold Smoking', NULL, 4.7, 167),
(40, 'Cocina Internacional', 6, 59.00, 'Especialista en cocina irlandesa tradicional. Experto en estofados, soda bread y whiskey irlandés.', 'Dublín, Irlanda', 'Dublin Culinary School, Certificación Irish Traditional', NULL, 4.4, 78),
(41, 'Cocina Italiana', 12, 85.00, 'Maestra en cocina siciliana. Especialista en arancini, caponata y dulces tradicionales sicilianos.', 'Catania, Italia', 'Scuola di Cucina Siciliana, Certificación Pasticceria Siciliana', NULL, 4.8, 156),
(42, 'Cocina Asiática', 7, 61.00, 'Especialista en cocina japonesa de Hokkaido. Experta en mariscos frescos, kaisendon y cocina de invierno.', 'Sapporo, Japón', 'Hokkaido Seafood Academy, Certificación Seafood Master', NULL, 4.5, 87),
(43, 'Cocina Internacional', 15, 92.00, 'Chef ruso especializado en cocina de los Urales. Experto en carnes de caza, setas silvestres y conservas.', 'Ekaterimburgo, Rusia', 'Ural Culinary Institute, Certificación Game Meat', NULL, 4.8, 189),
(44, 'Cocina Internacional', 10, 76.00, 'Especialista en cocina australiana moderna. Experta en barbacoa australiana, mariscos y vinos locales.', 'Sídney, Australia', 'Australian Culinary Federation, Certificación Aussie BBQ', NULL, 4.6, 123),
(45, 'Cocina Italiana', 9, 71.00, 'Chef especializado en cocina emiliana. Maestro en tortellini, parmigiano reggiano y aceto balsamico.', 'Bolonia, Italia', 'Accademia della Cucina Emiliana, Certificación Pasta Fresca', NULL, 4.7, 109),
(46, 'Cocina Asiática', 8, 64.00, 'Especialista en cocina japonesa de Hiroshima. Experta en okonomiyaki, ostras y cocina de Chugoku.', 'Hiroshima, Japón', 'Hiroshima Culinary School, Certificación Okonomiyaki Master', NULL, 4.5, 98),
(47, 'Cocina Internacional', 11, 80.00, 'Chef ruso especializado en cocina del Extremo Oriente. Experto en pescados del Pacífico y cocina asiático-rusa.', 'Jabárovsk, Rusia', 'Far East Culinary Institute, Certificación Pacific Seafood', NULL, 4.7, 134),
(48, 'Cocina Internacional', 12, 83.00, 'Especialista en cocina neozelandesa. Experta en cordero, mariscos y técnicas de cocina maorí.', 'Auckland, Nueva Zelanda', 'New Zealand Culinary Institute, Certificación Maori Cuisine', NULL, 4.6, 156),
(49, 'Cocina Italiana', 14, 89.00, 'Maestro en cocina sarda. Especialista en quesos pecorino, cordero y técnicas de cocina mediterránea.', 'Cagliari, Italia', 'Accademia Sarda di Cucina, Certificación Pecorino Master', NULL, 4.8, 178),
(50, 'Cocina Asiática', 6, 57.00, 'Especialista en cocina japonesa del noreste. Experta en gyoza, sake y cocina de Tohoku.', 'Sendai, Japón', 'Tohoku Culinary Academy, Certificación Sake Pairing', NULL, 4.4, 76),
(51, 'Cocina Internacional', 17, 95.00, 'Chef ruso especializado en cocina del Volga. Experto en esturión, caviar y técnicas de río.', 'Volgogrado, Rusia', 'Volga Culinary Institute, Certificación River Fish', NULL, 4.9, 212),
(52, 'Cocina Internacional', 13, 87.00, 'Especialista en cocina sudafricana. Experta en braai, biltong y fusión africana-europea.', 'Ciudad del Cabo, Sudáfrica', 'South African Culinary Academy, Certificación Braai Master', NULL, 4.7, 167);

-- Insertar 30 clientes ficticios
INSERT INTO usuarios (nombre, email, password, telefono, direccion, fecha_nacimiento, tipo_usuario, fecha_registro, activo) VALUES
('Ana García', 'ana.garcia@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-666-111-222', 'Calle Alcalá 123, Madrid', '1992-05-15', 'cliente', '2024-03-15 10:30:00', 1),
('Luis Martínez', 'luis.martinez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-677-333-444', 'Gran Vía 456, Barcelona', '1988-09-22', 'cliente', '2024-03-16 14:20:00', 1),
('Carmen López', 'carmen.lopez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-688-555-666', 'Paseo de Gracia 789, Barcelona', '1985-12-08', 'cliente', '2024-03-17 16:45:00', 1),
('Roberto Silva', 'roberto.silva@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-699-777-888', 'Calle Serrano 234, Madrid', '1990-03-14', 'cliente', '2024-03-18 11:15:00', 1),
('María Fernández', 'maria.fernandez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-611-999-000', 'Ramblas 567, Barcelona', '1993-07-28', 'cliente', '2024-03-19 09:30:00', 1),
('David Rodríguez', 'david.rodriguez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-622-111-333', 'Calle Mayor 890, Madrid', '1987-11-05', 'cliente', '2024-03-20 13:50:00', 1),
('Laura Jiménez', 'laura.jimenez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-633-444-555', 'Diagonal 123, Barcelona', '1991-01-19', 'cliente', '2024-03-21 15:25:00', 1),
('Carlos Moreno', 'carlos.moreno@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-644-666-777', 'Puerta del Sol 456, Madrid', '1989-06-12', 'cliente', '2024-03-22 12:10:00', 1),
('Elena Ruiz', 'elena.ruiz@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-655-888-999', 'Sagrada Familia 789, Barcelona', '1994-04-03', 'cliente', '2024-03-23 08:40:00', 1),
('Javier Herrera', 'javier.herrera@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-666-000-111', 'Retiro 234, Madrid', '1986-10-17', 'cliente', '2024-03-24 17:55:00', 1),
('Patricia Vega', 'patricia.vega@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-677-222-333', 'Eixample 567, Barcelona', '1992-08-26', 'cliente', '2024-03-25 14:35:00', 1),
('Miguel Torres', 'miguel.torres@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-688-444-555', 'Malasaña 890, Madrid', '1988-02-09', 'cliente', '2024-03-26 10:20:00', 1),
('Cristina Ramos', 'cristina.ramos@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-699-666-777', 'Gràcia 123, Barcelona', '1990-12-31', 'cliente', '2024-03-27 16:05:00', 1),
('Antonio Delgado', 'antonio.delgado@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-611-888-999', 'Chueca 456, Madrid', '1985-05-24', 'cliente', '2024-03-28 11:45:00', 1),
('Raquel Castro', 'raquel.castro@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-622-000-111', 'Barceloneta 789, Barcelona', '1993-09-16', 'cliente', '2024-03-29 13:30:00', 1),
('Fernando Ortega', 'fernando.ortega@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-633-222-333', 'Salamanca 234, Madrid', '1987-07-07', 'cliente', '2024-03-30 09:15:00', 1),
('Silvia Mendez', 'silvia.mendez@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-644-444-555', 'Poblenou 567, Barcelona', '1991-11-13', 'cliente', '2024-03-31 15:50:00', 1),
('Andrés Vargas', 'andres.vargas@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-655-666-777', 'Lavapiés 890, Madrid', '1989-01-28', 'cliente', '2024-04-01 12:25:00', 1),
('Mónica Peña', 'monica.pena@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-666-888-999', 'Sarrià 123, Barcelona', '1994-06-20', 'cliente', '2024-04-02 08:10:00', 1),
('Sergio Blanco', 'sergio.blanco@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-677-000-111', 'Chamberí 456, Madrid', '1986-03-11', 'cliente', '2024-04-03 14:40:00', 1),
('Beatriz Romero', 'beatriz.romero@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-688-222-333', 'Sant Antoni 789, Barcelona', '1992-10-04', 'cliente', '2024-04-04 16:55:00', 1),
('Álvaro Guerrero', 'alvaro.guerrero@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-699-444-555', 'Arganzuela 234, Madrid', '1988-12-18', 'cliente', '2024-04-05 10:30:00', 1),
('Nuria Iglesias', 'nuria.iglesias@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-611-666-777', 'Horta 567, Barcelona', '1990-08-01', 'cliente', '2024-04-06 13:15:00', 1),
('Rubén Cabrera', 'ruben.cabrera@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-622-888-999', 'Moncloa 890, Madrid', '1985-04-15', 'cliente', '2024-04-07 11:50:00', 1),
('Pilar Navarro', 'pilar.navarro@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-633-000-111', 'Nou Barris 123, Barcelona', '1993-02-22', 'cliente', '2024-04-08 15:35:00', 1),
('Iván Prieto', 'ivan.prieto@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-644-222-333', 'Tetuán 456, Madrid', '1987-09-08', 'cliente', '2024-04-09 09:20:00', 1),
('Rocío Santana', 'rocio.santana@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-655-444-555', 'Sant Martí 789, Barcelona', '1991-06-29', 'cliente', '2024-04-10 12:45:00', 1),
('Óscar Medina', 'oscar.medina@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-666-666-777', 'Fuencarral 234, Madrid', '1989-11-12', 'cliente', '2024-04-11 14:10:00', 1),
('Inmaculada León', 'inmaculada.leon@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-677-888-999', 'Les Corts 567, Barcelona', '1994-01-06', 'cliente', '2024-04-12 16:25:00', 1),
('Emilio Aguilar', 'emilio.aguilar@email.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '+34-688-000-111', 'Carabanchel 890, Madrid', '1986-07-23', 'cliente', '2024-04-13 08:55:00', 1);

-- Insertar servicios completados (múltiples servicios por chef)
INSERT INTO servicios (cliente_id, chef_id, fecha_servicio, hora_servicio, ubicacion_servicio, numero_comensales, precio_total, estado, descripcion_evento, fecha_solicitud) VALUES
-- Servicios para Marco Antonelli (Chef ID 3)
(53, 3, '2024-05-15', '19:30:00', 'Calle Alcalá 123, Madrid', 6, 510.00, 'completado', 'Cena italiana para aniversario de bodas', '2024-05-10 14:30:00'),
(54, 3, '2024-06-20', '20:00:00', 'Gran Vía 456, Barcelona', 8, 680.00, 'completado', 'Evento corporativo con menú italiano', '2024-06-15 10:15:00'),
(55, 3, '2024-07-08', '18:00:00', 'Paseo de Gracia 789, Barcelona', 4, 340.00, 'completado', 'Cena romántica con pasta fresca', '2024-07-03 16:45:00'),
-- Servicios para Sophie Dubois (Chef ID 4)
(56, 4, '2024-05-22', '19:00:00', 'Calle Serrano 234, Madrid', 10, 1200.00, 'completado', 'Cena francesa de gala para ejecutivos', '2024-05-17 11:20:00'),
(57, 4, '2024-06-30', '20:30:00', 'Ramblas 567, Barcelona', 6, 720.00, 'completado', 'Celebración familiar con menú francés', '2024-06-25 09:30:00'),
(58, 4, '2024-08-12', '19:30:00', 'Calle Mayor 890, Madrid', 12, 1440.00, 'completado', 'Banquete de boda estilo francés', '2024-08-07 13:50:00'),
-- Servicios para Hiroshi Tanaka (Chef ID 5)
(59, 5, '2024-05-28', '18:30:00', 'Diagonal 123, Barcelona', 4, 300.00, 'completado', 'Cena japonesa tradicional', '2024-05-23 15:25:00'),
(60, 5, '2024-07-15', '19:00:00', 'Puerta del Sol 456, Madrid', 8, 600.00, 'completado', 'Degustación de sushi para empresa', '2024-07-10 12:10:00'),
(61, 5, '2024-08-25', '20:00:00', 'Sagrada Familia 789, Barcelona', 6, 450.00, 'completado', 'Cena kaiseki para ocasión especial', '2024-08-20 08:40:00'),
-- Servicios para Carlos Mendoza (Chef ID 6)
(62, 6, '2024-06-05', '19:30:00', 'Retiro 234, Madrid', 8, 520.00, 'completado', 'Fiesta mexicana con mole tradicional', '2024-05-31 17:55:00'),
(63, 6, '2024-07-18', '18:00:00', 'Eixample 567, Barcelona', 10, 650.00, 'completado', 'Celebración con cocina mexicana auténtica', '2024-07-13 14:35:00'),
(64, 6, '2024-08-30', '20:30:00', 'Malasaña 890, Madrid', 6, 390.00, 'completado', 'Cena íntima con especialidades mexicanas', '2024-08-25 10:20:00'),
-- Servicios para Isabella Rodriguez (Chef ID 7)
(65, 7, '2024-06-12', '16:00:00', 'Gràcia 123, Barcelona', 12, 840.00, 'completado', 'Taller de repostería y degustación', '2024-06-07 16:05:00'),
(66, 7, '2024-07-25', '15:30:00', 'Chueca 456, Madrid', 8, 560.00, 'completado', 'Clase magistral de macarons franceses', '2024-07-20 11:45:00'),
(67, 7, '2024-09-08', '17:00:00', 'Barceloneta 789, Barcelona', 6, 420.00, 'completado', 'Celebración con postres artísticos', '2024-09-03 13:30:00');

-- Insertar calificaciones para los servicios completados
INSERT INTO calificaciones (servicio_id, cliente_id, chef_id, puntuacion, titulo, comentario, aspectos_positivos, aspectos_mejora, recomendaria, fecha_calificacion) VALUES
-- Calificaciones para Marco Antonelli
(1, 53, 3, 5, 'Experiencia italiana excepcional', 'Marco superó todas nuestras expectativas. La pasta estaba perfecta y el ambiente que creó fue mágico.', 'Pasta fresca increíble, presentación elegante, muy profesional', 'Ninguna, todo perfecto', 1, '2024-05-16 21:30:00'),
(2, 54, 3, 5, 'Evento corporativo exitoso', 'Todos los invitados quedaron encantados con la comida italiana. Marco es un verdadero maestro.', 'Calidad excepcional, puntualidad, adaptación al evento', 'Podría incluir más opciones vegetarianas', 1, '2024-06-21 10:15:00'),
(3, 55, 3, 4, 'Cena romántica perfecta', 'Una velada inolvidable con auténtica cocina italiana. Muy recomendable para ocasiones especiales.', 'Ambiente romántico, sabores auténticos, atención al detalle', 'El postre podría mejorarse', 1, '2024-07-09 20:00:00'),
-- Calificaciones para Sophie Dubois
(4, 56, 4, 5, 'Alta cocina francesa impecable', 'Sophie demostró por qué es una chef de nivel Michelin. Cada plato fue una obra de arte.', 'Técnica impecable, presentación artística, sabores refinados', 'Ninguna, experiencia perfecta', 1, '2024-05-23 22:00:00'),
(5, 57, 4, 5, 'Celebración familiar memorable', 'La cocina francesa de Sophie hizo que nuestra celebración fuera extraordinaria. Todos quedaron fascinados.', 'Elegancia, sabor excepcional, profesionalismo', 'Nada que mejorar', 1, '2024-07-01 21:45:00'),
(6, 58, 4, 5, 'Banquete de boda espectacular', 'Sophie convirtió nuestro banquete en una experiencia gastronómica inolvidable. Altamente recomendada.', 'Organización perfecta, calidad suprema, atención personalizada', 'Todo estuvo perfecto', 1, '2024-08-13 23:30:00'),
-- Calificaciones para Hiroshi Tanaka
(7, 59, 5, 5, 'Auténtica experiencia japonesa', 'Hiroshi nos transportó a Japón con su cocina tradicional. Una experiencia cultural y gastronómica única.', 'Autenticidad, presentación artística, ingredientes frescos', 'Podría explicar más sobre las técnicas', 1, '2024-05-29 20:30:00'),
(8, 60, 5, 4, 'Sushi de calidad excepcional', 'El sushi de Hiroshi es de nivel profesional. Perfecto para eventos corporativos.', 'Frescura del pescado, técnica perfecta, presentación', 'Más variedad en los rollos', 1, '2024-07-16 14:20:00'),
(9, 61, 5, 5, 'Kaiseki extraordinario', 'Una experiencia kaiseki auténtica que superó nuestras expectativas. Hiroshi es un verdadero maestro.', 'Estacionalidad, equilibrio, presentación artística', 'Nada que mejorar', 1, '2024-08-26 22:15:00');

-- Insertar recetas destacadas para cada chef según su especialidad
INSERT INTO recetas (chef_id, titulo, descripcion, ingredientes, instrucciones, tiempo_preparacion, dificultad, precio, imagen, fecha_publicacion, activa) VALUES
-- Receta de Marco Antonelli (Cocina Italiana)
(3, 'Risotto ai Funghi Porcini Auténtico', 'Un risotto cremoso con hongos porcini secos, preparado con la técnica tradicional del norte de Italia. El secreto está en el sofrito perfecto y el caldo caliente.', '400g arroz Arborio, 30g hongos porcini secos, 1L caldo de verduras, 1 cebolla, 100ml vino blanco, 50g mantequilla, 80g parmesano, aceite de oliva, sal, pimienta', '1. Remojar los porcini en agua caliente por 20 min. 2. Hacer sofrito con cebolla. 3. Tostar el arroz 2 min. 4. Agregar vino y dejar evaporar. 5. Añadir caldo caliente de a poco, removiendo constantemente. 6. Incorporar hongos y mantequilla al final. 7. Terminar con parmesano.', 35, 'intermedio', 24.99, 'recipe_1_final_1753709622.jpg', '2024-05-20 15:30:00', 1),
-- Receta de Sophie Dubois (Cocina Francesa)
(4, 'Coq au Vin de Bourgogne Clásico', 'El tradicional pollo al vino de Borgoña, marinado y cocido lentamente con verduras aromáticas. Una receta que representa la esencia de la cocina francesa.', '1 pollo entero, 750ml vino tinto Borgoña, 200g tocino, 12 cebollitas perla, 250g champiñones, 2 zanahorias, bouquet garni, mantequilla, harina, coñac', '1. Marinar el pollo en vino 4 horas. 2. Dorar el pollo y reservar. 3. Saltear tocino y verduras. 4. Flambear con coñac. 5. Agregar pollo y vino de marinada. 6. Cocinar a fuego lento 1.5 horas. 7. Espesar la salsa con mantequilla y harina.', 180, 'difícil', 32.99, 'recipe_5_final_1751076193.jpg', '2024-05-25 18:45:00', 1);

-- Continuar con más recetas en la siguiente actualización debido a limitaciones de longitud