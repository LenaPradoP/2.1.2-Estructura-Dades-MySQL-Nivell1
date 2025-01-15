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

CREATE TABLE persona (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  telefono VARCHAR(15),
  email VARCHAR(100),
  tipo ENUM ('cliente', 'empleado') NOT NULL,
  fecha_registro DATE DEFAULT CURRENT_TIMESTAMP,
  id_cliente_referencia INT UNSIGNED,
  FOREIGN KEY (id_cliente_referencia) REFERENCES persona (id) ON DELETE SET NULL 
);

CREATE TABLE direccion (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  calle VARCHAR(100),
  numero VARCHAR(10),
  piso VARCHAR(20),
  puerta VARCHAR(20),
  ciudad VARCHAR(50),
  codigo_postal VARCHAR(10),
  pais VARCHAR(50),
  id_proveedor INT UNSIGNED,
  id_persona INT UNSIGNED,
  FOREIGN KEY (id_proveedor) REFERENCES proveedor (id) ON DELETE CASCADE,
  FOREIGN KEY (id_persona) REFERENCES persona (id) ON DELETE CASCADE
);

CREATE TABLE gafa (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  marca VARCHAR(50) NOT NULL,
  graduacion_derecha DECIMAL(5,2),
  graduacion_izquierda DECIMAL(5,2),
  tipo_montura ENUM('flotante', 'pasta', 'metalica') NOT NULL,
  color_montura VARCHAR(25),
  color_cristales VARCHAR(25),
  precio DECIMAL(10,2) NOT NULL,
  id_proveedor INT UNSIGNED,
  FOREIGN KEY (id_proveedor) REFERENCES proveedor (id) ON DELETE SET NULL
);

CREATE TABLE venta (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT UNSIGNED NOT NULL,
  id_empleado INT UNSIGNED NOT NULL,
  fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2) DEFAULT 0,
  FOREIGN KEY (id_cliente) REFERENCES persona (id),
  FOREIGN KEY (id_empleado) REFERENCES persona (id)
);

CREATE TABLE gafa_vendida (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_venta INT UNSIGNED NOT NULL,
  id_gafa INT UNSIGNED NOT NULL,
  cantidad INT NOT NULL DEFAULT 1,
  FOREIGN KEY (id_venta) REFERENCES venta (id) ON DELETE CASCADE,
  FOREIGN KEY (id_gafa) REFERENCES gafa (id)
);


DELIMITER //

CREATE TRIGGER actualizar_total_venta
AFTER INSERT ON gafa_vendida
FOR EACH ROW
BEGIN
  UPDATE venta
  SET total = (
      SELECT SUM(g.precio * gv.cantidad)
      FROM gafa_vendida gv
      JOIN gafa g ON gv.id_gafa = g.id
      WHERE gv.id_venta = NEW.id_venta
  )
  WHERE id = NEW.id_venta;
END;
//

DELIMITER ;


INSERT INTO proveedor(id, nombre, telefono, fax, nif) VALUES 
  (1, 'Kwinu', '756641485', '121287716', 'W3111193C'),
  (2, 'LiveZ', '908299286', '229121286', 'F73190837'),
  (3, 'Eayo', '182457611', '891651724', 'H71637367'),
  (4, 'Yata', '269476758', '390436739', 'D68172196');

INSERT INTO persona(id, nombre, apellido1, apellido2, telefono, email, tipo, fecha_registro, id_cliente_referencia) VALUES
  (1, 'Laura', 'Ramirez', 'Tortosa', '616716506', 'LRami@gmail.com', 'cliente', '2024-08-08', NULL),
  (2, 'Marlène', 'Playford', 'Tarte', '766755164', 'atarte8@infoseek.co.jp', 'cliente', '2024-09-24', NULL),
  (3, 'Desirée', 'Boyland', 'Montrose', '597703624', 'bmontrose9@cyberchimps.com', 'cliente', '2024-10-05', NULL),
  (4, 'Lauréna', 'Billingsley', 'Bythway', '711765927', 'bbythwayf@nps.gov', 'cliente', '2024-10-28', NULL),
  (5, 'Léa', 'Weadick', 'Privost', '271921541', 'aprivostm@house.gov', 'cliente', '2024-11-14', 2),
  (6, 'Daphnée', 'Mangin', 'Vogeler', '906368280', 'bvogelerh@cargocollective.com', 'cliente', '2024-11-23', 3),
  (7, 'Andrée', 'Killgus', 'Pirri', '124425527', 'zpirrid@soup.io', 'cliente', '2024-12-06', 1),
  (8, 'Mén', 'Bortolussi', 'Danilevich', '111991972', 'mdanilevichk@jugem.jp', 'empleado', '2024-08-01', NULL),
  (9, 'Céline', 'Hinks', 'Brackley', '954831419', 'abrackleyg@tinyurl.com', 'empleado', '2024-10-01', NULL),
  (10, 'Angélique', 'Burgoine', 'Legonidec', '527499042', 'clegonidecj@pen.io', 'empleado', '2024-11-01', NULL);
  
INSERT INTO direccion(id, calle, numero, piso, puerta, ciudad, codigo_postal, pais, id_proveedor, id_persona) VALUES 
  (1, 'Carretera Reina', '32', 'bajos', NULL, 'Granada', '35040', 'España', NULL, 1),
  (2, 'Grupo Isabela', '98', '4º' , 'derecha', 'Lion', '40698', 'Francia', 1, NULL),
  (3, 'Calle de La Almudena', '67', 'bajo', NULL, 'Madrid', '86702', 'España', 2, NULL),
  (4, 'Masía Alberto', 's/n', 'casa',  NULL, 'Cadaques', '01676', 'España', NULL, 2),
  (5, 'Avenida del Sol', '45', '2º', 'B', 'Madrid', '28013', 'España', NULL, 3),
  (6, 'Calle Luna', '12', '4º', 'A', 'Barcelona', '08002', 'España', 3, NULL),
  (7, 'Camino de los Pinos', '98', '1º', 'C', 'Valencia', '46006', 'España', NULL, 4),
  (8, 'Plaza Mayor', '8', '3º', 'D', 'Sevilla', '41001', 'España', 4, NULL),
  (9, 'Avenida de las Estrellas', '23', '5º', 'E', 'Málaga', '29015', 'España', NULL, 5),
  (10, 'Calle Río Verde', '15', '3º', 'A', 'Granada', '18008', 'España', NULL, 6),
  (11, 'Avenida de la Libertad', '27', '1º', 'B', 'Bilbao', '48009', 'España', NULL, 7),
  (12, 'Plaza de la Esperanza', '5', '4º', 'C', 'Zaragoza', '50008', 'España', NULL, 10);

INSERT INTO gafa(id, marca, graduacion_derecha, graduacion_izquierda, tipo_montura, color_montura, color_cristales, precio, id_proveedor) VALUES 
  (1, 'Ray-Ban', NULL, NULL, 'pasta', 'negro', 'negro', 85.90, 1),
  (2, 'Ray-Ban', 6.5, 5.75, 'metalica', 'marrón', NULL, 150, 1),
  (3, 'Oakley', NULL, NULL, 'pasta', 'negro', 'negro', 70, 2),
  (4, 'Oakley', NULL, NULL, 'pasta', 'negro', 'azul', 55.90, 2),
  (5, 'Persol', NULL, NULL, 'flotante', NULL, 'polarizadas', 125.90, 3),
  (6, 'Persol', 2.5, 2.5, 'pasta', 'marrón', NULL, 100.50, 3),
  (7, 'Persol', 3.25, 4.5, 'metalica', 'metalica', 'azul', 85.90, 3),
  (8, 'Hawkers', NULL, NULL, 'pasta', 'rojo', 'rojo', 120.50, 4),
  (9, 'Hawkers', NULL, NULL, 'pasta', 'negro', 'azul', 95.95, 4),
  (10, 'Carrera', 1.5, 1.25, 'flotante', NULL, NULL, 150, 1),
  (11, 'Tom Ford', 5.50, 5.25, 'pasta', 'negro', NULL, 185.90, 1),
  (12, 'Polaroid', NULL, NULL, 'metalica', 'negro', 'negro', 130.75, 2);

INSERT INTO venta(id, id_cliente, id_empleado, fecha_venta) VALUES 
  (1, 1, 8, '2024-8-08 18:14:00'),
  (2, 2, 8, '2024-9-24 09:50:00'),
  (3, 3, 8, '2024-10-05 10:09:00'),
  (4, 4, 9, '2024-10-28 19:05:00'),
  (5, 5, 9, '2024-11-14 13:30:00'),
  (6, 2, 10, '2024-11-23 18:15:00'),
  (7, 1, 8, '2024-12-01 09:30:00'),
  (8, 7, 10, '2024-12-06 10:12:00'),
  (9, 1, 8, '2024-12-12 10:00:00'),
  (10, 4, 10, '2024-12-20 16:35:00');

INSERT INTO gafa_vendida(id, id_venta, id_gafa, cantidad) VALUES 
  (1, 1, 1, 2),
  (2, 2, 2, 1),
  (3, 3, 3, 1),
  (4, 4, 4, 4),
  (5, 5, 6, 2),
  (6, 6, 8, 1),
  (7, 7, 5, 1),
  (8, 8, 1, 1),
  (9, 8, 11, 1),
  (10, 9, 7, 1),
  (11, 9, 9, 1),
  (12, 10, 12, 2);







