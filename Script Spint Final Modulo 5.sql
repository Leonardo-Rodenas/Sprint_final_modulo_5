-- Creación y uso de la base de datos
CREATE DATABASE DB_SPRINT CHARACTER SET utf8mb4;
USE DB_SPRINT;       

-- Creación de usuario con todos los privilegios de uso en la base de datos DB_SPRINT
CREATE USER "Sprint_USER"@"localhost" IDENTIFIED BY "SPRINT_183461";
GRANT ALL PRIVILEGES ON DB_SPRINT.* TO "Sprint_USER"@"localhost";
FLUSH PRIVILEGES;

-- Creación de Tablas

-- Tabla Usuarios
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  edad TINYINT,
  correo_electronico VARCHAR(100),
  veces_utilizada INT DEFAULT 1
);

-- Tabla Operarios
CREATE TABLE operarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  edad TINYINT,
  correo_electronico VARCHAR(100),
  veces_servido_soporte INT DEFAULT 1
);

-- Tabla Soporte
CREATE TABLE soporte (
  id INT AUTO_INCREMENT PRIMARY KEY,
  operario_id INT,
  usuario_id INT,
  fecha DATE,
  evaluacion_promedio DECIMAL (4,2),
  FOREIGN KEY (operario_id) REFERENCES operarios(id)
);

-- Tabla encuesta_soporte
CREATE TABLE encuesta_soporte (
  id INT AUTO_INCREMENT PRIMARY KEY,
  operario_id INT,
  usuario_id INT,
  calificacion TINYINT CHECK (calificacion >= 1 AND calificacion <= 7), -- De este modo se puede agregar un valor entre 1 y 7, de tipo entero. Generará un error si intenta agregar un valor no permitido en la restricción
  comentario VARCHAR(100),
  FOREIGN KEY (operario_id) REFERENCES operarios(id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Agregar datos a las tablas.

INSERT INTO usuarios (nombre, apellido, edad, correo_electronico, veces_utilizada) VALUES 
("Steven", "Strange", 45, "supreme_wizard@marvel.com", 7),
("Jean", "Gray", 28, "phoenix_rise@marvel.com", 10),
("Charles", "Xavier", 72, "prof_X@marvel.com", 15),
('Gwen', 'Stacy', 25, "spider_woman@marvel.com", 4),
("Wade", "Wilson",35, "chimichanga@marvel.com", 6);

INSERT INTO operarios (nombre, apellido, edad, correo_electronico, veces_servido_soporte) VALUES 
("Ana", "Sánchez", 40, "ana_sanchez@correofalso.com", 2),
("Luis", "Torres", 27, "luis_1525@correofalso.com", 3),
("Sofía", "González", 33, "sofia_gon13@correofalso.com", 1),
("Jorge", "Hernández", 18, "el_yorch_her789@example.com", 2),
("Mónica", "Díaz", 19, "monica_diaz27@example.com", 1);

INSERT INTO soporte (operario_id, usuario_id, fecha, evaluacion_promedio) VALUES 
(1, 5, '2023-05-01', 5.2),
(2, 3, '2023-05-02', 4.8),
(2, 4, '2023-05-03', 6.8),
(4, 1, '2023-05-04', 6.5),
(5, 2, '2023-05-05', 6.2),
(1, 5, '2023-05-06', 5.6),
(4, 2, '2023-05-07', 4.9),
(3, 1, '2023-05-08', 7.0),
(5, 4, '2023-05-09', 6.3),
(2, 3, '2023-05-10', 6.0);

INSERT INTO encuesta_soporte (operario_id, usuario_id, calificacion, comentario) VALUES 
(1, 5, 5, "Buena atención, resolvió mi problema rápidamente."),
(4, 3, 6, "Operario fue muy amable y profesional."),
(2, 2, 4, "Aceptable, esperaba una solución más rápida."),
(3, 4, 7, "Excelente atención"),
(5, 1, 3, "No quedé satisfecho con el soporte recibido."),
(2, 5, 5, "El operario mostró buen conocimiento del tema."),
(5, 4, 6, "Soporte rápido y eficiente."),
(4, 2, 1, "Mal soporte. no soluciona problemas"),
(1, 3, 2, "Muy lenta atención, no responde las dudas"),
(3, 1, 5, "Operario muy amable pero no pudo resolver mi problema por completo.");

-- Queries
-- Seleccione las 3 operaciones con mejor evaluación.
SELECT o.nombre, o.apellido, s.evaluacion_promedio FROM operarios o
JOIN soporte s ON o.id = s.operario_id
ORDER BY s.evaluacion_promedio DESC
LIMIT 3;

-- Seleccione las 3 operaciones con menos evaluación.
SELECT o.nombre, o.apellido, s.evaluacion_promedio FROM operarios o
JOIN soporte s ON o.id = s.operario_id
ORDER BY s.evaluacion_promedio
LIMIT 3;

-- Seleccione al operario que más soportes ha realizado.
SELECT o.nombre, o.apellido, COUNT(s.operario_id) AS total_soportes FROM operarios o
JOIN soporte s ON o.id = s.operario_id
GROUP BY o.id
ORDER BY total_soportes DESC
LIMIT 1;

-- Seleccione al cliente que menos veces ha utilizado la aplicación.
SELECT u.nombre, u.apellido, u.veces_utilizada FROM usuarios u
ORDER BY u.veces_utilizada
LIMIT 1;

-- Agregue 10 años a los tres primeros usuarios registrados.
UPDATE usuarios
SET edad = edad + 10
ORDER BY id
LIMIT 3;

-- Renombre todas las columnas "correo electrónico". El nuevo nombre debe ser email.
ALTER TABLE usuarios
CHANGE correo_electronico email VARCHAR(100);

ALTER TABLE operarios
CHANGE correo_electronico email VARCHAR(100);

-- Seleccione solo los operarios mayores de 20 años.
SELECT * FROM operarios
WHERE edad > 20;