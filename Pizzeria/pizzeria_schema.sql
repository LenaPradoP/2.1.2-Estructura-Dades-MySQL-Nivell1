DROP DATABASE IF EXISTS pizzeria;
CREATE DATABASE pizzeria CHARACTER SET utf8mb4;
USE pizzeria;

CREATE TABLE tienda (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    direccion VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL
);

CREATE TABLE empleado (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    nif VARCHAR(15) UNIQUE NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    tipo ENUM('cocinero', 'repartidor') NOT NULL,
    id_tienda INT UNSIGNED,
    FOREIGN KEY (id_tienda) REFERENCES tienda(id)
);

CREATE TABLE cliente (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(100) NOT NULL,
    apellido2 VARCHAR(100),
    direccion VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL
);

CREATE TABLE categoria_pizza (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE producto (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    imagen VARCHAR(255) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    tipo ENUM('pizza', 'hamburguesa', 'bebida') NOT NULL,
    id_categoria INT UNSIGNED,
    FOREIGN KEY (id_categoria) REFERENCES categoria_pizza(id)
);

CREATE TABLE pedido (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM('recogida', 'entrega') NOT NULL,
    id_tienda INT UNSIGNED NOT NULL,
    id_cliente INT UNSIGNED NOT NULL,
    id_cocinero INT UNSIGNED NOT NULL,
    id_repartidor INT UNSIGNED,
    entrega TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (id_tienda) REFERENCES tienda(id),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    FOREIGN KEY (id_cocinero) REFERENCES empleado(id),
    FOREIGN KEY (id_repartidor) REFERENCES empleado(id)
);

CREATE TABLE producto_vendido (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_producto INT UNSIGNED NOT NULL,
    id_pedido INT UNSIGNED NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_producto) REFERENCES producto(id),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id)
);

DELIMITER //

CREATE TRIGGER actualizar_total_pedido
AFTER INSERT ON producto_vendido
FOR EACH ROW
BEGIN
  UPDATE pedido
  SET total = (
      SELECT SUM(p.precio * pv.cantidad)
      FROM producto_vendido pv
      JOIN producto p ON pv.id_producto = p.id
      WHERE pv.id_pedido = NEW.id_pedido
  )
  WHERE id = NEW.id_pedido;
END;
//

DELIMITER ;

INSERT INTO tienda(id, direccion, codigo_postal, localidad, provincia) VALUES 
    (1, 'Carrer de la Pau, 5', '08001', 'Barcelona', 'Barcelona'),
    (2, 'Avinguda Diagonal, 300', '08013', 'Barcelona', 'Barcelona'),
    (3, 'Carrer de Provença, 28', '08029', 'Barcelona', 'Barcelona');

INSERT INTO empleado(id, nombre, apellido1, apellido2, nif, telefono, tipo, id_tienda) VALUES
    (1, 'Marc', 'Sánchez', 'Pujol', '12345678Z', '612-345-678', 'cocinero', 1),
    (2, 'Laia', 'Martínez', 'García', '23456789Y', '677-890-123', 'repartidor', 1),
    (3, 'Oriol', 'Fernández', 'Rocafort', '34567890X', '688-901-234', 'repartidor', 1),
    (4, 'Marta', 'Ramírez', 'López', '45678901W', '654-321-987', 'cocinero', 2),
    (5, 'David', 'González', 'Moreno', '56789012V', '666-543-210', 'repartidor', 2),
    (6, 'Sofia', 'Torres', 'Castro', '67890123U', '622-456-789', 'cocinero', 3),
    (7, 'Jordi', 'Jiménez', 'Martí', '78901234T', '632-789-456', 'repartidor', 3);

INSERT INTO cliente(id, nombre, apellido1, apellido2, direccion, codigo_postal, localidad, provincia, telefono) VALUES
    (1, 'Emma', 'Pérez', 'Soler', 'Carrer de la Pau, 5', '08001', 'Barcelona', 'Barcelona', '612-123-456'),
    (2, 'Pol', 'López', 'Alvarez', 'Avinguda Diagonal, 300', '08013', 'Barcelona', 'Barcelona', '677-234-567'),
    (3, 'Núria', 'Martín', 'Fernández', 'Carrer del Carme, 10', '08001', 'Barcelona', 'Barcelona', '688-345-678'),
    (4, 'Julián', 'García', 'Robles', 'Carrer de la Indústria, 22', '08016', 'Barcelona', 'Barcelona', '634-456-789'),
    (5, 'Sílvia', 'Moreno', 'Sánchez', 'Carrer de València, 45', '08015', 'Barcelona', 'Barcelona', '622-567-890'),
    (6, 'Miquel', 'Jiménez', 'Ríos', 'Carrer de Pau Claris, 12', '08010', 'Barcelona', 'Barcelona', '632-678-901'),
    (7, 'Laia', 'Romero', 'Cabrera', 'Carrer de Mallorca, 210', '08036', 'Barcelona', 'Barcelona', '645-789-012'),
    (8, 'Àlex', 'Vázquez', 'Peña', 'Carrer del Comte d’Urgell, 5', '08011', 'Barcelona', 'Barcelona', '600-890-123'),
    (9, 'Alba', 'Serrano', 'Mora', 'Carrer de Gran Via, 45', '08015', 'Barcelona', 'Barcelona', '618-901-234'),
    (10, 'Joaquim', 'Castell', 'Montes', 'Carrer de Consell de Cent, 30', '08015', 'Barcelona', 'Barcelona', '657-012-345'),
    (11, 'Clara', 'Navas', 'Vidal', 'Carrer de Tarragona, 9', '08014', 'Barcelona', 'Barcelona', '612-345-678'),
    (12, 'Roger', 'Gómez', 'Camps', 'Carrer de Comte de Barcelona, 20', '08020', 'Barcelona', 'Barcelona', '686-456-789'),
    (13, 'Marina', 'Salas', 'Esteban', 'Carrer de Sants, 45', '08014', 'Barcelona', 'Barcelona', '618-567-890'),
    (14, 'Xavier', 'Delgado', 'Serrano', 'Carrer de Provença, 28', '08029', 'Barcelona', 'Barcelona', '632-678-901'),
    (15, 'Teresa', 'Cruz', 'Martínez', 'Carrer de Pau Claris, 18', '08010', 'Barcelona', 'Barcelona', '622-789-012');

INSERT INTO categoria_pizza(id, nombre) VALUES
    (1, 'Clasicas'),
    (2, 'Deluxe'),
    (3, 'Sin Gluten'),
    (4, 'Vegetarianas');

INSERT INTO producto(id, nombre, descripcion, imagen, precio, tipo, id_categoria) VALUES
    (1, 'Margherita', 'Pizza clásica con salsa de tomate y mozzarella.', 'margherita.jpg', 8.50, 'pizza', 1),
    (2, 'Pepperoni', 'Pizza con salsa de tomate, mozzarella y pepperoni.', 'pepperoni.jpg', 9.00, 'pizza', 2),
    (3, 'Cuatro Quesos', 'Pizza con una mezcla de cuatro quesos diferentes.', 'cuatro_quesos.jpg', 10.50, 'pizza', 3),
    (4, 'Vegetariana', 'Pizza con salsa de tomate, mozzarella y verduras frescas.', 'vegetariana.jpg', 9.50, 'pizza', 4),
    (5, 'Barbacoa', 'Pizza con salsa barbacoa, pollo, cebolla y queso.', 'barbacoa.jpg', 11.00, 'pizza', 2),
    (6, 'Hawaiana', 'Pizza con salsa de tomate, jamón y piña.', 'hawaiana.jpg', 10.00, 'pizza', 1),
    (7, 'Mushroom', 'Pizza con salsa de tomate, mozzarella y champiñones.', 'mushroom.jpg', 9.00, 'pizza', 3),
    (8, 'Diavola', 'Pizza picante con salsa de tomate, salami y jalapeños.', 'diavola.jpg', 10.50, 'pizza', 4),
    (9, 'Pesto', 'Pizza con pesto, mozzarella y tomates secos.', 'pesto.jpg', 11.50, 'pizza', 2),
    (10, 'Capricciosa', 'Pizza con alcachofas, jamón y aceitunas.', 'capricciosa.jpg', 12.00, 'pizza', 2),
    (11, 'Carbonara', 'Pizza con salsa carbonara, panceta y queso.', 'carbonara.jpg', 12.50, 'pizza', 3),
    (12, 'Calzone', 'Pizza rellena de jamón, queso y champiñones.', 'calzone.jpg', 9.50, 'pizza', 2),
    (13, 'Fugazza', 'Pizza con cebolla, queso y orégano.', 'fugazza.jpg', 8.50, 'pizza', 1),
    (14, 'Romana', 'Pizza con salsa de tomate, mozzarella y alcaparras.', 'romana.jpg', 9.00, 'pizza', 1),
    (15, 'Prosciutto e Funghi', 'Pizza con jamón y champiñones.', 'prosciutto_funghi.jpg', 10.00, 'pizza', 1),
    (16, 'Hamburguesa Clásica', 'Hamburguesa de carne de res con lechuga, tomate y cebolla.', 'hamburguesa_clasica.jpg', 7.50, 'hamburguesa', NULL),
    (17, 'Cheeseburger', 'Hamburguesa con queso cheddar derretido y pepinillos.', 'cheeseburger.jpg', 8.00, 'hamburguesa', NULL),
    (18, 'Bacon Burger', 'Hamburguesa con bacon crujiente, lechuga y tomate.', 'bacon_burger.jpg', 9.00, 'hamburguesa', NULL),
    (19, 'Hamburguesa BBQ', 'Hamburguesa con salsa barbacoa, cebolla frita y queso.', 'hamburguesa_bqq.jpg', 9.50, 'hamburguesa', NULL),
    (20, 'Veggie Burger', 'Hamburguesa vegetariana con garbanzos y especias.', 'veggie_burger.jpg', 8.50, 'hamburguesa', NULL),
    (21, 'Coca-Cola', 'Refresco de cola.', 'coca_cola.jpg', 1.50, 'bebida', NULL),
    (22, 'Fanta Naranja', 'Refresco de naranja.', 'fanta_naranja.jpg', 1.50, 'bebida', NULL),
    (23, 'Sprite', 'Refresco de limón-lima.', 'sprite.jpg', 1.50, 'bebida', NULL),
    (24, 'Agua Mineral', 'Agua mineral natural.', 'agua_mineral.jpg', 1.00, 'bebida', NULL),
    (25, 'Refresco de Limón', 'Refresco de limón.', 'refresco_limon.jpg', 1.50, 'bebida', NULL),
    (26, 'Agua con Gas', 'Agua con gas natural.', 'agua_con_gas.jpg', 1.20, 'bebida', NULL);

INSERT INTO pedido(id, fecha_hora, tipo, id_tienda, id_cliente, id_cocinero, id_repartidor, entrega) VALUES
    (1, '2024-01-01 14:00:00', 'entrega', 1, 5, 1, 2, '2024-01-01 09:15:00'),
    (2, '2024-01-02 12:30:00', 'recogida', 2, 3, 4, NULL, NULL),
    (3, '2024-01-05 18:15:00', 'entrega', 3, 12, 6, 5, '2024-01-05 11:45:00'),
    (4, '2024-01-10 09:45:00', 'recogida', 1, 9, 1, NULL, NULL),
    (5, '2024-01-15 17:00:00', 'entrega', 2, 1, 4, 3, '2024-01-15 13:30:00'),
    (6, '2024-01-20 19:30:00', 'recogida', 3, 7, 6, NULL, NULL),
    (7, '2024-01-25 11:00:00', 'entrega', 1, 14, 1, 2, '2024-01-25 15:00:00'),
    (8, '2024-02-01 10:00:00', 'recogida', 2, 15, 4, NULL, NULL),
    (9, '2024-02-03 14:45:00', 'entrega', 3, 11, 6, 5, '2024-02-03 17:30:00'),
    (10, '2024-02-10 13:30:00', 'recogida', 1, 2, 1, NULL, NULL),
    (11, '2024-02-15 09:15:00', 'entrega', 2, 6, 4, 2, '2024-02-15 09:00:00'),
    (12, '2024-02-20 16:00:00', 'recogida', 3, 10, 6, NULL, NULL),
    (13, '2024-02-25 18:00:00', 'entrega', 1, 4, 1, 5, '2024-02-25 11:30:00'),
    (14, '2024-03-01 10:45:00', 'recogida', 2, 8, 4, NULL, NULL),
    (15, '2024-03-05 14:30:00', 'entrega', 3, 13, 6, 2, '2024-03-05 13:15:00'),
    (16, '2024-05-25 14:00:00', 'recogida', 1, 5, 1, NULL, NULL),
    (17, '2024-06-01 12:00:00', 'recogida', 2, 3, 4, NULL, NULL),
    (18, '2024-06-05 18:30:00', 'recogida', 1, 1, 1, NULL, NULL),
    (19, '2024-06-10 16:45:00', 'recogida', 3, 2, 6, NULL, NULL),
    (20, '2024-06-15 09:30:00', 'entrega', 2, 4, 4, 3, '2024-06-15 12:00:00'),
    (21, '2024-06-20 11:00:00', 'recogida', 1, 15, 1, NULL, NULL),
    (22, '2024-06-25 19:15:00', 'recogida', 3, 10, 6, NULL, NULL),
    (23, '2024-06-30 14:30:00', 'recogida', 2, 7, 4, NULL, NULL),
    (24, '2024-07-05 17:00:00', 'entrega', 1, 8, 1, 2, '2024-07-05 14:00:00'),
    (25, '2024-07-10 10:30:00', 'recogida', 3, 6, 6, NULL, NULL),
    (26, '2024-07-15 15:45:00', 'recogida', 2, 12, 4, NULL, NULL),
    (27, '2024-07-20 12:15:00', 'recogida', 1, 14, 1, NULL, NULL),
    (28, '2024-07-25 13:30:00', 'entrega', 3, 9, 6, 5, '2024-07-25 10:15:00'),
    (29, '2024-07-30 11:45:00', 'recogida', 2, 11, 4, NULL, NULL),
    (30, '2024-08-04 16:00:00', 'recogida', 1, 13, 1, NULL, NULL);


INSERT INTO producto_vendido(id, id_producto, id_pedido, cantidad) VALUES
    (1, 1, 1, 2),
    (2, 5, 1, 1),
    (3, 3, 2, 2),
    (4, 7, 2, 1),
    (5, 2, 3, 1),  
    (6, 8, 3, 1),
    (7, 6, 4, 2),
    (8, 4, 4, 1),
    (9, 10, 5, 2),
    (10, 12, 5, 1),
    (11, 1, 6, 1),
    (12, 9, 6, 2),
    (13, 13, 7, 1),
    (14, 16, 8, 2),
    (15, 20, 9, 1),
    (16, 19, 10, 1),
    (17, 17, 11, 2),
    (18, 18, 12, 1),
    (19, 11, 12, 1),
    (20, 21, 13, 1),
    (21, 15, 14, 2),
    (22, 14, 15, 1),
    (23, 22, 15, 1),
    (24, 23, 16, 1),
    (25, 24, 17, 2),
    (26, 25, 18, 1),
    (27, 3, 19, 1),
    (28, 1, 20, 2),
    (29, 4, 21, 1),
    (30, 5, 22, 1),
    (31, 8, 23, 2),
    (32, 6, 24, 1),
    (33, 7, 25, 1),
    (34, 10, 26, 2),
    (35, 12, 27, 1),
    (36, 9, 28, 1),
    (37, 11, 29, 2),
    (38, 19, 30, 1),
    (39, 20, 30, 1),
    (40, 18, 30, 2),
    (41, 15, 29, 1),
    (42, 13, 28, 2),
    (43, 16, 28, 1),
    (44, 2, 27, 1),
    (45, 17, 27, 2),
    (46, 3, 26, 1),
    (47, 4, 26, 1),
    (48, 21, 25, 2),
    (49, 22, 24, 1),
    (50, 23, 23, 2);




