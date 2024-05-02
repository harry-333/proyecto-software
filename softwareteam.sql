-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-05-2024 a las 05:06:36
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `softwareteam`
--
CREATE DATABASE IF NOT EXISTS `softwareteam` DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish2_ci;
USE `softwareteam`;

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_palabra_clave_en_auditoria` (IN `palabra_clave` VARCHAR(255))   BEGIN
    SELECT * FROM auditoria WHERE 
    sql_ejecutado LIKE CONCAT('%', palabra_clave, '%') OR
    valor_anterior LIKE CONCAT('%', palabra_clave, '%') OR
    valor_nuevo LIKE CONCAT('%', palabra_clave, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_registros_auditoria_por_fecha_usuario` (IN `fecha_busqueda` DATE, IN `usuario_id` INT)   BEGIN
    IF fecha_busqueda IS NOT NULL AND usuario_id IS NOT NULL THEN
        SELECT * FROM auditoria WHERE DATE(fecha_hora) = fecha_busqueda AND id_usuario = usuario_id;
    ELSEIF fecha_busqueda IS NOT NULL THEN
        SELECT * FROM auditoria WHERE DATE(fecha_hora) = fecha_busqueda;
    ELSEIF usuario_id IS NOT NULL THEN
        SELECT * FROM auditoria WHERE id_usuario = usuario_id;
    ELSE
        SELECT * FROM auditoria;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_todos_registros_auditoria` ()   BEGIN
    SELECT * FROM auditoria;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `agenda`
--

CREATE TABLE `agenda` (
  `id_agenda` int(11) NOT NULL COMMENT 'Identificador primario',
  `comentarios` text NOT NULL COMMENT 'Comentarios por parte del rol de Usuario',
  `fecha_hora` datetime NOT NULL COMMENT 'Fecha y hora generada de la agenda',
  `id_propiedad` int(11) NOT NULL COMMENT 'Identificador foraneo, asociado a la tabla propiedad',
  `id_usuario` int(11) NOT NULL COMMENT 'Identificador foraneo, asociado a la tabla de usuario',
  `id_vendedor` int(11) NOT NULL COMMENT 'Identificador del usuario con rol vendedor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Disparadores `agenda`
--
DELIMITER $$
CREATE TRIGGER `audit_actualizar_agenda` AFTER UPDATE ON `agenda` FOR EACH ROW BEGIN
    
    DECLARE old_values TEXT;
    DECLARE new_values TEXT;
    DECLARE sql_command TEXT;
    
    -- Construir la cadena de valores anteriores (old_values)
    SET old_values = CONCAT(
        'id_agenda: ', OLD.id_agenda, ', ',
        'comentarios: ', OLD.comentarios, ', ',
        'fecha_hora: ', OLD.fecha_hora, ', ',
        'id_propiedad: ', OLD.id_propiedad, ', ',
        'id_usuario: ', OLD.id_usuario, ', ',
        'id_vendedor: ', OLD.id_vendedor
    );
    
    -- Construir la cadena de valores actuales (new_values)
    SET new_values = CONCAT(
        'id_agenda: ', NEW.id_agenda, ', ',
        'comentarios: ', NEW.comentarios, ', ',
        'fecha_hora: ', NEW.fecha_hora, ', ',
        'id_propiedad: ', NEW.id_propiedad, ', ',
        'id_usuario: ', NEW.id_usuario, ', ',
        'id_vendedor: ', NEW.id_vendedor
    );
    
    -- Construir la consulta SQL ejecutada
    SET sql_command = CONCAT(
        'UPDATE agenda SET ',
        'comentarios = ', QUOTE(NEW.comentarios), ', ',
        'fecha_hora = ', QUOTE(NEW.fecha_hora), ', ',
        'id_propiedad = ', NEW.id_propiedad, ', ',
        'id_usuario = ', NEW.id_usuario, ', ',
        'id_vendedor = ', NEW.id_vendedor,
        ' WHERE id_agenda = ', OLD.id_agenda
    );
    
    -- Insertar una fila en la tabla de auditoría
    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_anterior, valor_nuevo)
    VALUES (OLD.id_usuario, 'UPDATE', NOW(), sql_command, old_values, new_values);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_crear_agenda` AFTER INSERT ON `agenda` FOR EACH ROW BEGIN

    DECLARE sql_command TEXT;
    
    -- Construir la consulta SQL ejecutada
    SET sql_command = CONCAT(
        'INSERT INTO agenda (id_agenda, comentarios, fecha_hora, id_propiedad, id_usuario, id_vendedor) VALUES (',
        NEW.id_agenda, ', ',
        QUOTE(NEW.comentarios), ', ',
        QUOTE(NEW.fecha_hora), ', ',
        NEW.id_propiedad, ', ',
        NEW.id_usuario, ', ',
        NEW.id_vendedor, ')'
    );
    
    -- Insertar una fila en la tabla de auditoría
    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_nuevo)
    VALUES (NEW.id_usuario, 'CREATE', NOW(), sql_command, 'Nueva entrada en agenda creada');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id` int(11) NOT NULL COMMENT 'Identificador primario',
  `id_usuario` int(11) NOT NULL COMMENT 'Identificador foraneo, asociado a la tabla Usuario',
  `accion` enum('CREATE','UPDATE','','') NOT NULL COMMENT 'Acción realizada ',
  `fecha_hora` datetime NOT NULL COMMENT 'Fecha y hora de la acción ',
  `sql_ejecutado` text DEFAULT NULL COMMENT 'SQL ejecutado dependiendo de la acción realizada en las tablas del sistema',
  `valor_anterior` text DEFAULT NULL COMMENT 'Valores antes de ser modificados de la tabla',
  `valor_nuevo` text DEFAULT NULL COMMENT 'Valores modificados de la tabla'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`id`, `id_usuario`, `accion`, `fecha_hora`, `sql_ejecutado`, `valor_anterior`, `valor_nuevo`) VALUES
(13, 19, 'CREATE', '2024-04-11 17:30:45', 'INSERT INTO usuario (id, id_rol, nombre, apellido, correo, contrasena, telefono, descripcion, documento, tipo_documento) VALUES (19, 2, \'Juan\', \'Pérez\', \'usuario@example.com\', \'$2b$10$O.vJCV0BC4mniaDYK8muf.FiAngyLL01CQl0cpoXfpPu71Z92hET6\', \'1234567890\', \'Descripción del usuario\', \'123456789\', 1)', NULL, 'Nuevo usuario creado'),
(14, 13, 'UPDATE', '2024-04-11 17:32:00', 'UPDATE usuario SET id = 19, id_rol = 2, nombre = \'Juan\', apellido = \'Pérez\', correo = \'usuario@example.com\', contrasena = \'$2b$10$O.vJCV0BC4mniaDYK8muf.FiAngyLL01CQl0cpoXfpPu71Z92hET6\', telefono = \'3114567890\', descripcion = \'Descripción del usuario\', documento = \'123456789\', tipo_documento = 1 WHERE id = 19', 'id: 19, id_rol: 2, nombre: Juan, apellido: Pérez, correo: usuario@example.com, contrasena: $2b$10$O.vJCV0BC4mniaDYK8muf.FiAngyLL01CQl0cpoXfpPu71Z92hET6, telefono: 1234567890, descripcion: Descripción del usuario, documento: 123456789, tipo_documento: 1', 'id: 19, id_rol: 2, nombre: Juan, apellido: Pérez, correo: usuario@example.com, contrasena: $2b$10$O.vJCV0BC4mniaDYK8muf.FiAngyLL01CQl0cpoXfpPu71Z92hET6, telefono: 3114567890, descripcion: Descripción del usuario, documento: 123456789, tipo_documento: 1'),
(15, 20, 'CREATE', '2024-04-11 18:17:36', 'INSERT INTO usuario (id, id_rol, nombre, apellido, correo, contrasena, telefono, descripcion, documento, tipo_documento) VALUES (20, 3, \'Nicolas\', \'Campos\', \'yimmernicolas@gmail.com\', \'$2b$10$QPWwDkvXV8o6s2pznsLdSOeU2aw0O72k4rncPctf9yGAXU56kSway\', \'3214663210\', \'Hola, soy una prueba\', \'1073527466\', 2)', NULL, 'Nuevo usuario creado'),
(16, 21, 'CREATE', '2024-04-11 18:30:28', 'INSERT INTO usuario (id, id_rol, nombre, apellido, correo, contrasena, telefono, descripcion, documento, tipo_documento) VALUES (21, 3, \'Nicolas\', \'Campos\', \'yimmernicolas@gmail.com\', \'$2b$10$I/ma5qRBpTVG4JoJrVQqhO3a5sy0W9E11zIgu5Wglvbu6HOtCjVuG\', \'3214663210\', \'Hola, soy una prueba\', \'1073527466\', 2)', NULL, 'Nuevo usuario creado'),
(17, 13, 'CREATE', '2024-04-19 11:19:25', 'INSERT INTO tipo_negocio (id_tipoNeg, desc_Neg) VALUES (6, \'Prueba\')', NULL, 'Nuevo tipo de negocio creado'),
(18, 13, 'UPDATE', '2024-04-19 19:01:03', 'UPDATE tipo_negocio SET id_tipoNeg = 6, desc_Neg = Prueba2 WHERE id_tipoNeg = 6', 'id_tipoNeg: 6, desc_Neg: Prueba', 'id_tipoNeg: 6, desc_Neg: Prueba2'),
(19, 13, 'UPDATE', '2024-04-19 19:28:26', 'UPDATE tipo_negocio SET id_tipoNeg = 6, desc_Neg = Venta Directa WHERE id_tipoNeg = 6', 'id_tipoNeg: 6, desc_Neg: Prueba2', 'id_tipoNeg: 6, desc_Neg: Venta Directa'),
(20, 13, 'CREATE', '2024-04-19 19:28:58', 'INSERT INTO tipo_negocio (id_tipoNeg, desc_Neg) VALUES (7, \'Contrato de Servicio\')', NULL, 'Nuevo tipo de negocio creado'),
(21, 13, 'CREATE', '2024-04-19 19:29:23', 'INSERT INTO tipo_negocio (id_tipoNeg, desc_Neg) VALUES (8, \'Suscripción\')', NULL, 'Nuevo tipo de negocio creado'),
(22, 13, 'CREATE', '2024-04-19 19:29:54', 'INSERT INTO tipo_negocio (id_tipoNeg, desc_Neg) VALUES (9, \'Negocio B2B\')', NULL, 'Nuevo tipo de negocio creado'),
(23, 13, 'CREATE', '2024-04-19 19:30:12', 'INSERT INTO tipo_negocio (id_tipoNeg, desc_Neg) VALUES (10, \'Negocio B2C\')', NULL, 'Nuevo tipo de negocio creado'),
(24, 13, 'CREATE', '2024-04-19 19:30:58', 'INSERT INTO tipo_negocio (id_tipoNeg, desc_Neg) VALUES (11, \'Comercio Electrónico\')', NULL, 'Nuevo tipo de negocio creado'),
(25, 13, 'CREATE', '2024-04-19 19:34:15', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (3, \'Apartamento\')', NULL, 'Nuevo tipo de propiedad creado'),
(26, 13, 'CREATE', '2024-04-19 19:34:55', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (4, \'Oficina\')', NULL, 'Nuevo tipo de propiedad creado'),
(27, 13, 'CREATE', '2024-04-19 19:34:55', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (5, \'Lote / Terreno\')', NULL, 'Nuevo tipo de propiedad creado'),
(28, 13, 'CREATE', '2024-04-19 19:35:27', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (6, \'Consultorio\')', NULL, 'Nuevo tipo de propiedad creado'),
(29, 13, 'CREATE', '2024-04-19 19:35:27', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (7, \'Casa\')', NULL, 'Nuevo tipo de propiedad creado'),
(30, 13, 'CREATE', '2024-04-19 19:35:53', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (8, \'Apartaestudio\')', NULL, 'Nuevo tipo de propiedad creado'),
(31, 13, 'CREATE', '2024-04-19 19:35:53', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (9, \'Finca\')', NULL, 'Nuevo tipo de propiedad creado'),
(32, 13, 'CREATE', '2024-04-19 19:36:13', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (10, \'Bodega\')', NULL, 'Nuevo tipo de propiedad creado'),
(33, 13, 'CREATE', '2024-04-19 19:36:13', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (11, \'Local\')', NULL, 'Nuevo tipo de propiedad creado'),
(34, 13, 'CREATE', '2024-04-19 19:37:09', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (12, \'Deposito\')', NULL, 'Nuevo tipo de propiedad creado'),
(35, 13, 'CREATE', '2024-04-19 19:37:09', 'INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (13, \'Edificio\')', NULL, 'Nuevo tipo de propiedad creado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `propiedad`
--

CREATE TABLE `propiedad` (
  `id_propiedad` int(11) NOT NULL COMMENT 'Identificador primario',
  `id_tipoNeg` int(11) NOT NULL COMMENT 'Identificador foraneo, campo asociado a la tabla tipo_negocio',
  `titulo` varchar(20) NOT NULL COMMENT 'Titulo de la inmobiliaria',
  `ciudad` varchar(20) NOT NULL COMMENT 'Ciudad de la inmobiliaria',
  `direccion` varchar(50) NOT NULL COMMENT 'Dirección de la inmobiliaria',
  `precio` bigint(20) NOT NULL COMMENT 'Precio de la inmobiliaria (Pesos colombianos)',
  `No_habitaciones` int(11) NOT NULL COMMENT 'Número de habitaciones',
  `No_banos` int(11) NOT NULL COMMENT 'Número de baños',
  `desc_prop` mediumtext NOT NULL COMMENT 'Descripción de la inmobiliaria',
  `id_tipoProp` int(11) NOT NULL COMMENT 'Identificador foráneo, campo asociado a la tabla tipo_propiedad ',
  `area_construida` int(11) NOT NULL COMMENT 'Área construida de la inmobiliaria, en metros cuadrados',
  `id_vendedor` int(11) NOT NULL COMMENT 'Identificador foráneo, campo asociado a la tabla usuario. Solo para usuario rol Administrador y Vendedor '
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Disparadores `propiedad`
--
DELIMITER $$
CREATE TRIGGER `audit_actualizar_propiedad` AFTER UPDATE ON `propiedad` FOR EACH ROW BEGIN
    
    DECLARE old_values TEXT;
    DECLARE new_values TEXT;
    DECLARE sql_command TEXT;
    
    -- Construir la cadena de valores anteriores (old_values)
    SET old_values = CONCAT(
        'id_propiedad: ', OLD.id_propiedad, ', ',
        'id_tipoNeg: ', OLD.id_tipoNeg, ', ',
        'id_tipoProp: ', OLD.id_tipoProp, ', ',
        'id_vendedor: ', OLD.id_vendedor, ', ',
        'titulo: ', OLD.titulo, ', ',
        'ciudad: ', OLD.ciudad, ', ',
        'direccion: ', OLD.direccion, ', ',
        'precio: ', OLD.precio, ', ',
        'No_habitaciones: ', OLD.No_habitaciones, ', ',
        'No_banos: ', OLD.No_banos, ', ',
        'desc_prop: ', OLD.desc_prop, ', ',
        'area_construida: ', OLD.area_construida
    );
    
    -- Construir la cadena de valores actuales (new_values)
    SET new_values = CONCAT(
        'id_propiedad: ', NEW.id_propiedad, ', ',
        'id_tipoNeg: ', NEW.id_tipoNeg, ', ',
        'id_tipoProp: ', NEW.id_tipoProp, ', ',
        'id_vendedor: ', NEW.id_vendedor, ', ',
        'titulo: ', NEW.titulo, ', ',
        'ciudad: ', NEW.ciudad, ', ',
        'direccion: ', NEW.direccion, ', ',
        'precio: ', NEW.precio, ', ',
        'No_habitaciones: ', NEW.No_habitaciones, ', ',
        'No_banos: ', NEW.No_banos, ', ',
        'desc_prop: ', NEW.desc_prop, ', ',
        'area_construida: ', NEW.area_construida
    );
    
    -- Construir la consulta SQL ejecutada
    SET sql_command = CONCAT(
        'UPDATE propiedad SET ',
        'id_propiedad = ', NEW.id_propiedad, ', ',
        'id_tipoNeg = ', NEW.id_tipoNeg, ', ',
        'id_tipoProp = ', NEW.id_tipoProp, ', ',
        'id_vendedor = ', NEW.id_vendedor, ', ',
        'titulo = ', QUOTE(NEW.titulo), ', ',
        'ciudad = ', QUOTE(NEW.ciudad), ', ',
        'direccion = ', QUOTE(NEW.direccion), ', ',
        'precio = ', NEW.precio, ', ',
        'No_habitaciones = ', NEW.No_habitaciones, ', ',
        'No_banos = ', NEW.No_banos, ', ',
        'desc_prop = ', QUOTE(NEW.desc_prop), ', ',
        'area_construida = ', NEW.area_construida,
        ' WHERE id_propiedad = ', OLD.id_propiedad
    );
    
    -- Insertar una fila en la tabla de auditoría
    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_anterior, valor_nuevo)
    VALUES (OLD.id_vendedor, 'UPDATE', NOW(), sql_command, old_values, new_values);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_crear_propiedad` AFTER INSERT ON `propiedad` FOR EACH ROW BEGIN

    DECLARE sql_command TEXT;
     
    -- Construir la consulta SQL ejecutada
    SET sql_command = CONCAT(
        'INSERT INTO propiedad (id_propiedad, id_tipoNeg, id_tipoProp, id_vendedor, titulo, ciudad, direccion, precio, No_habitaciones, No_banos, desc_prop, area_construida) VALUES (',
        NEW.id_propiedad, ', ',
        NEW.id_tipoNeg, ', ',
        NEW.id_tipoProp, ', ',
        NEW.id_vendedor, ', ',
        QUOTE(NEW.titulo), ', ',
        QUOTE(NEW.ciudad), ', ',
        QUOTE(NEW.direccion), ', ',
        NEW.precio, ', ',
        NEW.No_habitaciones, ', ',
        NEW.No_banos, ', ',
        QUOTE(NEW.desc_prop), ', ',
        NEW.area_construida, ')'
    );
    
    -- Insertar una fila en la tabla de auditoría
    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_nuevo)
    VALUES (NEW.id_vendedor, 'CREATE', NOW(), sql_command, 'Nueva propiedad creada');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id` int(11) NOT NULL COMMENT 'Identificador primario',
  `descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripción de rol'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id`, `descripcion`) VALUES
(1, 'Administrador'),
(2, 'Vendedor'),
(3, 'Usuario');

--
-- Disparadores `rol`
--
DELIMITER $$
CREATE TRIGGER `audit_actualizar_rol` AFTER UPDATE ON `rol` FOR EACH ROW BEGIN
    DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE old_values TEXT;
    DECLARE new_values TEXT;
	DECLARE sql_command TEXT;
    
    -- Construir la cadena de valores anteriores (old_values)
    SET old_values = CONCAT(
        'id: ', OLD.id, ', ',
        'descripcion: ', OLD.descripcion
    );
    
    -- Construir la cadena de valores actuales (new_values)
    SET new_values = CONCAT(
        'id: ', NEW.id, ', ',
        'descripcion: ', NEW.descripcion
    );
    
    -- Construir la consulta SQL ejecutada
    SET sql_command = CONCAT(
        'UPDATE rol SET ',
        'id = ', NEW.id, ', ',
        'descripcion = ', NEW.descripcion,
        ' WHERE id = ', OLD.id
    );
    
    -- Insertar una fila en la tabla de auditoría
    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_anterior, valor_nuevo)
    VALUES (admin_id, 'UPDATE', NOW(), sql_command, old_values, new_values);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_crear_rol` AFTER INSERT ON `rol` FOR EACH ROW BEGIN
  	DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE sql_command TEXT;
    
    
    -- Construir el comando SQL ejecutado
    SET sql_command = CONCAT('INSERT INTO rol (id, descripcion) VALUES (', NEW.id, ', ', 		QUOTE(NEW.descripcion), ')');

    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_nuevo)
    VALUES (admin_id, 'CREATE', NOW(), sql_command, 'Nuevo rol creado');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_documento`
--

CREATE TABLE `tipo_documento` (
  `id` int(11) NOT NULL COMMENT 'Identificador primario',
  `descripcion` varchar(50) NOT NULL COMMENT 'Descripción de tipo de documento'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `tipo_documento`
--

INSERT INTO `tipo_documento` (`id`, `descripcion`) VALUES
(1, 'DNI'),
(2, 'CC');

--
-- Disparadores `tipo_documento`
--
DELIMITER $$
CREATE TRIGGER `audit_actualizar_tipoDocumento` AFTER UPDATE ON `tipo_documento` FOR EACH ROW BEGIN
    DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE old_values TEXT;
    DECLARE new_values TEXT;
	DECLARE sql_command TEXT;
    
    -- Construir la cadena de valores anteriores (old_values)
    SET old_values = CONCAT(
        'id: ', OLD.id, ', ',
        'descripcion: ', OLD.descripcion
    );
    
    -- Construir la cadena de valores actuales (new_values)
    SET new_values = CONCAT(
        'id: ', NEW.id, ', ',
        'descripcion: ', NEW.descripcion
    );
    
    -- Construir la consulta SQL ejecutada
    SET sql_command = CONCAT(
        'UPDATE tipo_documento SET ',
        'id = ', NEW.id, ', ',
        'descripcion = ', NEW.descripcion,
        ' WHERE id = ', OLD.id
    );
    
    -- Insertar una fila en la tabla de auditoría
    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_anterior, valor_nuevo)
    VALUES (admin_id, 'UPDATE', NOW(), sql_command, old_values, new_values);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_crear_tipoDocumento` AFTER INSERT ON `tipo_documento` FOR EACH ROW BEGIN
  	DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE sql_command TEXT;
    
    
    -- Construir el comando SQL ejecutado
    SET sql_command = CONCAT('INSERT INTO tipo_documento (id, descripcion) VALUES (', NEW.id, ', ', 		QUOTE(NEW.descripcion), ')');

    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_nuevo)
    VALUES (admin_id, 'CREATE', NOW(), sql_command, 'Nuevo tipo de documento creado');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_negocio`
--

CREATE TABLE `tipo_negocio` (
  `id_tipoNeg` int(11) NOT NULL COMMENT 'Identificador primario',
  `desc_Neg` varchar(20) NOT NULL COMMENT 'Descripción de tipo de negocio'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `tipo_negocio`
--

INSERT INTO `tipo_negocio` (`id_tipoNeg`, `desc_Neg`) VALUES
(6, 'Venta Directa'),
(7, 'Contrato de Servicio'),
(8, 'Suscripción'),
(9, 'Negocio B2B'),
(10, 'Negocio B2C'),
(11, 'Comercio Electrónico');

--
-- Disparadores `tipo_negocio`
--
DELIMITER $$
CREATE TRIGGER `audit_actualizar_tipoNegocio` AFTER UPDATE ON `tipo_negocio` FOR EACH ROW BEGIN
    DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE old_values TEXT;
    DECLARE new_values TEXT;
	DECLARE sql_command TEXT;
    
    -- Construir la cadena de valores anteriores (old_values)
    SET old_values = CONCAT(
        'id_tipoNeg: ', OLD.id_tipoNeg, ', ',
        'desc_Neg: ', OLD.desc_Neg
    );
    
    -- Construir la cadena de valores actuales (new_values)
    SET new_values = CONCAT(
        'id_tipoNeg: ', NEW.id_tipoNeg, ', ',
        'desc_Neg: ', NEW.desc_Neg
    );
    
    -- Construir la consulta SQL ejecutada
    SET sql_command = CONCAT(
        'UPDATE tipo_negocio SET ',
        'id_tipoNeg = ', NEW.id_tipoNeg, ', ',
        'desc_Neg = ', NEW.desc_Neg,
        ' WHERE id_tipoNeg = ', OLD.id_tipoNeg
    );
    
    -- Insertar una fila en la tabla de auditoría
    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_anterior, valor_nuevo)
    VALUES (admin_id, 'UPDATE', NOW(), sql_command, old_values, new_values);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_crear_tipoNegocio` AFTER INSERT ON `tipo_negocio` FOR EACH ROW BEGIN
  	DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE sql_command TEXT;
    
    
    -- Construir el comando SQL ejecutado
    SET sql_command = CONCAT('INSERT INTO tipo_negocio (id_tipoNeg, desc_Neg) VALUES (',           		NEW.id_tipoNeg, ', ', QUOTE(NEW.desc_Neg), ')');

    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_nuevo)
    VALUES (admin_id, 'CREATE', NOW(), sql_command, 'Nuevo tipo de negocio creado');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_propiedad`
--

CREATE TABLE `tipo_propiedad` (
  `id_tipoProp` int(11) NOT NULL COMMENT 'Identificador primario',
  `desc_tipoProp` varchar(20) NOT NULL COMMENT 'Descripción de tipo de propiedad'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `tipo_propiedad`
--

INSERT INTO `tipo_propiedad` (`id_tipoProp`, `desc_tipoProp`) VALUES
(3, 'Apartamento'),
(4, 'Oficina'),
(5, 'Lote / Terreno'),
(6, 'Consultorio'),
(7, 'Casa'),
(8, 'Apartaestudio'),
(9, 'Finca'),
(10, 'Bodega'),
(11, 'Local'),
(12, 'Deposito'),
(13, 'Edificio');

--
-- Disparadores `tipo_propiedad`
--
DELIMITER $$
CREATE TRIGGER `audit_actualizar_tipoPropiedad` AFTER UPDATE ON `tipo_propiedad` FOR EACH ROW BEGIN
    DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE old_values TEXT;
    DECLARE new_values TEXT;
	DECLARE sql_command TEXT;
    
    -- Construir la cadena de valores anteriores (old_values)
    SET old_values = CONCAT(
        'id_tipoProp: ', OLD.id_tipoProp, ', ',
        'desc_tipoProp: ', OLD.desc_tipoProp
    );
    
    -- Construir la cadena de valores actuales (new_values)
    SET new_values = CONCAT(
        'id_tipoProp: ', NEW.id_tipoProp, ', ',
        'desc_tipoProp: ', NEW.desc_tipoProp
    );
    
    -- Construir la consulta SQL ejecutada
    SET sql_command = CONCAT(
        'UPDATE tipo_propiedad SET ',
        'id_tipoProp = ', NEW.id_tipoProp, ', ',
        'desc_tipoProp = ', NEW.desc_tipoProp,
        ' WHERE id_tipoProp = ', OLD.id_tipoProp
    );
    
    -- Insertar una fila en la tabla de auditoría
    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_anterior, valor_nuevo)
    VALUES (admin_id, 'UPDATE', NOW(), sql_command, old_values, new_values);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_crear_tipoPropiedad` AFTER INSERT ON `tipo_propiedad` FOR EACH ROW BEGIN
  	DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE sql_command TEXT;
    
    
    -- Construir el comando SQL ejecutado
    SET sql_command = CONCAT('INSERT INTO tipo_propiedad (id_tipoProp, desc_tipoProp) VALUES (', NEW.id_tipoProp, ', ', 		QUOTE(NEW.desc_tipoProp), ')');

    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_nuevo)
    VALUES (admin_id, 'CREATE', NOW(), sql_command, 'Nuevo tipo de propiedad creado');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL COMMENT 'Identificador primario',
  `id_rol` int(11) NOT NULL COMMENT 'Identificador foraneo, campo asociado a la tabla rol',
  `nombre` varchar(50) DEFAULT NULL COMMENT 'Nombre del usuario',
  `apellido` varchar(50) NOT NULL COMMENT 'Apellido del usuario',
  `correo` varchar(100) NOT NULL COMMENT 'Correo electrónico (GMAIL)',
  `contrasena` varchar(255) NOT NULL COMMENT 'Contraseña encriptada con Bcrypt',
  `telefono` varchar(10) NOT NULL COMMENT 'Teléfono del usuario',
  `descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripción opcional para el usuario ',
  `documento` varchar(10) NOT NULL COMMENT 'Número de documento ',
  `tipo_documento` int(11) NOT NULL COMMENT 'Tipo de documento, campo asociado a la tabla tipo_documento'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `id_rol`, `nombre`, `apellido`, `correo`, `contrasena`, `telefono`, `descripcion`, `documento`, `tipo_documento`) VALUES
(13, 1, 'Admin', 'Admin', 'admin@softwareteam.com', '$2b$10$ZOjUtltfoeHoja7.h1ldG.hGx821fuHOuNC/iLiacj4Kp6/CiCBli', '8901234567', 'Administrador del sistema', '123456789', 1),
(19, 2, 'Juan', 'Pérez', 'usuario@example.com', '$2b$10$O.vJCV0BC4mniaDYK8muf.FiAngyLL01CQl0cpoXfpPu71Z92hET6', '3114567890', 'Descripción del usuario', '123456789', 1);

--
-- Disparadores `usuario`
--
DELIMITER $$
CREATE TRIGGER `audit_actualizar_usuario` AFTER UPDATE ON `usuario` FOR EACH ROW BEGIN
    DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE old_values TEXT;
    DECLARE new_values TEXT;
    DECLARE sql_command TEXT;
    
    -- Construir la cadena de valores anteriores (old_values)
    SET old_values = CONCAT(
        'id: ', OLD.id, ', ',
        'id_rol: ', OLD.id_rol, ', ',
        'nombre: ', OLD.nombre, ', ',
        'apellido: ', OLD.apellido, ', ',
        'correo: ', OLD.correo, ', ',
        'contrasena: ', OLD.contrasena, ', ',
        'telefono: ', OLD.telefono, ', ',
        'descripcion: ', OLD.descripcion, ', ',
        'documento: ', OLD.documento, ', ',
        'tipo_documento: ', OLD.tipo_documento
    );
    
    -- Construir la cadena de valores actuales (new_values)
    SET new_values = CONCAT(
        'id: ', NEW.id, ', ',
        'id_rol: ', NEW.id_rol, ', ',
        'nombre: ', NEW.nombre, ', ',
        'apellido: ', NEW.apellido, ', ',
        'correo: ', NEW.correo, ', ',
        'contrasena: ', NEW.contrasena, ', ',
        'telefono: ', NEW.telefono, ', ',
        'descripcion: ', NEW.descripcion, ', ',
        'documento: ', NEW.documento, ', ',
        'tipo_documento: ', NEW.tipo_documento
    );
    
    -- Construir la consulta SQL ejecutada
    SET sql_command = CONCAT(
        'UPDATE usuario SET ',
        'id = ', NEW.id, ', ',
        'id_rol = ', NEW.id_rol, ', ',
        'nombre = ', QUOTE(NEW.nombre), ', ',
        'apellido = ', QUOTE(NEW.apellido), ', ',
        'correo = ', QUOTE(NEW.correo), ', ',
        'contrasena = ', QUOTE(NEW.contrasena), ', ',
        'telefono = ', QUOTE(NEW.telefono), ', ',
        'descripcion = ', QUOTE(NEW.descripcion), ', ',
        'documento = ', QUOTE(NEW.documento), ', ',
        'tipo_documento = ', NEW.tipo_documento,
        ' WHERE id = ', OLD.id
    );
    
    -- Insertar una fila en la tabla de auditoría
    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_anterior, valor_nuevo)
    VALUES (admin_id, 'UPDATE', NOW(), sql_command, old_values, new_values);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_usuario` AFTER INSERT ON `usuario` FOR EACH ROW BEGIN
    DECLARE admin_id INT DEFAULT 13; -- ID del administrador
    DECLARE id_insert INT;
    DECLARE sql_command TEXT;
    
    -- Verificar si el usuario registrado es el administrador o un usuario no registrado
    IF NEW.id IS NULL THEN
        SET id_insert = admin_id; -- Asignar el ID del administrador si el usuario no tiene ID asignado
    ELSE
        SET id_insert = NEW.id;
    END IF;

    -- Construir el comando SQL ejecutado
    SET sql_command = CONCAT('INSERT INTO usuario (id, id_rol, nombre, apellido, correo, contrasena, telefono, descripcion, documento, tipo_documento) VALUES (', NEW.id, ', ', NEW.id_rol, ', ', QUOTE(NEW.nombre), ', ', QUOTE(NEW.apellido), ', ', QUOTE(NEW.correo), ', ', QUOTE(NEW.contrasena), ', ', QUOTE(NEW.telefono), ', ', QUOTE(NEW.descripcion), ', ', QUOTE(NEW.documento), ', ', NEW.tipo_documento, ')');

    INSERT INTO auditoria (id_usuario, accion, fecha_hora, sql_ejecutado, valor_nuevo)
    VALUES (id_insert, 'CREATE', NOW(), sql_command, 'Nuevo usuario creado');
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `agenda`
--
ALTER TABLE `agenda`
  ADD PRIMARY KEY (`id_agenda`),
  ADD KEY `FK_Agenda_Propiedad` (`id_propiedad`),
  ADD KEY `FK_Agenda_usuario` (`id_usuario`) USING BTREE;

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `propiedad`
--
ALTER TABLE `propiedad`
  ADD PRIMARY KEY (`id_propiedad`),
  ADD KEY `FK_Propiedad_Tipo_Negocio` (`id_tipoNeg`),
  ADD KEY `FK_Propiedad_Tipo_Propiedad` (`id_tipoProp`),
  ADD KEY `id_vendedor` (`id_vendedor`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indices de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tipo_negocio`
--
ALTER TABLE `tipo_negocio`
  ADD PRIMARY KEY (`id_tipoNeg`);

--
-- Indices de la tabla `tipo_propiedad`
--
ALTER TABLE `tipo_propiedad`
  ADD PRIMARY KEY (`id_tipoProp`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `id_rol` (`id_rol`),
  ADD KEY `tipo_documento` (`tipo_documento`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `agenda`
--
ALTER TABLE `agenda`
  MODIFY `id_agenda` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario', AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `propiedad`
--
ALTER TABLE `propiedad`
  MODIFY `id_propiedad` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipo_negocio`
--
ALTER TABLE `tipo_negocio`
  MODIFY `id_tipoNeg` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario', AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `tipo_propiedad`
--
ALTER TABLE `tipo_propiedad`
  MODIFY `id_tipoProp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario', AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario', AUTO_INCREMENT=22;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `agenda`
--
ALTER TABLE `agenda`
  ADD CONSTRAINT `agenda_ibfk_2` FOREIGN KEY (`id_propiedad`) REFERENCES `propiedad` (`id_propiedad`) ON UPDATE CASCADE,
  ADD CONSTRAINT `agenda_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `propiedad`
--
ALTER TABLE `propiedad`
  ADD CONSTRAINT `propiedad_ibfk_1` FOREIGN KEY (`id_tipoProp`) REFERENCES `tipo_propiedad` (`id_tipoProp`) ON UPDATE CASCADE,
  ADD CONSTRAINT `propiedad_ibfk_2` FOREIGN KEY (`id_tipoNeg`) REFERENCES `tipo_negocio` (`id_tipoNeg`) ON UPDATE CASCADE,
  ADD CONSTRAINT `propiedad_ibfk_3` FOREIGN KEY (`id_vendedor`) REFERENCES `usuario` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `usuario_ibfk_2` FOREIGN KEY (`tipo_documento`) REFERENCES `tipo_documento` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
