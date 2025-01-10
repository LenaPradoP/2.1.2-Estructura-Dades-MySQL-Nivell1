CREATE TABLE `Proveedor` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `telefono` VARCHAR(15),
  `fax` VARCHAR(15),
  `nif` VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE `Direccion_Proveedor` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `calle` VARCHAR(100),
  `numero` VARCHAR(10),
  `piso` VARCHAR(20),
  `puerta` VARCHAR(20),
  `ciudad` VARCHAR(50),
  `codigo_postal` VARCHAR(10) NOT NULL,
  `pais` VARCHAR(50) NOT NULL,
  `id_proveedor` INT NOT NULL,
  UNIQUE (`calle`, `numero`, `piso`, `puerta`, `ciudad`, `codigo_postal`),
  FOREIGN KEY (`id_proveedor`) REFERENCES `Proveedor` (`id`) ON DELETE CASCADE
);

CREATE TABLE `Marca` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL UNIQUE,
  `id_proveedor` INT,
  FOREIGN KEY (`id_proveedor`) REFERENCES `Proveedor` (`id`) ON DELETE SET NULL
);

CREATE TABLE `Gafa` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `graduacion_derecha` DECIMAL(5,2),
  `graduacion_izquierda` DECIMAL(5,2),
  `tipo_montura` ENUM('flotante', 'pasta', 'metalica') NOT NULL,
  `color_montura` VARCHAR(25),
  `color_cristales` VARCHAR(25),
  `precio` DECIMAL(10,2) NOT NULL CHECK (`precio` >= 0),
  `id_marca` INT NOT NULL,
  FOREIGN KEY (`id_marca`) REFERENCES `Marca` (`id`)
);

CREATE TABLE `Cliente` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido1` VARCHAR(100) NOT NULL,
  `apellido2` VARCHAR(100),
  `telefono` VARCHAR(15),
  `email` VARCHAR(100) UNIQUE,
  `fecha_registro` DATE DEFAULT CURRENT_TIMESTAMP,
  `id_cliente_referencia` INT,
  FOREIGN KEY (`id_cliente_referencia`) REFERENCES `Cliente` (`id`) ON DELETE SET NULL
);

CREATE TABLE `Direccion_Cliente` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `calle` VARCHAR(100),
  `numero` VARCHAR(10),
  `piso` VARCHAR(20),
  `puerta` VARCHAR(20),
  `ciudad` VARCHAR(50),
  `codigo_postal` VARCHAR(10),
  `pais` VARCHAR(50),
  `id_cliente` INT NOT NULL,
  UNIQUE (`calle`, `numero`, `piso`, `puerta`, `ciudad`, `codigo_postal`),
  FOREIGN KEY (`id_cliente`) REFERENCES `Cliente` (`id`) ON DELETE CASCADE
);

CREATE TABLE `Empleado` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido1` VARCHAR(100) NOT NULL,
  `apellido2` VARCHAR(100),
  `nif` VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE `Venta` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_cliente` INT,
  `id_empleado` INT,
  `fecha_venta` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`id_cliente`) REFERENCES `Cliente` (`id`) ON DELETE SET NULL,
  FOREIGN KEY (`id_empleado`) REFERENCES `Empleado` (`id`) ON DELETE SET NULL
);

CREATE TABLE `Gafa_Vendida` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_venta` INT NOT NULL,
  `id_gafa` INT NOT NULL,
  `cantidad` INT NOT NULL DEFAULT 1 CHECK (`cantidad` > 0),
  FOREIGN KEY (`id_venta`) REFERENCES `Venta` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`id_gafa`) REFERENCES `Gafa` (`id`)
);