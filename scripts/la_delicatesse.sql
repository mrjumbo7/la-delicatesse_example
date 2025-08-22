-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 22-08-2025 a las 00:20:34
-- Versión del servidor: 8.3.0
-- Versión de PHP: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `la_delicatesse`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `ProcessRefund`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcessRefund` (IN `p_transaction_id` VARCHAR(100), IN `p_refund_amount` DECIMAL(10,2), IN `p_reason` TEXT)   BEGIN
    DECLARE v_purchase_id INT;
    DECLARE v_original_amount DECIMAL(10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Verificar que la compra existe
    SELECT id, precio_pagado INTO v_purchase_id, v_original_amount
    FROM compras_recetas 
    WHERE transaction_id = p_transaction_id AND payment_status = 'completed';
    
    IF v_purchase_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transacción no encontrada o no válida para reembolso';
    END IF;
    
    IF p_refund_amount > v_original_amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto del reembolso no puede ser mayor al monto original';
    END IF;
    
    -- Actualizar el estado de la compra
    UPDATE compras_recetas 
    SET payment_status = 'refunded', 
        fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id = v_purchase_id;
    
    -- Registrar el log de la transacción de reembolso
    INSERT INTO transaction_logs (
        transaction_id, 
        usuario_id, 
        tipo_transaccion, 
        monto, 
        estado, 
        gateway_response
    )
    SELECT 
        CONCAT('refund_', p_transaction_id),
        cliente_id,
        'refund',
        p_refund_amount,
        'completed',
        JSON_OBJECT('reason', p_reason, 'original_transaction', p_transaction_id)
    FROM compras_recetas 
    WHERE id = v_purchase_id;
    
    COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificaciones`
--

DROP TABLE IF EXISTS `calificaciones`;
CREATE TABLE IF NOT EXISTS `calificaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `servicio_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `chef_id` int NOT NULL,
  `puntuacion` int DEFAULT NULL,
  `titulo` varchar(200) DEFAULT NULL,
  `comentario` text,
  `aspectos_positivos` text,
  `aspectos_mejora` text,
  `recomendaria` tinyint(1) DEFAULT '1',
  `fecha_calificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `servicio_id` (`servicio_id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `idx_calificaciones_chef` (`chef_id`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `calificaciones`
--

INSERT INTO `calificaciones` (`id`, `servicio_id`, `cliente_id`, `chef_id`, `puntuacion`, `titulo`, `comentario`, `aspectos_positivos`, `aspectos_mejora`, `recomendaria`, `fecha_calificacion`) VALUES
(31, 40, 276, 224, 5, NULL, 'Una velada perfecta para nuestro aniversario. El coq au vin estaba exquisito y el soufflé de chocolate fue el broche de oro. Carlos es un verdadero maestro de la cocina francesa.', NULL, NULL, 1, '2024-03-26 11:45:00'),
(30, 39, 275, 224, 5, NULL, 'Nivel gastronómico de restaurante Michelin. Carlos preparó un menú sofisticado que impresionó a nuestros socios europeos. Su técnica francesa es impecable y la presentación fue artística.', NULL, NULL, 1, '2024-02-21 09:15:00'),
(29, 38, 274, 223, 5, NULL, 'Ana superó todas nuestras expectativas. La lasagna casera fue la mejor que hemos probado y el tiramisú estaba divino. Toda la familia quedó encantada con su profesionalismo y calidez.', NULL, NULL, 1, '2024-03-16 14:20:00'),
(28, 37, 273, 223, 5, NULL, 'Experiencia gastronómica excepcional. Ana demostró un dominio impresionante de la cocina italiana. El risotto estaba perfecto y la atención al detalle fue extraordinaria. Definitivamente la recomendaremos.', NULL, NULL, 1, '2024-02-15 10:30:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

DROP TABLE IF EXISTS `categorias`;
CREATE TABLE IF NOT EXISTS `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_nombre` (`nombre`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`, `fecha_creacion`) VALUES
(1, 'Cocina Internacional', 'Platos y tÃ©cnicas culinarias de diferentes paÃ­ses del mundo', '2025-08-06 23:43:10'),
(2, 'Cocina Italiana', 'Especialidades tradicionales de Italia, incluyendo pastas, pizzas y risottos', '2025-08-06 23:43:10'),
(3, 'Cocina Francesa', 'Alta cocina francesa con tÃ©cnicas clÃ¡sicas y refinadas', '2025-08-06 23:43:10'),
(4, 'Cocina AsiÃ¡tica', 'Sabores orientales incluyendo cocina china, japonesa, tailandesa y mÃ¡s', '2025-08-06 23:43:10'),
(5, 'Cocina Mexicana', 'AutÃ©nticos sabores mexicanos con especias tradicionales', '2025-08-06 23:43:10'),
(6, 'ReposterÃ­a', 'Postres, pasteles, galletas y dulces artesanales', '2025-08-06 23:43:10'),
(7, 'Cocina Saludable', 'Recetas nutritivas y balanceadas para un estilo de vida saludable', '2025-08-06 23:43:10'),
(8, 'Cocina Vegetariana', 'Platos sin carne con ingredientes frescos y naturales', '2025-08-06 23:43:10'),
(9, 'Cocina Vegana', 'Recetas completamente libres de productos de origen animal', '2025-08-06 23:43:10'),
(10, 'Parrilladas', 'Especialidades a la parrilla y tÃ©cnicas de asado', '2025-08-06 23:43:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `chefs_favoritos`
--

DROP TABLE IF EXISTS `chefs_favoritos`;
CREATE TABLE IF NOT EXISTS `chefs_favoritos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `chef_id` int NOT NULL,
  `fecha_agregado` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_favorite` (`cliente_id`,`chef_id`),
  KEY `chef_id` (`chef_id`),
  KEY `idx_chefs_favoritos_cliente` (`cliente_id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras_recetas`
--

DROP TABLE IF EXISTS `compras_recetas`;
CREATE TABLE IF NOT EXISTS `compras_recetas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `receta_id` int NOT NULL,
  `precio_pagado` decimal(8,2) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `payment_status` enum('pending','completed','failed','refunded') DEFAULT 'pending',
  `payment_method_id` int DEFAULT NULL,
  `fecha_compra` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `receta_id` (`receta_id`),
  KEY `idx_transaction_id` (`transaction_id`),
  KEY `idx_payment_status` (`payment_status`),
  KEY `idx_payment_method` (`payment_method_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Disparadores `compras_recetas`
--
DROP TRIGGER IF EXISTS `update_payment_stats`;
DELIMITER $$
CREATE TRIGGER `update_payment_stats` AFTER UPDATE ON `compras_recetas` FOR EACH ROW BEGIN
    IF OLD.payment_status != NEW.payment_status THEN
        -- Aquí podrías agregar lógica para actualizar estadísticas en tiempo real
        -- Por ejemplo, enviar notificaciones, actualizar métricas, etc.
        INSERT INTO transaction_logs (
            transaction_id,
            usuario_id,
            tipo_transaccion,
            monto,
            estado,
            gateway_response
        ) VALUES (
            CONCAT('status_change_', NEW.transaction_id),
            NEW.cliente_id,
            'recipe_purchase',
            NEW.precio_pagado,
            NEW.payment_status,
            JSON_OBJECT('old_status', OLD.payment_status, 'new_status', NEW.payment_status)
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conversaciones`
--

DROP TABLE IF EXISTS `conversaciones`;
CREATE TABLE IF NOT EXISTS `conversaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `servicio_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `chef_id` int NOT NULL,
  `estado` enum('activa','cerrada') COLLATE utf8mb4_unicode_ci DEFAULT 'activa',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_conversation` (`servicio_id`),
  KEY `idx_conversaciones_cliente` (`cliente_id`),
  KEY `idx_conversaciones_chef` (`chef_id`),
  KEY `idx_conversaciones_servicio` (`servicio_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `conversaciones`
--

INSERT INTO `conversaciones` (`id`, `servicio_id`, `cliente_id`, `chef_id`, `estado`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 1, 2, 1, 'activa', '2025-08-07 02:43:01', '2025-08-07 02:43:01'),
(2, 4, 2, 1, 'activa', '2025-08-08 00:25:32', '2025-08-08 00:25:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cupones_descuento`
--

DROP TABLE IF EXISTS `cupones_descuento`;
CREATE TABLE IF NOT EXISTS `cupones_descuento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_descuento` enum('porcentaje','monto_fijo') COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_descuento` decimal(8,2) NOT NULL,
  `monto_minimo` decimal(8,2) DEFAULT '0.00',
  `usos_maximos` int DEFAULT NULL,
  `usos_actuales` int DEFAULT '0',
  `fecha_inicio` datetime NOT NULL,
  `fecha_expiracion` datetime NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `aplicable_a` enum('recipes','services','all') COLLATE utf8mb4_unicode_ci DEFAULT 'all',
  `creado_por` int NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_codigo` (`codigo`),
  KEY `idx_activo` (`activo`),
  KEY `idx_fecha_expiracion` (`fecha_expiracion`),
  KEY `idx_aplicable_a` (`aplicable_a`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cupones_descuento`
--

INSERT INTO `cupones_descuento` (`id`, `codigo`, `tipo_descuento`, `valor_descuento`, `monto_minimo`, `usos_maximos`, `usos_actuales`, `fecha_inicio`, `fecha_expiracion`, `activo`, `aplicable_a`, `creado_por`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 'BIENVENIDO10', 'porcentaje', 10.00, 5.00, 100, 0, '2025-08-10 13:00:33', '2025-09-09 13:00:33', 1, 'all', 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(2, 'RECETAS5', 'monto_fijo', 5.00, 10.00, 50, 0, '2025-08-10 13:00:33', '2025-08-25 13:00:33', 1, 'recipes', 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(3, 'PRIMERACOMPRA', 'porcentaje', 15.00, 0.00, 200, 0, '2025-08-10 13:00:33', '2025-10-09 13:00:33', 1, 'all', 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imagenes_recetas`
--

DROP TABLE IF EXISTS `imagenes_recetas`;
CREATE TABLE IF NOT EXISTS `imagenes_recetas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `receta_id` int NOT NULL,
  `tipo` enum('resultado','paso') NOT NULL,
  `orden` int NOT NULL,
  `imagen_url` varchar(255) NOT NULL,
  `descripcion` text,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `receta_id` (`receta_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensajes`
--

DROP TABLE IF EXISTS `mensajes`;
CREATE TABLE IF NOT EXISTS `mensajes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `servicio_id` int NOT NULL,
  `remitente_id` int NOT NULL,
  `destinatario_id` int NOT NULL,
  `mensaje` text NOT NULL,
  `fecha_envio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `leido` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `servicio_id` (`servicio_id`),
  KEY `remitente_id` (`remitente_id`),
  KEY `destinatario_id` (`destinatario_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodos_pago`
--

DROP TABLE IF EXISTS `metodos_pago`;
CREATE TABLE IF NOT EXISTS `metodos_pago` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `ultimos_digitos` varchar(4) DEFAULT NULL,
  `nombre_titular` varchar(100) DEFAULT NULL,
  `fecha_expiracion` varchar(7) DEFAULT NULL,
  `es_principal` tinyint(1) DEFAULT '0',
  `fecha_agregado` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
CREATE TABLE IF NOT EXISTS `notificaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `mensaje` text NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `leida` tinyint(1) DEFAULT '0',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`id`, `usuario_id`, `titulo`, `mensaje`, `tipo`, `leida`, `fecha_creacion`) VALUES
(1, 1, 'Nueva solicitud de servicio', 'Tienes una nueva solicitud de servicio pendiente', 'servicio', 0, '2025-08-07 02:40:57'),
(2, 2, 'Actualización de servicio', 'Tu solicitud de servicio ha sido aceptada por el chef.', 'servicio', 0, '2025-08-07 02:43:01'),
(3, 1, 'Nueva solicitud de servicio', 'Tienes una nueva solicitud de servicio pendiente', 'servicio', 0, '2025-08-08 00:04:17'),
(4, 4, 'Nueva solicitud de servicio', 'Tienes una nueva solicitud de servicio pendiente', 'servicio', 0, '2025-08-08 00:19:28'),
(5, 1, 'Nueva solicitud de servicio', 'Tienes una nueva solicitud de servicio pendiente', 'servicio', 0, '2025-08-08 00:24:58'),
(6, 2, 'Actualización de servicio', 'El servicio ha sido cancelado.', 'servicio', 0, '2025-08-08 00:25:26'),
(7, 2, 'Actualización de servicio', 'Tu solicitud de servicio ha sido aceptada por el chef.', 'servicio', 0, '2025-08-08 00:25:32'),
(8, 2, 'Nuevo mensaje', 'Has recibido un nuevo mensaje', 'mensaje', 0, '2025-08-11 00:36:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

DROP TABLE IF EXISTS `pagos`;
CREATE TABLE IF NOT EXISTS `pagos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `servicio_id` int NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  `metodo_pago_id` int DEFAULT NULL,
  `estado_pago` enum('pendiente','completado','fallido','reembolsado') DEFAULT 'pendiente',
  `fecha_pago` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `referencia_pago` varchar(100) DEFAULT NULL,
  `comprobante_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `servicio_id` (`servicio_id`),
  KEY `metodo_pago_id` (`metodo_pago_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payment_config`
--

DROP TABLE IF EXISTS `payment_config`;
CREATE TABLE IF NOT EXISTS `payment_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gateway_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_value` text COLLATE utf8mb4_unicode_ci,
  `is_encrypted` tinyint(1) DEFAULT '0',
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_gateway_key` (`gateway_name`,`config_key`),
  KEY `idx_gateway_name` (`gateway_name`),
  KEY `idx_activo` (`activo`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `payment_config`
--

INSERT INTO `payment_config` (`id`, `gateway_name`, `config_key`, `config_value`, `is_encrypted`, `activo`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 'stripe', 'public_key', 'pk_test_...', 0, 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(2, 'stripe', 'secret_key', 'sk_test_...', 0, 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(3, 'stripe', 'webhook_secret', 'whsec_...', 0, 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(4, 'paypal', 'client_id', 'client_id_...', 0, 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(5, 'paypal', 'client_secret', 'client_secret_...', 0, 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(6, 'system', 'currency', 'USD', 0, 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(7, 'system', 'tax_rate', '0.13', 0, 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(8, 'system', 'min_purchase_amount', '1.00', 0, 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33'),
(9, 'system', 'max_purchase_amount', '1000.00', 0, 1, '2025-08-10 19:00:33', '2025-08-10 19:00:33');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `payment_stats`
-- (Véase abajo para la vista actual)
--
DROP VIEW IF EXISTS `payment_stats`;
CREATE TABLE IF NOT EXISTS `payment_stats` (
`fecha` date
,`ingresos_totales` decimal(30,2)
,`tasa_exito` decimal(28,5)
,`ticket_promedio` decimal(12,6)
,`total_transacciones` bigint
,`transacciones_exitosas` bigint
,`transacciones_fallidas` bigint
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfiles_chef`
--

DROP TABLE IF EXISTS `perfiles_chef`;
CREATE TABLE IF NOT EXISTS `perfiles_chef` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `especialidad` varchar(100) DEFAULT NULL,
  `experiencia_anos` int DEFAULT NULL,
  `precio_por_hora` decimal(10,2) DEFAULT NULL,
  `biografia` text,
  `ubicacion` varchar(200) DEFAULT NULL,
  `certificaciones` text,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `calificacion_promedio` decimal(3,2) DEFAULT '0.00',
  `total_servicios` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`)
) ENGINE=MyISAM AUTO_INCREMENT=411 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `perfiles_chef`
--

INSERT INTO `perfiles_chef` (`id`, `usuario_id`, `especialidad`, `experiencia_anos`, `precio_por_hora`, `biografia`, `ubicacion`, `certificaciones`, `foto_perfil`, `calificacion_promedio`, `total_servicios`) VALUES
(410, 272, 'Cocina Internacional', 11, 50.00, 'Chef especializado en cocina boliviana. Experto en quinoa, llama y técnicas altiplánicas. Mi formación en Bolivia me permitió dominar las técnicas culinarias del altiplano y el uso de ingredientes andinos.', 'Alegría, Usulután', 'La Paz Culinary Academy, Certificación Bolivian Cuisine, Especialización en Cocina Altiplánica', NULL, 4.81, 178),
(409, 271, 'Cocina Internacional', 7, 40.00, 'Especialista en cocina paraguaya. Experta en sopa paraguaya, chipa y técnicas guaraníes. Mi experiencia en Paraguay me enseñó las técnicas culinarias guaraníes y el uso del maíz en la cocina tradicional.', 'Berlín, Usulután', 'Asunción Culinary Institute, Certificación Paraguayan Cuisine, Especialización en Técnicas Guaraníes', NULL, 4.73, 134),
(408, 270, 'Cocina Internacional', 9, 46.00, 'Chef especializado en cocina uruguaya. Experto en asado, chivito y técnicas rioplatenses. Mi formación en Uruguay me enseñó las sutilezas de la cocina rioplatense y las técnicas del asado uruguayo.', 'Tepetitán, San Vicente', 'Montevideo Culinary Academy, Certificación Uruguayan Asado, Especialización en Cocina Rioplatense', NULL, 4.79, 156),
(407, 269, 'Cocina Internacional', 12, 54.00, 'Especialista en cocina venezolana. Experta en arepas, pabellón y técnicas llaneras. Mi herencia venezolana y formación en Caracas me han permitido preservar las tradiciones culinarias venezolanas.', 'Santa Clara, San Vicente', 'Caracas Culinary School, Certificación Venezuelan Cuisine, Especialización en Cocina Llanera', NULL, 4.85, 189),
(406, 268, 'Cocina Internacional', 8, 43.00, 'Chef especializado en cocina ecuatoriana. Experto en ceviche, locro y técnicas de la sierra. Mi formación en Ecuador me permitió dominar las técnicas culinarias de costa, sierra y selva.', 'San Cayetano Istepeque, San Vicente', 'Quito Culinary Institute, Certificación Ecuadorian Cuisine, Especialización en Cocina de la Sierra', NULL, 4.77, 145),
(405, 267, 'Cocina Internacional', 10, 48.00, 'Especialista en cocina chilena. Experta en mariscos, empanadas y técnicas andinas. Mi experiencia en Chile me enseñó a trabajar con los mariscos del Pacífico y las técnicas culinarias andinas.', 'Guadalupe, San Vicente', 'Santiago Culinary Academy, Certificación Seafood Chilean, Especialización en Técnicas Andinas', NULL, 4.80, 167),
(404, 266, 'Cocina Internacional', 6, 36.00, 'Chef especializado en cocina colombiana. Experto en arepas, sancocho y técnicas caribeñas. Mi formación en Colombia me enseñó la diversidad culinaria de este país y sus técnicas regionales.', 'Apastepeque, San Vicente', 'Bogotá Culinary School, Certificación Colombian Cuisine, Especialización en Cocina Caribeña', NULL, 4.70, 123),
(403, 265, 'Cocina Internacional', 11, 51.00, 'Especialista en cocina argentina. Experta en empanadas, asado y técnicas de parrilla. Mi amor por la cocina argentina me llevó a estudiar en Buenos Aires, donde aprendí las técnicas del asado perfecto.', 'Verapaz, San Vicente', 'Buenos Aires Culinary Institute, Certificación Asado Master, Especialización en Empanadas', NULL, 4.82, 178),
(402, 264, 'Cocina Internacional', 9, 47.00, 'Chef especializado en cocina brasileña. Experto en feijoada, churrasco y técnicas de cocción lenta. Mi formación en Brasil me enseñó las técnicas tradicionales del churrasco y la cocina regional brasileña.', 'Tecoluca, San Vicente', 'São Paulo Culinary Academy, Certificación Churrasco Master, Especialización en Cocina Regional Brasileña', NULL, 4.78, 156),
(401, 263, 'Cocina Vegana', 7, 41.00, 'Especialista en cocina vegana gourmet. Experta en proteínas vegetales, leches vegetales y técnicas de sustitución. Mi filosofía se basa en crear platos veganos que no sacrifiquen sabor ni presentación.', 'Talnique, La Libertad', 'Plant-Based Culinary Institute, Certificación Vegan Gourmet, Especialización en Proteínas Vegetales', NULL, 4.74, 134),
(400, 262, 'Cocina Internacional', 12, 55.00, 'Especialista en cocina etíope tradicional. Experto en injera, berbere y técnicas de fermentación africana. Mi experiencia en Etiopía me enseñó las técnicas únicas de fermentación y el uso de especias africanas.', 'San José Villanueva, La Libertad', 'Addis Ababa Culinary Institute, Certificación Ethiopian Cuisine, Especialización en Fermentación Africana', NULL, 4.83, 189),
(399, 261, 'Cocina Internacional', 8, 44.00, 'Chef especializada en cocina libanesa. Experta en hummus, tabbouleh y técnicas del Levante. Mi herencia libanesa y formación en Beirut me han permitido preservar las tradiciones culinarias del Levante.', 'Nuevo Cuscatlán, La Libertad', 'Beirut Culinary School, Certificación Levantine Cuisine, Especialización en Mezze', NULL, 4.76, 145),
(398, 260, 'Cocina Internacional', 10, 49.00, 'Especialista en cocina turca tradicional. Experto en kebabs, baklava y técnicas otomanas. Mi formación en Estambul me permitió dominar las técnicas culinarias que fusionan Europa y Asia.', 'La Libertad, La Libertad', 'Istanbul Culinary Academy, Certificación Ottoman Cuisine, Especialización en Técnicas de Fusión', NULL, 4.81, 167),
(397, 259, 'Cocina Internacional', 6, 38.00, 'Chef especializada en cocina marroquí. Experta en tagines, cuscús y especias del norte de África. Mi fascinación por la cocina marroquí me llevó a estudiar en Marrakech, donde aprendí el arte de las especias.', 'Jicalapa, La Libertad', 'Marrakech Culinary Institute, Certificación Spice Master, Especialización en Tagines', NULL, 4.72, 123),
(396, 258, 'Cocina Internacional', 11, 52.00, 'Especialista en cocina griega tradicional. Experto en mezze, pescados a la parrilla y aceites de oliva. Mi formación en Grecia me enseñó las técnicas mediterráneas ancestrales y el uso correcto del aceite de oliva.', 'Jayaque, La Libertad', 'Athens Culinary School, Certificación Mediterranean Cuisine, Especialización en Aceites de Oliva', NULL, 4.84, 178),
(395, 257, 'Cocina Internacional', 9, 46.00, 'Chef especializada en cocina peruana moderna. Experta en ceviches, anticuchos y técnicas nikkei. Mi amor por la cocina peruana me llevó a estudiar en Lima, donde aprendí las técnicas tradicionales y la fusión nikkei.', 'Huizúcar, La Libertad', 'Lima Culinary Institute, Certificación Ceviche Master, Especialización en Cocina Nikkei', NULL, 4.79, 156),
(394, 256, 'Cocina Asiática', 7, 39.00, 'Especialista en cocina tailandesa auténtica. Experto en curries, pad thai y técnicas de equilibrio de sabores. Mi formación en Bangkok me enseñó los secretos del equilibrio perfecto entre dulce, salado, ácido y picante.', 'Comasagua, La Libertad', 'Bangkok Culinary Academy, Certificación Thai Curry Master, Especialización en Equilibrio de Sabores', NULL, 4.73, 134),
(393, 255, 'Cocina Italiana', 13, 57.00, 'Maestro en cocina napolitana. Experto en pizza al taglio, mozzarella di bufala y cocina de Campania. Mi formación en Nápoles me permitió dominar las técnicas ancestrales de la pizza napolitana y la cocina campana.', 'Ciudad Arce, La Libertad', 'Università della Pizza, Certificación Pizzaiolo Napoletano, Especialización en Mozzarella di Bufala', NULL, 4.88, 201),
(392, 254, 'Cocina Internacional', 8, 43.00, 'Especialista en cocina australiana moderna. Experta en barbacoa australiana, mariscos y vinos locales. Mi experiencia en Australia me enseñó las técnicas únicas del BBQ australiano y el trabajo con ingredientes autóctonos.', 'Opico, La Libertad', 'Australian Culinary Federation, Certificación Aussie BBQ, Sommelier de Vinos Australianos', NULL, 4.77, 145),
(391, 253, 'Cocina Internacional', 12, 54.00, 'Chef ruso especializado en cocina de los Urales. Experto en carnes de caza, setas silvestres y conservas. Mi formación en los Urales me enseñó las técnicas de caza y recolección, así como la preparación de carnes silvestres.', 'Guazapa, San Salvador', 'Ural Culinary Institute, Certificación Game Meat, Especialización en Setas Silvestres', NULL, 4.85, 189),
(390, 252, 'Cocina Asiática', 5, 35.00, 'Especialista en cocina japonesa de Hokkaido. Experta en mariscos frescos, kaisendon y cocina de invierno. Mi experiencia en Hokkaido me enseñó a trabajar con los mariscos más frescos y las técnicas de cocina invernal japonesa.', 'El Paisnal, San Salvador', 'Hokkaido Seafood Academy, Certificación Seafood Master, Especialización en Cocina Invernal', NULL, 4.68, 112),
(389, 251, 'Cocina Italiana', 10, 47.00, 'Maestra en cocina siciliana. Especialista en arancini, caponata y dulces tradicionales sicilianos. Mi formación en Sicilia me permitió dominar las técnicas únicas de esta isla mediterránea.', 'Aguilares, San Salvador', 'Scuola di Cucina Siciliana, Certificación Pasticceria Siciliana, Especialización en Arancini', NULL, 4.81, 167),
(388, 250, 'Cocina Internacional', 4, 31.00, 'Especialista en cocina irlandesa tradicional. Experto en estofados, soda bread y whiskey irlandés. Mi herencia irlandesa y formación en Dublín me han permitido preservar las tradiciones culinarias celtas.', 'Santo Tomás, San Salvador', 'Dublin Culinary School, Certificación Irish Traditional, Especialización en Whiskey Pairing', NULL, 4.65, 98),
(387, 249, 'Cocina Internacional', 11, 50.00, 'Chef rusa especializada en cocina siberiana. Experta en pescados de río, técnicas de ahumado en frío. Mi formación en Siberia me enseñó las técnicas de supervivencia culinaria y conservación en condiciones extremas.', 'San Marcos, San Salvador', 'Siberian Culinary Institute, Certificación Cold Smoking, Especialización en Pescados de Río', NULL, 4.83, 178),
(386, 248, 'Cocina Asiática', 8, 42.00, 'Experto en cocina japonesa de Fukuoka. Especialista en ramen tonkotsu, mentaiko y cocina de Kyushu. Mi experiencia en Fukuoka me permitió dominar el arte del ramen tonkotsu y las especialidades del sur de Japón.', 'Cuscatancingo, San Salvador', 'Fukuoka Ramen Academy, Certificación Tonkotsu Master, Especialización en Cocina de Kyushu', NULL, 4.76, 134),
(385, 247, 'Cocina Italiana', 9, 45.00, 'Especialista en cocina piamontesa. Maestra en trufas, agnolotti y vinos de Piamonte. Mi formación en el Piamonte me enseñó a trabajar con trufas y a crear los delicados agnolotti tradicionales.', 'Ayutuxtepeque, San Salvador', 'Università di Scienze Gastronomiche, Certificación Truffle Expert, Sommelier de Vinos Piamonteses', NULL, 4.78, 156),
(384, 246, 'Cocina Asiática', 6, 37.00, 'Chef coreano especializado en kimchi y fermentados. Experto en BBQ coreano y banchan tradicional. Mi herencia coreana y formación en Seúl me han permitido dominar las técnicas de fermentación y los sabores únicos de Corea.', 'Nejapa, San Salvador', 'Seoul Culinary Academy, Certificación Kimchi Master, Especialización en Fermentación Coreana', NULL, 4.71, 123),
(383, 245, 'Cocina Internacional', 10, 48.00, 'Especialista en cocina rusa moderna. Experta en caviar, vodka y técnicas de conservación en frío. Mi formación en San Petersburgo me permitió dominar las técnicas refinadas de la cocina rusa aristocrática.', 'Tonacatepeque, San Salvador', 'St. Petersburg Culinary Institute, Certificación Caviar Expert, Especialización en Conservación', NULL, 4.80, 167),
(382, 244, 'Cocina Asiática', 7, 40.00, 'Chef japonés especializado en cocina de Nagoya. Experto en miso katsu, hitsumabushi y cocina regional. Mi experiencia en Nagoya me enseñó las especialidades regionales japonesas menos conocidas pero igualmente deliciosas.', 'Quezaltepeque, La Libertad', 'Nagoya Culinary Academy, Certificación Regional Japanese, Especialización en Miso', NULL, 4.72, 145),
(381, 243, 'Cocina Italiana', 12, 56.00, 'Maestra en cocina veneciana. Especialista en risotto al nero di seppia, cicchetti y vinos del Véneto. Mi formación en Venecia me permitió dominar las técnicas únicas de la cocina veneciana y del norte de Italia.', 'Colón, La Libertad', 'Scuola di Cucina Veneziana, Certificación Cicchetti Master, Sommelier de Vinos Vénetos', NULL, 4.86, 189),
(380, 242, 'Cocina Internacional', 5, 34.00, 'Especialista en cocina canadiense. Experto en maple syrup, poutine y cocina de los bosques. Mi experiencia en Canadá me enseñó a trabajar con ingredientes silvestres y técnicas de conservación del norte.', 'Acajutla, Sonsonate', 'Canadian Culinary Federation, Certificación Forest Cuisine, Especialización en Ingredientes Silvestres', NULL, 4.69, 112),
(379, 241, 'Cocina Internacional', 11, 51.00, 'Chef rusa especializada en cocina eslava. Experta en borscht, blinis y técnicas de fermentación. Mi herencia rusa y formación en Moscú me han permitido preservar las tradiciones culinarias eslavas.', 'Ilopango, San Salvador', 'Moscow Culinary Institute, Certificación Slavic Cuisine, Especialización en Fermentación Tradicional', NULL, 4.82, 178),
(378, 240, 'Cocina Asiática', 9, 46.00, 'Experto en cocina japonesa de Osaka. Especialista en okonomiyaki, takoyaki y street food japonés. Mi experiencia en Osaka me enseñó las técnicas del street food japonés y la cocina casera tradicional.', 'Antiguo Cuscatlán, La Libertad', 'Osaka Culinary School, Certificación Street Food Master, Especialización en Cocina Casera Japonesa', NULL, 4.75, 156),
(377, 239, 'Cocina Internacional', 8, 43.00, 'Chef portuguesa especializada en mariscos. Experta en bacalao, caldeiradas y vinos del Duero. Mi formación en Lisboa me permitió dominar las técnicas tradicionales portuguesas de preparación de pescados y mariscos.', 'Morazán, Morazán', 'Escola de Hotelaria de Lisboa, Certificación Mariscos, Sommelier de Vinos Portugueses', NULL, 4.77, 134),
(376, 238, 'Cocina Asiática', 6, 39.00, 'Especialista en cocina japonesa de Kyoto. Experta en tofu artesanal, vegetales de temporada y té. Mi formación en Kyoto me enseñó la importancia de la estacionalidad y la simplicidad en la cocina japonesa tradicional.', 'San Vicente, San Vicente', 'Kyoto Traditional Cooking School, Certificación Tea Master, Especialización en Cocina Estacional', NULL, 4.68, 123),
(375, 237, 'Cocina Internacional', 10, 49.00, 'Chef alemana especializada en cocina centroeuropea. Experta en embutidos artesanales y técnicas de conservación. Mi herencia alemana y formación en Múnich me han permitido dominar las técnicas tradicionales de la cocina centroeuropea.', 'Sonsonate, Sonsonate', 'Deutsche Kochschule, Certificación Charcuterie, Especialización en Conservas Tradicionales', NULL, 4.81, 145),
(374, 236, 'Cocina Internacional', 7, 41.00, 'Especialista en cocina americana contemporánea. Experto en BBQ, comfort food y técnicas de ahumado. Mi experiencia en Estados Unidos me permitió dominar las técnicas del BBQ tradicional americano.', 'La Unión, La Unión', 'Culinary Institute of America, Certificación BBQ Master, Especialización en Ahumados', NULL, 4.74, 167),
(373, 235, 'Cocina Internacional', 9, 47.00, 'Chef especializada en cocina india. Experta en especias, curries y técnicas tandoor. Mi fascinación por la cocina india me llevó a estudiar en Delhi, donde aprendí los secretos de las especias y las técnicas tradicionales.', 'Chalatenango, Chalatenango', 'Indian Culinary Institute, Certificación Spice Master, Especialización en Cocina Tandoor', NULL, 4.79, 156),
(372, 234, 'Cocina Francesa', 14, 62.00, 'Especialista en cocina provenzal. Maestro en hierbas aromáticas, ratatouille y técnicas mediterráneas. Mi amor por la cocina francesa del sur me llevó a estudiar en Provenza, donde aprendí a trabajar con los ingredientes más frescos del Mediterráneo.', 'Sensuntepeque, Cabañas', 'École de Cuisine Provençale, Certificación Herbes de Provence, Diploma en Cocina Mediterránea', NULL, 4.83, 187),
(371, 233, 'Cocina Asiática', 8, 44.00, 'Experta en cocina china regional y dim sum. Especialista en técnicas de wok y cocina al vapor tradicional. Mi formación en Shanghai me permitió dominar las técnicas regionales chinas, desde Sichuan hasta Cantón.', 'Zacatecoluca, La Paz', 'Shanghai Culinary Institute, Certificación Dim Sum Master, Especialización en Cocina Regional China', NULL, 4.76, 134),
(370, 232, 'Cocina Italiana', 13, 58.00, 'Maestro en cocina del sur de Italia. Especialista en pizzas napolitanas, pasta fresca y cocina siciliana tradicional. Formado en Nápoles, he dedicado años a perfeccionar las técnicas ancestrales de la cocina italiana del sur.', 'Cojutepeque, Cuscatlán', 'Accademia Italiana della Cucina, Certificación Pizza Napoletana, Diploma en Cocina Siciliana', NULL, 4.87, 201),
(369, 231, 'Cocina Vegetariana', 6, 36.00, 'Especialista en cocina vegetariana gourmet. Experta en proteínas vegetales y técnicas de cocción que realzan sabores naturales. Mi filosofía culinaria se basa en demostrar que la cocina vegetariana puede ser tan sofisticada y satisfactoria como cualquier otra.', 'Usulután, Usulután', 'Vegetarian Culinary Institute, Certificación en Proteínas Vegetales, Curso de Cocina Ayurvédica', NULL, 4.71, 145),
(368, 230, 'Cocina Internacional', 11, 52.00, 'Chef especializado en fusión internacional. Experto en combinar técnicas culinarias de diferentes culturas. Mi experiencia trabajando en cinco países diferentes me ha permitido crear un estilo único que celebra la diversidad gastronómica mundial.', 'Ahuachapán, Ahuachapán', 'Culinary Institute of America, Certificación en Fusión Internacional, Diploma en Gastronomía Mundial', NULL, 4.84, 176),
(367, 229, 'Cocina Saludable', 5, 32.00, 'Chef especializada en cocina saludable y nutritiva. Experta en superalimentos, cocina plant-based y dietas especiales. Mi enfoque se centra en crear platos deliciosos que nutran el cuerpo y el alma, utilizando ingredientes frescos y técnicas que preserven los nutrientes.', 'Delgado, San Salvador', 'Institute of Nutritional Cooking, Certificación Plant-Based, Especialización en Superalimentos', NULL, 4.67, 123),
(366, 228, 'Parrilladas', 7, 35.00, 'Maestro parrillero especializado en carnes sudamericanas. Experto en técnicas de asado argentino y brasileño. Mi pasión por la parrilla comenzó en Argentina, donde aprendí las técnicas tradicionales del asado gaucho.', 'Apopa, San Salvador', 'Academia Brasileña de Parrilla, Certificación Asador Profesional, Curso de Carnes Premium', NULL, 4.73, 189),
(365, 227, 'Repostería', 9, 48.00, 'Maestra pastelera especializada en repostería francesa y española. Experta en chocolatería, macarons y tartas artísticas. Mi formación en École de Pâtisserie París me ha permitido dominar las técnicas más refinadas de la repostería europea.', 'Mejicanos, San Salvador', 'École de Pâtisserie París, Certificación Chocolatier, Especialización en Macarons', NULL, 4.89, 167),
(364, 226, 'Cocina Mexicana', 10, 42.00, 'Chef especializado en cocina mexicana tradicional y contemporánea. Experto en moles, técnicas prehispánicas y maridajes con mezcal. Formado en el Instituto Culinario de México, he dedicado años a estudiar las tradiciones culinarias de diferentes regiones mexicanas.', 'Soyapango, San Salvador', 'Instituto Culinario de México, Certificación en Moles Tradicionales, Sommelier de Mezcal', NULL, 4.81, 134),
(363, 225, 'Cocina Asiática', 6, 38.00, 'Experta en cocina japonesa tradicional y fusión asiática. Especialista en sushi, tempura y técnicas de fermentación oriental. Mi formación en Tokyo Culinary Academy me permitió dominar las técnicas ancestrales japonesas, combinándolas con ingredientes locales salvadoreños.', 'San Miguel, San Miguel', 'Tokyo Culinary Academy, Certificación Sushi Master, Curso de Fermentación Asiática', NULL, 4.78, 156),
(362, 224, 'Cocina Francesa', 12, 65.00, 'Maestro de la alta cocina francesa con experiencia en restaurantes Michelin. Especialista en salsas clásicas, técnicas de confitado y presentación elegante. Formado en Le Cordon Bleu París, he trabajado en prestigiosos restaurantes europeos antes de establecerme en El Salvador.', 'Santa Tecla, La Libertad', 'Le Cordon Bleu París, Certificación Sommelier Nivel 2, Especialización en Salsas Clásicas', NULL, 4.92, 200),
(361, 223, 'Cocina Italiana', 8, 45.00, 'Chef especializada en auténtica cocina italiana con formación en Roma. Experta en pastas artesanales, risottos y técnicas tradicionales del norte de Italia. Mi pasión por la cocina italiana nació durante mis estudios en el Instituto Culinario de Roma, donde aprendí de maestros con generaciones de experiencia familiar.', 'San Salvador, San Salvador', 'Instituto Culinario de Roma, Certificación en Pasta Artesanal, Sommelier Nivel 1', NULL, 4.85, 144);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preferencias_usuario`
--

DROP TABLE IF EXISTS `preferencias_usuario`;
CREATE TABLE IF NOT EXISTS `preferencias_usuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `tipo` varchar(50) NOT NULL DEFAULT 'custom',
  `preferencia` varchar(100) NOT NULL,
  `fecha_agregada` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `preferencias_usuario`
--

INSERT INTO `preferencias_usuario` (`id`, `usuario_id`, `tipo`, `preferencia`, `fecha_agregada`) VALUES
(1, 53, 'dietary', 'Sin gluten', '2024-03-15 16:30:00'),
(2, 54, 'cuisine', 'Cocina Italiana', '2024-03-16 20:20:00'),
(3, 55, 'dietary', 'Vegetariano', '2024-03-17 22:45:00'),
(4, 56, 'cuisine', 'Cocina Francesa', '2024-03-18 17:15:00'),
(5, 57, 'dietary', 'Sin lactosa', '2024-03-19 15:30:00'),
(6, 58, 'cuisine', 'Cocina Asi├ítica', '2024-03-20 19:50:00'),
(7, 59, 'dietary', 'Vegano', '2024-03-21 21:25:00'),
(8, 60, 'cuisine', 'Cocina Mexicana', '2024-03-22 18:10:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recetas`
--

DROP TABLE IF EXISTS `recetas`;
CREATE TABLE IF NOT EXISTS `recetas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `chef_id` int NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text,
  `ingredientes` text NOT NULL,
  `instrucciones` text NOT NULL,
  `tiempo_preparacion` int DEFAULT NULL,
  `dificultad` enum('fácil','intermedio','difícil') DEFAULT NULL,
  `precio` decimal(8,2) NOT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `fecha_publicacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `activa` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `chef_id` (`chef_id`)
) ENGINE=MyISAM AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `recetas`
--

INSERT INTO `recetas` (`id`, `chef_id`, `titulo`, `descripcion`, `ingredientes`, `instrucciones`, `tiempo_preparacion`, `dificultad`, `precio`, `imagen`, `fecha_publicacion`, `activa`) VALUES
(88, 228, 'Asado Argentino Completo', 'Auténtico asado argentino con cortes tradicionales y técnica de parrilla a las brasas. Incluye chorizo, morcilla, vacío y entraña con chimichurri casero.', 'Vacío (800g), Entraña (600g), Chorizo criollo (4 unidades), Morcilla (2 unidades), Sal gruesa, Perejil (1 taza), Cilantro (1/2 taza), Ajo (4 dientes), Vinagre de vino tinto (60ml), Aceite de oliva (120ml), Ají molido, Orégano', '1. Encender el fuego con leña y esperar a tener brasas parejas. 2. Salar la carne 30 minutos antes de cocinar. 3. Comenzar con chorizo y morcilla a fuego medio. 4. Colocar el vacío del lado graso hacia las brasas. 5. Cocinar entraña a fuego fuerte por ambos lados. 6. Preparar chimichurri picando finamente hierbas y ajo. 7. Mezclar con vinagre, aceite y condimentos. 8. Servir la carne en tabla de madera con chimichurri.', 90, 'intermedio', 38.00, NULL, '2025-08-22 00:19:51', 1),
(87, 227, 'Macarons Franceses Clásicos', 'Delicados macarons franceses con técnica parisina tradicional. Perfecta textura crujiente por fuera y suave por dentro, con relleno de ganache de chocolate.', 'Harina de almendras (125g), Azúcar glass (200g), Claras de huevo (75g), Azúcar granulada (35g), Colorante alimentario, Chocolate negro (200g), Crema de leche (200ml), Mantequilla (30g)', '1. Tamizar harina de almendras y azúcar glass juntos. 2. Batir claras a punto de nieve, agregar azúcar gradualmente. 3. Incorporar colorante al merengue. 4. Hacer macaronage mezclando suavemente con movimientos envolventes. 5. Formar círculos en tapete de silicón con manga pastelera. 6. Dejar reposar 30 minutos hasta formar costra. 7. Hornear a 150°C por 15 minutos. 8. Preparar ganache calentando crema y vertiendo sobre chocolate. 9. Rellenar macarons una vez fríos.', 120, 'difícil', 25.00, NULL, '2025-08-22 00:19:51', 1),
(86, 226, 'Mole Poblano Tradicional', 'Auténtico mole poblano con más de 20 ingredientes, preparado según la receta tradicional de Puebla. Un platillo complejo que representa la esencia de la cocina mexicana.', 'Chiles mulatos (8), Chiles anchos (6), Chiles chipotle (4), Chocolate mexicano (100g), Almendras (50g), Cacahuates (50g), Ajonjolí (30g), Pasas (40g), Tomate (2), Cebolla (1), Ajo (4 dientes), Canela, Clavo, Pimienta negra, Anís estrella, Pollo (1.5kg)', '1. Tostar y desvenar los chiles, remojar en agua caliente. 2. Tostar almendras, cacahuates y ajonjolí por separado. 3. Asar tomate, cebolla y ajo. 4. Licuar todos los ingredientes en grupos con el agua de los chiles. 5. Freír cada mezcla por separado en aceite caliente. 6. Combinar todas las mezclas en una olla grande. 7. Agregar chocolate y especias molidas. 8. Cocinar a fuego lento por 2 horas, moviendo constantemente. 9. Servir sobre pollo cocido.', 180, 'difícil', 32.00, NULL, '2025-08-22 00:19:51', 1),
(84, 224, 'Coq au Vin Traditionnel', 'Clásico pollo al vino tinto francés, preparado según la receta tradicional de Borgoña. Un plato elegante que combina la técnica francesa con sabores profundos y complejos.', 'Pollo entero cortado en presas (1.5kg), Vino tinto Borgoña (750ml), Tocino (150g), Cebollitas perla (200g), Champiñones (250g), Zanahoria (2 unidades), Apio (2 tallos), Bouquet garni, Mantequilla (30g), Harina (2 cucharadas), Coñac (50ml)', '1. Marinar el pollo en vino tinto durante 4 horas. 2. Escurrir y secar las presas, reservar el vino. 3. Dorar el tocino cortado en cubos. 4. Dorar las presas de pollo en la grasa del tocino. 5. Flambear con coñac. 6. Agregar las verduras cortadas y el bouquet garni. 7. Cubrir con el vino de la marinada. 8. Cocinar a fuego lento por 1 hora. 9. Espesar la salsa con mantequilla y harina. 10. Servir con las cebollitas y champiñones salteados.', 90, 'difícil', 35.00, NULL, '2025-08-22 00:19:51', 1),
(85, 225, 'Sushi Omakase Selection', 'Selección de sushi tradicional japonés preparado con técnicas auténticas de Tokyo. Incluye nigiri, maki y sashimi con pescados de la más alta calidad.', 'Arroz para sushi (400g), Vinagre de arroz (60ml), Azúcar (20g), Sal (10g), Atún rojo (200g), Salmón (200g), Pargo (150g), Nori (10 hojas), Wasabi fresco, Jengibre encurtido, Salsa de soja', '1. Preparar el arroz sushi con vinagre, azúcar y sal. 2. Cortar el pescado en piezas para nigiri y sashimi. 3. Formar nigiri presionando suavemente el arroz. 4. Colocar el pescado sobre el arroz con un toque de wasabi. 5. Preparar maki enrollando arroz y pescado en nori. 6. Cortar los rollos con cuchillo afilado y húmedo. 7. Servir inmediatamente con wasabi, jengibre y salsa de soja.', 60, 'difícil', 42.00, NULL, '2025-08-22 00:19:51', 1),
(83, 223, 'Risotto ai Funghi Porcini', 'Auténtico risotto italiano con hongos porcini, preparado con la técnica tradicional del norte de Italia. Un plato cremoso y aromático que captura la esencia de la cocina italiana.', 'Arroz Arborio (300g), Hongos porcini secos (50g), Caldo de vegetales (1L), Vino blanco (150ml), Cebolla (1 unidad), Mantequilla (50g), Queso parmesano (100g), Aceite de oliva extra virgen, Sal y pimienta', '1. Hidratar los hongos porcini en agua tibia por 30 minutos. 2. Calentar el caldo y mantenerlo caliente. 3. Sofreír la cebolla picada en aceite de oliva. 4. Agregar el arroz y tostar por 2 minutos. 5. Añadir el vino blanco y cocinar hasta evaporar. 6. Incorporar el caldo caliente cucharón por cucharón, revolviendo constantemente. 7. Agregar los hongos hidratados y su líquido colado. 8. Cocinar por 18-20 minutos hasta que el arroz esté al dente. 9. Finalizar con mantequilla y queso parmesano.', 45, 'intermedio', 28.50, NULL, '2025-08-22 00:19:51', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recetas_favoritas`
--

DROP TABLE IF EXISTS `recetas_favoritas`;
CREATE TABLE IF NOT EXISTS `recetas_favoritas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `receta_id` int NOT NULL,
  `fecha_agregado` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_favorite` (`cliente_id`,`receta_id`),
  KEY `receta_id` (`receta_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

DROP TABLE IF EXISTS `servicios`;
CREATE TABLE IF NOT EXISTS `servicios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `chef_id` int NOT NULL,
  `fecha_servicio` date NOT NULL,
  `hora_servicio` time NOT NULL,
  `ubicacion_servicio` varchar(300) NOT NULL,
  `numero_comensales` int NOT NULL,
  `precio_total` decimal(10,2) NOT NULL,
  `estado` enum('pendiente','aceptado','rechazado','completado','cancelado') DEFAULT 'pendiente',
  `descripcion_evento` text,
  `fecha_solicitud` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_servicios_cliente` (`cliente_id`),
  KEY `idx_servicios_chef` (`chef_id`),
  KEY `idx_servicios_fecha` (`fecha_servicio`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `servicios`
--

INSERT INTO `servicios` (`id`, `cliente_id`, `chef_id`, `fecha_servicio`, `hora_servicio`, `ubicacion_servicio`, `numero_comensales`, `precio_total`, `estado`, `descripcion_evento`, `fecha_solicitud`) VALUES
(1, 2, 1, '2025-08-07', '23:40:00', 'dsa', 2, 50.00, 'cancelado', 'fasadasaaa', '2025-08-07 02:40:57'),
(2, 2, 1, '2025-08-09', '18:04:00', 'khydsjkla', 2, 75.00, 'pendiente', 'johsadjosb', '2025-08-08 00:04:16'),
(3, 2, 4, '2025-08-08', '18:20:00', 'hdajsb', 2, 105.00, 'pendiente', 'usgdhaijk', '2025-08-08 00:19:28'),
(4, 2, 1, '2025-08-08', '18:24:00', 'Casa', 2, 50.00, 'aceptado', 'Evento casual', '2025-08-08 00:24:57'),
(5, 53, 3, '2024-05-15', '19:30:00', 'Calle Alcal├í 123, Madrid', 6, 510.00, 'completado', 'Cena italiana para aniversario de bodas', '2024-05-10 20:30:00'),
(6, 54, 3, '2024-06-20', '20:00:00', 'Gran V├¡a 456, Barcelona', 8, 680.00, 'completado', 'Evento corporativo con men├║ italiano', '2024-06-15 16:15:00'),
(7, 55, 3, '2024-07-08', '18:00:00', 'Paseo de Gracia 789, Barcelona', 4, 340.00, 'completado', 'Cena rom├íntica con pasta fresca', '2024-07-03 22:45:00'),
(8, 56, 4, '2024-05-22', '19:00:00', 'Calle Serrano 234, Madrid', 10, 1200.00, 'completado', 'Cena francesa de gala para ejecutivos', '2024-05-17 17:20:00'),
(9, 57, 4, '2024-06-30', '20:30:00', 'Ramblas 567, Barcelona', 6, 720.00, 'completado', 'Celebraci├│n familiar con men├║ franc├®s', '2024-06-25 15:30:00'),
(10, 58, 4, '2024-08-12', '19:30:00', 'Calle Mayor 890, Madrid', 12, 1440.00, 'completado', 'Banquete de boda estilo franc├®s', '2024-08-07 19:50:00'),
(11, 59, 5, '2024-05-28', '18:30:00', 'Diagonal 123, Barcelona', 4, 300.00, 'completado', 'Cena japonesa tradicional', '2024-05-23 21:25:00'),
(12, 60, 5, '2024-07-15', '19:00:00', 'Puerta del Sol 456, Madrid', 8, 600.00, 'completado', 'Degustaci├│n de sushi para empresa', '2024-07-10 18:10:00'),
(13, 61, 5, '2024-08-25', '20:00:00', 'Sagrada Familia 789, Barcelona', 6, 450.00, 'completado', 'Cena kaiseki para ocasi├│n especial', '2024-08-20 14:40:00'),
(14, 62, 6, '2024-06-05', '19:30:00', 'Retiro 234, Madrid', 8, 520.00, 'completado', 'Fiesta mexicana con mole tradicional', '2024-05-31 23:55:00'),
(15, 63, 6, '2024-07-18', '18:00:00', 'Eixample 567, Barcelona', 10, 650.00, 'completado', 'Celebraci├│n con cocina mexicana aut├®ntica', '2024-07-13 20:35:00'),
(16, 64, 6, '2024-08-30', '20:30:00', 'Malasa├▒a 890, Madrid', 6, 390.00, 'completado', 'Cena ├¡ntima con especialidades mexicanas', '2024-08-25 16:20:00'),
(17, 65, 7, '2024-06-12', '16:00:00', 'Gr├ácia 123, Barcelona', 12, 840.00, 'completado', 'Taller de reposter├¡a y degustaci├│n', '2024-06-07 22:05:00'),
(18, 66, 7, '2024-07-25', '15:30:00', 'Chueca 456, Madrid', 8, 560.00, 'completado', 'Clase magistral de macarons franceses', '2024-07-20 17:45:00'),
(19, 67, 7, '2024-09-08', '17:00:00', 'Barceloneta 789, Barcelona', 6, 420.00, 'completado', 'Celebraci├│n con postres art├¡sticos', '2024-09-03 19:30:00'),
(20, 68, 8, '2024-06-18', '20:00:00', 'Salamanca 234, Madrid', 8, 1120.00, 'completado', 'Cena francesa molecular para gourmets', '2024-06-13 21:30:00'),
(21, 69, 9, '2024-07-02', '19:30:00', 'Poblenou 567, Barcelona', 6, 408.00, 'completado', 'Degustaci├│n de dim sum tradicional', '2024-06-27 17:45:00'),
(22, 70, 10, '2024-07-20', '18:00:00', 'Lavapi├®s 890, Madrid', 10, 600.00, 'completado', 'Parrillada brasile├▒a para cumplea├▒os', '2024-07-15 20:20:00'),
(23, 71, 11, '2024-08-05', '12:00:00', 'Sarri├á 123, Barcelona', 4, 220.00, 'completado', 'Almuerzo saludable para ejecutivos', '2024-07-31 15:15:00'),
(24, 72, 12, '2024-08-22', '19:00:00', 'Chamber├¡ 456, Madrid', 12, 1080.00, 'completado', 'Cena italiana tradicional familiar', '2024-08-17 22:30:00'),
(25, 192, 142, '2024-02-14', '19:00:00', 'San Salvador, Colonia Escalón', 2, 180.00, 'completado', 'Cena romántica italiana para San Valentín con menú de 4 tiempos', '2024-02-10 10:30:00'),
(26, 193, 142, '2024-03-15', '13:00:00', 'Santa Tecla, Residencial Los Robles', 8, 360.00, 'completado', 'Almuerzo familiar con especialidades italianas', '2024-03-12 09:20:00'),
(27, 194, 143, '2024-02-20', '20:00:00', 'San Salvador, Hotel Presidente', 6, 450.00, 'completado', 'Cena ejecutiva francesa para socios internacionales', '2024-02-18 11:15:00'),
(28, 195, 143, '2024-03-25', '19:30:00', 'Antiguo Cuscatlán, Casa privada', 4, 320.00, 'completado', 'Celebración de aniversario de bodas con menú degustación francés', '2024-03-22 14:40:00'),
(29, 192, 142, '2024-02-14', '19:00:00', 'San Salvador, Colonia Escalón', 2, 180.00, 'completado', 'Cena romántica italiana para San Valentín con menú de 4 tiempos', '2024-02-10 10:30:00'),
(30, 193, 142, '2024-03-15', '13:00:00', 'Santa Tecla, Residencial Los Robles', 8, 360.00, 'completado', 'Almuerzo familiar con especialidades italianas', '2024-03-12 09:20:00'),
(31, 194, 143, '2024-02-20', '20:00:00', 'San Salvador, Hotel Presidente', 6, 450.00, 'completado', 'Cena ejecutiva francesa para socios internacionales', '2024-02-18 11:15:00'),
(32, 195, 143, '2024-03-25', '19:30:00', 'Antiguo Cuscatlán, Casa privada', 4, 320.00, 'completado', 'Celebración de aniversario de bodas con menú degustación francés', '2024-03-22 14:40:00'),
(33, 192, 142, '2024-02-14', '19:00:00', 'San Salvador, Colonia Escalón', 2, 180.00, 'completado', 'Cena romántica italiana para San Valentín con menú de 4 tiempos', '2024-02-10 10:30:00'),
(34, 193, 142, '2024-03-15', '13:00:00', 'Santa Tecla, Residencial Los Robles', 8, 360.00, 'completado', 'Almuerzo familiar con especialidades italianas', '2024-03-12 09:20:00'),
(35, 194, 143, '2024-02-20', '20:00:00', 'San Salvador, Hotel Presidente', 6, 450.00, 'completado', 'Cena ejecutiva francesa para socios internacionales', '2024-02-18 11:15:00'),
(36, 195, 143, '2024-03-25', '19:30:00', 'Antiguo Cuscatlán, Casa privada', 4, 320.00, 'completado', 'Celebración de aniversario de bodas con menú degustación francés', '2024-03-22 14:40:00'),
(37, 273, 223, '2024-02-14', '19:00:00', 'San Salvador, Colonia Escalón', 2, 180.00, 'completado', 'Cena romántica italiana para San Valentín con menú de 4 tiempos', '2024-02-10 10:30:00'),
(38, 274, 223, '2024-03-15', '13:00:00', 'Santa Tecla, Residencial Los Robles', 8, 360.00, 'completado', 'Almuerzo familiar con especialidades italianas', '2024-03-12 09:20:00'),
(39, 275, 224, '2024-02-20', '20:00:00', 'San Salvador, Hotel Presidente', 6, 450.00, 'completado', 'Cena ejecutiva francesa para socios internacionales', '2024-02-18 11:15:00'),
(40, 276, 224, '2024-03-25', '19:30:00', 'Antiguo Cuscatlán, Casa privada', 4, 320.00, 'completado', 'Celebración de aniversario de bodas con menú degustación francés', '2024-03-22 14:40:00');

--
-- Disparadores `servicios`
--
DROP TRIGGER IF EXISTS `crear_conversacion_servicio_aceptado`;
DELIMITER $$
CREATE TRIGGER `crear_conversacion_servicio_aceptado` AFTER UPDATE ON `servicios` FOR EACH ROW BEGIN
    IF NEW.estado = 'aceptado' AND OLD.estado != 'aceptado' THEN
        INSERT IGNORE INTO conversaciones (servicio_id, cliente_id, chef_id)
        VALUES (NEW.id, NEW.cliente_id, NEW.chef_id);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `traducciones_categorias`
--

DROP TABLE IF EXISTS `traducciones_categorias`;
CREATE TABLE IF NOT EXISTS `traducciones_categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoria_id` int NOT NULL,
  `idioma` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_translation` (`categoria_id`,`idioma`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `traducciones_perfil_chef`
--

DROP TABLE IF EXISTS `traducciones_perfil_chef`;
CREATE TABLE IF NOT EXISTS `traducciones_perfil_chef` (
  `id` int NOT NULL AUTO_INCREMENT,
  `perfil_chef_id` int NOT NULL,
  `idioma` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `especialidad` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_translation` (`perfil_chef_id`,`idioma`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `traducciones_recetas`
--

DROP TABLE IF EXISTS `traducciones_recetas`;
CREATE TABLE IF NOT EXISTS `traducciones_recetas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `receta_id` int NOT NULL,
  `idioma` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `ingredientes` text COLLATE utf8mb4_unicode_ci,
  `instrucciones` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_translation` (`receta_id`,`idioma`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `traducciones_servicios`
--

DROP TABLE IF EXISTS `traducciones_servicios`;
CREATE TABLE IF NOT EXISTS `traducciones_servicios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `servicio_id` int NOT NULL,
  `idioma` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_translation` (`servicio_id`,`idioma`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transaction_logs`
--

DROP TABLE IF EXISTS `transaction_logs`;
CREATE TABLE IF NOT EXISTS `transaction_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_id` int NOT NULL,
  `tipo_transaccion` enum('recipe_purchase','service_payment','refund') COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `moneda` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT 'USD',
  `estado` enum('initiated','processing','completed','failed','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'initiated',
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gateway_response` text COLLATE utf8mb4_unicode_ci,
  `error_message` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_transaction_id` (`transaction_id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_tipo_transaccion` (`tipo_transaccion`),
  KEY `idx_estado` (`estado`),
  KEY `idx_fecha_creacion` (`fecha_creacion`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `translation_cache`
--

DROP TABLE IF EXISTS `translation_cache`;
CREATE TABLE IF NOT EXISTS `translation_cache` (
  `id` int NOT NULL AUTO_INCREMENT,
  `source_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_language` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'es',
  `target_language` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  `translated_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `text_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `usage_count` int DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_translation` (`text_hash`,`source_language`,`target_language`),
  KEY `idx_hash` (`text_hash`),
  KEY `idx_languages` (`source_language`,`target_language`),
  KEY `idx_usage_count` (`usage_count`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `translation_cache`
--

INSERT INTO `translation_cache` (`id`, `source_text`, `source_language`, `target_language`, `translated_text`, `text_hash`, `created_at`, `updated_at`, `usage_count`) VALUES
(1, 'Bienvenidos a nuestro restaurante', 'es', 'en', 'Welcome to our restaurant', '9b5655290dd01d8577f56911e7819de2e59431130792970a643974e588601cfb', '2025-08-10 20:28:30', '2025-08-10 20:28:30', 1),
(2, 'Hola mundo', 'es', 'en', 'Hello world', 'ca8f60b2cc7f05837d98b208b57fb6481553fc5f1219d59618fd025002a66f5c', '2025-08-10 20:28:37', '2025-08-10 20:41:33', 2),
(3, 'Nuestros Chefs', 'es', 'en', 'Our Chefs', '96169161c16322a61522ed0620510b47a3a9591bf8ab0059fc85ace34ffbec93', '2025-08-10 20:28:37', '2025-08-10 20:28:37', 1),
(4, 'Hello world', 'en', 'es', 'Hola mundo', '64ec88ca00b268e5ba1a35678a1b5316d212f4f366b2477232534a8aeca37f3c', '2025-08-10 20:28:44', '2025-08-10 20:28:44', 1),
(5, 'Welcome to our restaurant', 'en', 'es', 'Bienvenidos a nuestro restaurante', '9bc7c4ed6b5af62acd15d31dc3f87d13a4153b6cacd29f2e872d58520f433ab2', '2025-08-10 20:28:44', '2025-08-10 20:28:44', 1),
(6, 'Bienvenidos a La Délicatesse, donde la excelencia culinaria se encuentra con la comodidad de tu hogar.', 'es', 'en', 'Welcome to La Délicatesse, donde la excelencia culinaria se encuentra con la comodidad de tu hogar.', '20f5674d96355e3961e4392cae08efc0f92d73ee98985484b5f959ef865d9146', '2025-08-10 20:41:40', '2025-08-10 20:41:40', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `translation_config`
--

DROP TABLE IF EXISTS `translation_config`;
CREATE TABLE IF NOT EXISTS `translation_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `config_key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_config_key` (`config_key`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `translation_config`
--

INSERT INTO `translation_config` (`id`, `config_key`, `config_value`, `description`, `active`, `created_at`, `updated_at`) VALUES
(1, 'translation_enabled', '1', 'Habilitar/deshabilitar sistema de traducción', 1, '2025-08-10 20:25:41', '2025-08-10 20:25:41'),
(2, 'default_language', 'es', 'Idioma por defecto del sitio', 1, '2025-08-10 20:25:41', '2025-08-10 20:25:41'),
(3, 'supported_languages', 'es,en', 'Idiomas soportados separados por coma', 1, '2025-08-10 20:25:41', '2025-08-10 20:25:41'),
(4, 'cache_enabled', '1', 'Habilitar caché de traducciones', 1, '2025-08-10 20:25:41', '2025-08-10 20:25:41'),
(5, 'cache_expiry_days', '30', 'Días antes de que expire el caché', 1, '2025-08-10 20:25:41', '2025-08-10 20:25:41'),
(6, 'api_rate_limit', '100', 'Límite de llamadas a la API por hora', 1, '2025-08-10 20:25:41', '2025-08-10 20:25:41'),
(7, 'auto_translate_dynamic', '1', 'Traducir automáticamente contenido dinámico', 1, '2025-08-10 20:25:41', '2025-08-10 20:25:41'),
(8, 'auto_translate_static', '1', 'Traducir automáticamente contenido estático', 1, '2025-08-10 20:25:41', '2025-08-10 20:25:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `translation_stats`
--

DROP TABLE IF EXISTS `translation_stats`;
CREATE TABLE IF NOT EXISTS `translation_stats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `api_calls` int DEFAULT '0',
  `cache_hits` int DEFAULT '0',
  `characters_translated` int DEFAULT '0',
  `source_language` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'es',
  `target_language` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_daily_stats` (`date`,`source_language`,`target_language`),
  KEY `idx_date` (`date`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `translation_stats`
--

INSERT INTO `translation_stats` (`id`, `date`, `api_calls`, `cache_hits`, `characters_translated`, `source_language`, `target_language`, `created_at`, `updated_at`) VALUES
(1, '2025-08-10', 4, 0, 160, 'es', 'en', '2025-08-10 20:28:30', '2025-08-10 20:41:40'),
(2, '2025-08-10', 2, 0, 36, 'en', 'es', '2025-08-10 20:28:44', '2025-08-10 20:28:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `uso_cupones`
--

DROP TABLE IF EXISTS `uso_cupones`;
CREATE TABLE IF NOT EXISTS `uso_cupones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cupon_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto_descuento` decimal(8,2) NOT NULL,
  `fecha_uso` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cupon_id` (`cupon_id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_transaction_id` (`transaction_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `tipo_usuario` enum('cliente','chef') NOT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=304 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `telefono`, `tipo_usuario`, `fecha_registro`, `activo`) VALUES
(300, 'Edgardo Antonio Chávez', 'edgardo.chavez@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6890-1236', 'cliente', '2024-04-05 12:55:00', 1),
(299, 'Blanca Estela Navarro', 'blanca.navarro@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6789-0125', 'cliente', '2024-04-04 08:40:00', 1),
(297, 'Maritza Concepción Delgado', 'maritza.delgado@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6567-8903', 'cliente', '2024-04-02 14:25:00', 1),
(298, 'Víctor Manuel Montes', 'victor.montes@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6678-9014', 'cliente', '2024-04-03 16:35:00', 1),
(296, 'Rodrigo Enrique Mejía', 'rodrigo.mejia@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6456-7892', 'cliente', '2024-04-01 11:50:00', 1),
(295, 'Karina Esperanza Fuentes', 'karina.fuentes@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6345-6781', 'cliente', '2024-03-31 09:15:00', 1),
(294, 'Francisco Javier Reyes', 'francisco.reyes@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6234-5680', 'cliente', '2024-03-30 17:40:00', 1),
(292, 'Nelson Armando Campos', 'nelson.campos@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6123-4568', 'cliente', '2024-03-29 13:20:00', 1),
(293, 'Yesenia Maribel Molina', 'yesenia.molina@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6234-5679', 'cliente', '2024-03-30 17:25:00', 1),
(291, 'Ingrid Alejandra Sandoval', 'ingrid.sandoval@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6012-3457', 'cliente', '2024-03-28 10:30:00', 1),
(290, 'Héctor Ramón Cruz', 'hector.cruz@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6901-2346', 'cliente', '2024-03-27 15:10:00', 1),
(289, 'Daniela Alejandra Vargas', 'daniela.vargas@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6890-1235', 'cliente', '2024-03-26 12:45:00', 1),
(288, 'Raúl Eduardo Romero', 'raul.romero@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6789-0124', 'cliente', '2024-03-25 08:20:00', 1),
(287, 'Lorena Patricia Ortiz', 'lorena.ortiz@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6678-9013', 'cliente', '2024-03-24 16:15:00', 1),
(286, 'Gustavo Adolfo Silva', 'gustavo.silva@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6567-8902', 'cliente', '2024-03-23 14:55:00', 1),
(285, 'Verónica Esperanza Aguilar', 'veronica.aguilar@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6456-7891', 'cliente', '2024-03-22 11:35:00', 1),
(284, 'Sergio Armando Peña', 'sergio.pena@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6345-6780', 'cliente', '2024-03-21 09:50:00', 1),
(283, 'Karla Vanessa Guerrero', 'karla.guerrero@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6234-5679', 'cliente', '2024-03-20 17:25:00', 1),
(282, 'Fernando Gabriel Mendoza', 'fernando.mendoza@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6123-4567', 'cliente', '2024-03-19 13:40:00', 1),
(281, 'Mónica Isabel Castillo', 'monica.castillo@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6012-3456', 'cliente', '2024-03-18 10:10:00', 1),
(280, 'Alejandro Miguel Torres', 'alejandro.torres@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6901-2345', 'cliente', '2024-03-17 15:20:00', 1),
(279, 'Claudia Patricia Flores', 'claudia.flores@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6890-1234', 'cliente', '2024-03-16 12:00:00', 1),
(278, 'Eduardo José Ramírez', 'eduardo.ramirez@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6789-0123', 'cliente', '2024-03-15 08:45:00', 1),
(276, 'Manuel Antonio Herrera', 'manuel.herrera@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6567-8901', 'cliente', '2024-03-13 14:15:00', 1),
(277, 'Silvia Margarita López', 'silvia.lopez@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6678-9012', 'cliente', '2024-03-14 16:30:00', 1),
(275, 'Patricia Elena Vásquez', 'patricia.vasquez@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6456-7890', 'cliente', '2024-03-12 09:20:00', 1),
(274, 'Roberto Carlos Jiménez', 'roberto.jimenez@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6345-6789', 'cliente', '2024-03-11 11:45:00', 1),
(272, 'Julio César Hernández', 'julio.hernandez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7123-4571', 'chef', '2024-03-06 13:50:00', 1),
(273, 'Andrea Beatriz Morales', 'andrea.morales@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6234-5678', 'cliente', '2024-03-10 10:30:00', 1),
(271, 'Wendy Alejandra Gómez', 'wendy.gomez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7012-3460', 'chef', '2024-03-05 10:05:00', 1),
(270, 'Rolando Esteban Moreno', 'rolando.moreno@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7901-2349', 'chef', '2024-03-04 15:15:00', 1),
(269, 'Tatiana Marisol Cáceres', 'tatiana.caceres@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7890-1238', 'chef', '2024-03-03 12:35:00', 1),
(268, 'Edgardo Antonio Lemus', 'edgardo.lemus@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7789-0127', 'chef', '2024-03-02 08:50:00', 1),
(267, 'Blanca Estela Ramírez', 'blanca.ramirez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7678-9016', 'chef', '2024-03-01 16:25:00', 1),
(266, 'Víctor Manuel Solórzano', 'victor.solorzano@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7567-8905', 'chef', '2024-02-28 14:40:00', 1),
(264, 'Rodrigo Enrique Bonilla', 'rodrigo.bonilla@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7345-6783', 'chef', '2024-02-26 09:10:00', 1),
(265, 'Maritza Concepción Ayala', 'maritza.ayala@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7456-7894', 'chef', '2024-02-27 11:55:00', 1),
(263, 'Karina Esperanza Villalta', 'karina.villalta@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7234-5682', 'chef', '2024-02-25 17:20:00', 1),
(262, 'Francisco Javier Medrano', 'francisco.medrano@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7123-4570', 'chef', '2024-02-24 13:25:00', 1),
(260, 'Nelson Armando Córdoba', 'nelson.cordoba@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7901-2348', 'chef', '2024-02-22 15:35:00', 1),
(261, 'Yesenia Maribel Alfaro', 'yesenia.alfaro@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7012-3459', 'chef', '2024-02-23 10:45:00', 1),
(259, 'Ingrid Alejandra Zelaya', 'ingrid.zelaya@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7890-1237', 'chef', '2024-02-21 12:15:00', 1),
(258, 'Arturo Benjamín Quintanilla', 'arturo.quintanilla@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7789-0126', 'chef', '2024-02-20 08:30:00', 1),
(257, 'Silvia Margarita Escobar', 'silvia.escobar@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7678-9015', 'chef', '2024-02-19 16:50:00', 1),
(256, 'Mauricio Ernesto Benítez', 'mauricio.benitez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7567-8904', 'chef', '2024-02-18 14:15:00', 1),
(255, 'Roxana Guadalupe Portillo', 'roxana.portillo@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7456-7893', 'chef', '2024-02-17 11:40:00', 1),
(254, 'Emilio Francisco Sánchez', 'emilio.sanchez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7345-6782', 'chef', '2024-02-16 09:25:00', 1),
(253, 'Verónica Esperanza Chávez', 'veronica.chavez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7234-5681', 'chef', '2024-02-15 17:10:00', 1),
(252, 'Gustavo Adolfo Navarro', 'gustavo.navarro@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7123-4569', 'chef', '2024-02-14 13:45:00', 1),
(251, 'Lorena Patricia Montes', 'lorena.montes@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7012-3458', 'chef', '2024-02-13 10:20:00', 1),
(250, 'Héctor Ramón Delgado', 'hector.delgado@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7901-2347', 'chef', '2024-02-12 15:05:00', 1),
(249, 'Karla Vanessa Mejía', 'karla.mejia@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7890-1236', 'chef', '2024-02-11 12:55:00', 1),
(248, 'Sergio Armando Fuentes', 'sergio.fuentes@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7789-0125', 'chef', '2024-02-10 08:40:00', 1),
(247, 'Adriana Beatriz Reyes', 'adriana.reyes@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7678-9014', 'chef', '2024-02-09 16:35:00', 1),
(246, 'Raúl Eduardo Molina', 'raul.molina@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7567-8903', 'chef', '2024-02-08 14:25:00', 1),
(245, 'Daniela Alejandra Campos', 'daniela.campos@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7456-7892', 'chef', '2024-02-07 11:50:00', 1),
(244, 'Óscar Mauricio Sandoval', 'oscar.sandoval@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7345-6781', 'chef', '2024-02-06 09:15:00', 1),
(243, 'Natalia Carolina Cruz', 'natalia.cruz@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7234-5680', 'chef', '2024-02-05 17:40:00', 1),
(242, 'Alejandro José Vargas', 'alejandro.vargas@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7123-4568', 'chef', '2024-02-04 13:20:00', 1),
(241, 'Mónica Isabel Herrera', 'monica.herrera@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7012-3457', 'chef', '2024-02-03 10:30:00', 1),
(240, 'Javier Augusto Romero', 'javier.romero@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7901-2346', 'chef', '2024-02-02 15:10:00', 1),
(239, 'Paola Fernanda Ortiz', 'paola.ortiz@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7890-1235', 'chef', '2024-02-01 12:45:00', 1),
(238, 'Ricardo Enrique Silva', 'ricardo.silva@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7789-0124', 'chef', '2024-01-30 08:20:00', 1),
(237, 'Valeria Cristina Torres', 'valeria.torres@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7678-9013', 'chef', '2024-01-29 16:15:00', 1),
(236, 'Andrés Felipe Aguilar', 'andres.aguilar@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7567-8902', 'chef', '2024-01-28 14:55:00', 1),
(235, 'Gabriela Esther Mendoza', 'gabriela.mendoza@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7456-7891', 'chef', '2024-01-27 11:35:00', 1),
(234, 'Diego Alejandro Peña', 'diego.pena@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7345-6780', 'chef', '2024-01-26 09:50:00', 1),
(233, 'Lucía Beatriz Jiménez', 'lucia.jimenez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7234-5679', 'chef', '2024-01-25 17:25:00', 1),
(232, 'Miguel Ángel Guerrero', 'miguel.guerrero@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7123-4567', 'chef', '2024-01-24 13:40:00', 1),
(231, 'Claudia Patricia Ramos', 'claudia.ramos@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7012-3456', 'chef', '2024-01-23 10:10:00', 1),
(230, 'Fernando Gabriel Castillo', 'fernando.castillo@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7901-2345', 'chef', '2024-01-22 15:20:00', 1),
(229, 'Sofía Alejandra Morales', 'sofia.morales@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7890-1234', 'chef', '2024-01-21 12:00:00', 1),
(228, 'Roberto Carlos Vásquez', 'roberto.vasquez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7789-0123', 'chef', '2024-01-20 08:45:00', 1),
(227, 'Carmen Elena Flores', 'carmen.flores@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7678-9012', 'chef', '2024-01-19 16:30:00', 1),
(226, 'José Antonio López', 'jose.lopez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7567-8901', 'chef', '2024-01-18 14:15:00', 1),
(225, 'María José Rodríguez', 'maria.rodriguez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7456-7890', 'chef', '2024-01-17 09:20:00', 1),
(224, 'Carlos Eduardo Martínez', 'carlos.martinez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7345-6789', 'chef', '2024-01-16 11:45:00', 1),
(223, 'Ana María Hernández', 'ana.hernandez@chef.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '7234-5678', 'chef', '2024-01-15 10:30:00', 1),
(301, 'Tatiana Marisol Sánchez', 'tatiana.sanchez@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6901-2347', 'cliente', '2024-04-06 15:05:00', 1),
(302, 'Rolando Esteban Portillo', 'rolando.portillo@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6012-3458', 'cliente', '2024-04-07 10:20:00', 1),
(303, 'Wendy Alejandra Benítez', 'wendy.benitez@cliente.sv', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '6123-4569', 'cliente', '2024-04-08 13:45:00', 1);

-- --------------------------------------------------------

--
-- Estructura para la vista `payment_stats`
--
DROP TABLE IF EXISTS `payment_stats`;

DROP VIEW IF EXISTS `payment_stats`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `payment_stats`  AS SELECT cast(`cr`.`fecha_compra` as date) AS `fecha`, count(0) AS `total_transacciones`, sum(`cr`.`precio_pagado`) AS `ingresos_totales`, avg(`cr`.`precio_pagado`) AS `ticket_promedio`, count((case when (`cr`.`payment_status` = 'completed') then 1 end)) AS `transacciones_exitosas`, count((case when (`cr`.`payment_status` = 'failed') then 1 end)) AS `transacciones_fallidas`, ((count((case when (`cr`.`payment_status` = 'completed') then 1 end)) * 100.0) / count(0)) AS `tasa_exito` FROM `compras_recetas` AS `cr` GROUP BY cast(`cr`.`fecha_compra` as date) ORDER BY `fecha` DESC ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
