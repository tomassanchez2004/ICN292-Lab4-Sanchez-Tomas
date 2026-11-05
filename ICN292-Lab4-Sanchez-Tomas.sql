DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT 
PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60),
    genero ENUM('Cómic', 'Ensayo', 
'Infantil', 'Novela', 'Poesía') NOT NULL);
CREATE TABLE colecciones (
    id_coleccion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE
);
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES 
autores(id_autor));
CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    id_coleccion INT NOT NULL,
    titulo VARCHAR(120) NOT NULL,
    paginas INT,
    ejemplares_vendidos INT,
    anio INT,
    FOREIGN KEY (id_autor) REFERENCES 
autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES 
colecciones(id_coleccion));
INSERT INTO autores (nombre, pais, genero)
VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');
INSERT INTO colecciones (titulo, fecha_publicacion)
VALUES
('Colección Austral 2022', '2022-01-01'),
('Colección Austral 2023', '2023-01-01'),
('Colección Austral 2024', '2024-01-01');
SELECT * FROM colecciones;
INSERT INTO libros
(id_autor, id_coleccion, titulo, paginas, 
ejemplares_vendidos, anio)
VALUES
(1, 3, 'Cielo de Enero', 210, 1500, 2024),
(1, 2, 'Marea Baja', 185, 800, 2023),
(1, 3, 'El Norte', 200, 2200, 2024),
(2, 1, 'Estrellas que Caen', 240, 3000, 2022),
(2, 3, 'Máquinas', 215, 450, 2024),
(3, 3, 'Luz Artificial', 300, 1200, 2024),
(3, 2, 'Ruido Blanco', 280, 600, 2023),
(4, 3, 'El Barrio de Lila', 190, 5000, 2024),
(4, 3, 'Antes del Amanecer', 205, 2700, 2024),
(4, 2, 'La Calle 8', 175, 900, 2023),
(5, 3, 'Flor de Hierro', 195, 4100, 2024),
(5, 1, 'Hora Dorada', 220, 1800, 2022);
SELECT * FROM libros;
INSERT INTO pagos (id_autor, fecha_pago, monto)
VALUES
(1, '2024-03-15', 150000.00),
(1, '2024-09-20', 200000.00),
(2, '2024-06-10', 175000.00);
SELECT * FROM pagos;
-- CONSULTA 1
SELECT nombre, genero
FROM autores
WHERE pais <> 'Chile' OR pais IS NULL
ORDER BY nombre ASC;
-- CONSULTA 2
SELECT titulo, paginas
FROM libros
WHERE paginas BETWEEN 190 AND 220
ORDER BY paginas ASC;
-- CONSULTA 3
SELECT
    COUNT(*) AS total_libros,
    SUM(ejemplares_vendidos) AS total_vendidos,
    AVG(paginas) AS promedio_paginas,
    MIN(anio) AS anio_mas_antiguo,
    MAX(ejemplares_vendidos) AS maximo_vendidos
FROM libros;
-- CONSULTA 4
SELECT DISTINCT genero
FROM autores
ORDER BY genero ASC;
-- CONSULTA 5
SELECT a.nombre, COUNT(*) AS cantidad_libros
FROM autores a
JOIN libros l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre ASC;
-- CONSULTA 6
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE anio = 2024
AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;
-- CONSULTA 7: INSERTAR LIBRO
INSERT INTO libros
(id_autor, id_coleccion, titulo, paginas, ejemplares_vendidos, anio)
VALUES
(3, 3, 'Papel Mojado', 260, 50, 2024);
SELECT * FROM libros
WHERE titulo = 'Papel Mojado';
DELETE FROM libros
WHERE titulo = 'Papel Mojado';
SELECT * FROM libros
WHERE titulo = 'Papel Mojado';
-- CONSULTA 8
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE titulo = 'Cielo de Enero';
SET SQL_SAFE_UPDATES = 0;
UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos
+ 100
WHERE titulo = 'Cielo de Enero';
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE titulo = 'Cielo de Enero';
-- CONSULTA 9
SELECT
    l.titulo AS titulo_libro,
    c.titulo AS titulo_coleccion,
    c.fecha_publicacion
FROM libros l
JOIN colecciones c
    ON l.id_coleccion = c.id_coleccion
ORDER BY l.titulo ASC;
-- CONSULTA 10
SELECT
    a.nombre, p.fecha_pago, p.monto
FROM pagos p
JOIN autores a
    ON p.id_autor = a.id_autor
ORDER BY a.nombre ASC, p.fecha_pago ASC;
SELECT a.nombre, CAST(SUM(p.monto) 
AS DECIMAL (10,2)) AS total_pagado
FROM pagos p
JOIN autores a
    ON p.id_autor = a.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY a.nombre ASC;