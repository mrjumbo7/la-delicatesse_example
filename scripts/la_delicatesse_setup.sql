-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 07-08-2025 a las 00:53:25
-- Versión del servidor: 8.3.0
-- Versión de PHP: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- Configuración UTF-8 para compatibilidad completa
SET character_set_client = utf8mb4;
SET character_set_connection = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_unicode_ci;

--
-- Base de datos: `la_delicatesse`
--

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`, `fecha_creacion`) VALUES
(1, 'Cocina Internacional', 'Platos y técnicas culinarias de diferentes países del mundo', '2025-08-06 23:43:10'),
(2, 'Cocina Italiana', 'Especialidades tradicionales de Italia, incluyendo pastas, pizzas y risottos', '2025-08-06 23:43:10'),
(3, 'Cocina Francesa', 'Alta cocina francesa con técnicas clásicas y refinadas', '2025-08-06 23:43:10'),
(4, 'Cocina Asiática', 'Sabores orientales incluyendo cocina china, japonesa, tailandesa y más', '2025-08-06 23:43:10'),
(5, 'Cocina Mexicana', 'Auténticos sabores mexicanos con especias tradicionales', '2025-08-06 23:43:10'),
(6, 'Repostería', 'Postres, pasteles, galletas y dulces artesanales', '2025-08-06 23:43:10'),
(7, 'Cocina Saludable', 'Recetas nutritivas y balanceadas para un estilo de vida saludable', '2025-08-06 23:43:10'),
(8, 'Cocina Vegetariana', 'Platos sin carne con ingredientes frescos y naturales', '2025-08-06 23:43:10'),
(9, 'Cocina Vegana', 'Recetas completamente libres de productos de origen animal', '2025-08-06 23:43:10'),
(10, 'Parrilladas', 'Especialidades a la parrilla y técnicas de asado', '2025-08-06 23:43:10');

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `fecha_compra` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `receta_id` (`receta_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `perfiles_chef`
--

INSERT INTO `perfiles_chef` (`id`, `usuario_id`, `especialidad`, `experiencia_anos`, `precio_por_hora`, `biografia`, `ubicacion`, `certificaciones`, `foto_perfil`, `calificacion_promedio`, `total_servicios`) VALUES
(1, 1, 'Cocina General', NULL, 25.00, NULL, NULL, NULL, NULL, 0.00, 0);

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `dificultad` enum('fácil','intermedio','difícil') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `precio` decimal(8,2) NOT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `fecha_publicacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `activa` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `chef_id` (`chef_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `idioma` char(2) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` text,
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
  `idioma` char(2) NOT NULL,
  `titulo` varchar(100) DEFAULT NULL,
  `descripcion` text,
  `especialidad` varchar(100) DEFAULT NULL,
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
  `idioma` char(2) NOT NULL,
  `titulo` varchar(100) DEFAULT NULL,
  `descripcion` text,
  `ingredientes` text,
  `instrucciones` text,
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
  `idioma` char(2) NOT NULL,
  `titulo` varchar(100) DEFAULT NULL,
  `descripcion` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_translation` (`servicio_id`,`idioma`)
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
  `direccion` text,
  `fecha_nacimiento` date DEFAULT NULL,
  `tipo_usuario` enum('cliente','chef') NOT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `telefono`, `direccion`, `fecha_nacimiento`, `tipo_usuario`, `fecha_registro`, `activo`) VALUES
(1, 'Aaron', 'aaron@gmail.com', '$2y$10$MfDST/faG4YUHoOjhkNDGuns5is7PDJgabByFc.79hpoU.AbOPZVy', '1234-5678', NULL, NULL, 'chef', '2025-08-07 00:41:54', 1),
(2, 'chele', 'chele@gmail.com', '$2y$10$9LNUYzeKxjTbIDQ6k4mjBOLRfzWi/Zr0rvbdRHcTZ7PLUuq3G0At6', '1234-5678', NULL, NULL, 'cliente', '2025-08-07 00:43:01', 1);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
