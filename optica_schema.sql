DROP DATABASE IF EXISTS optica;
CREATE DATABASE optica CHARACTER SET utf8mb4;
USE optica;

CREATE TABLE proveedor (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  telefono VARCHAR(15),
  fax VARCHAR(15),
  nif VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE direccion_proveedor (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  calle VARCHAR(100),
  numero VARCHAR(10),
  piso VARCHAR(20),
  puerta VARCHAR(20),
  ciudad VARCHAR(50),
  codigo_postal VARCHAR(10) NOT NULL,
  pais VARCHAR(50) NOT NULL,
  id_proveedor INT UNSIGNED NOT NULL,
  UNIQUE (calle, numero, piso, puerta, ciudad, codigo_postal),
  FOREIGN KEY (id_proveedor) REFERENCES proveedor (id) ON DELETE CASCADE
);

CREATE TABLE marca (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  id_proveedor INT UNSIGNED,
  FOREIGN KEY (id_proveedor) REFERENCES proveedor (id) ON DELETE SET NULL
);

CREATE TABLE gafa (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  graduacion_derecha DECIMAL(5,2),
  graduacion_izquierda DECIMAL(5,2),
  tipo_montura ENUM('flotante', 'pasta', 'metalica') NOT NULL,
  color_montura VARCHAR(25),
  color_cristales VARCHAR(25),
  precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
  id_marca INT UNSIGNED NOT NULL,
  FOREIGN KEY (id_marca) REFERENCES marca (id)
);

CREATE TABLE cliente (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  telefono VARCHAR(15),
  email VARCHAR(100) UNIQUE,
  fecha_registro DATE DEFAULT CURRENT_TIMESTAMP,
  id_cliente_referencia INT UNSIGNED,
  FOREIGN KEY (id_cliente_referencia) REFERENCES cliente (id) ON DELETE SET NULL
);

CREATE TABLE direccion_cliente (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  calle VARCHAR(100),
  numero VARCHAR(10),
  piso VARCHAR(20),
  puerta VARCHAR(20),
  ciudad VARCHAR(50),
  codigo_postal VARCHAR(10),
  pais VARCHAR(50),
  id_cliente INT UNSIGNED NOT NULL,
  UNIQUE (calle, numero, piso, puerta, ciudad, codigo_postal),
  FOREIGN KEY (id_cliente) REFERENCES cliente (id) ON DELETE CASCADE
);

CREATE TABLE empleado (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  nif VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE venta (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT UNSIGNED,
  id_empleado INT UNSIGNED,
  fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES cliente (id) ON DELETE SET NULL,
  FOREIGN KEY (id_empleado) REFERENCES empleado (id) ON DELETE SET NULL
);

CREATE TABLE gafa_vendida (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_venta INT UNSIGNED NOT NULL,
  id_gafa INT UNSIGNED NOT NULL,
  cantidad INT NOT NULL DEFAULT 1 CHECK (cantidad > 0),
  FOREIGN KEY (id_venta) REFERENCES venta (id) ON DELETE CASCADE,
  FOREIGN KEY (id_gafa) REFERENCES gafa (id)
);