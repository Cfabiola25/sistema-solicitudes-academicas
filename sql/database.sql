-- SQL script to create and populate the database for the
-- Sistema de Solicitudes Académicas. Run this script in your
-- MySQL client to set up the schema and insert initial data.

CREATE DATABASE IF NOT EXISTS fesc_solicitudes;
USE fesc_solicitudes;

-- Table definitions

CREATE TABLE IF NOT EXISTS tipo_solicitud (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS programa_academico (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(10),
  nombre VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS sede (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS jornada (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS estudiante (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  apellido VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(100),
  programa_id INT,
  sede_id INT,
  jornada_id INT,
  FOREIGN KEY (programa_id) REFERENCES programa_academico(id),
  FOREIGN KEY (sede_id) REFERENCES sede(id),
  FOREIGN KEY (jornada_id) REFERENCES jornada(id)
);

CREATE TABLE IF NOT EXISTS administrador (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS solicitud (
  id INT AUTO_INCREMENT PRIMARY KEY,
  estudiante_id INT,
  tipo_solicitud_id INT,
  descripcion TEXT,
  fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('Enviada','Pendiente','Aprobada','Rechazada') DEFAULT 'Enviada',
  documento VARCHAR(200),
  fecha_respuesta DATETIME,
  comentario_respuesta TEXT,
  admin_id INT,
  FOREIGN KEY (estudiante_id) REFERENCES estudiante(id),
  FOREIGN KEY (tipo_solicitud_id) REFERENCES tipo_solicitud(id),
  FOREIGN KEY (admin_id) REFERENCES administrador(id)
);

-- Insert lookup data
INSERT INTO sede (nombre) VALUES ('Cúcuta'), ('Ocaña');
INSERT INTO jornada (nombre) VALUES ('Diurna'), ('Nocturna'), ('Distancia'), ('Virtual');

-- Insert tipos de solicitud (from data dictionary)
INSERT INTO tipo_solicitud (nombre) VALUES
('Cancelación de semestre'),
('Curso dirigido'),
('Cancelación de asignaturas'),
('Cambio de jornada'),
('Transferencia interna'),
('Examen de validación por suficiencia'),
('Reingreso'),
('Matrícula mínima de créditos'),
('Traslado de sede'),
('Pago de créditos adicionales'),
('Constancia de estudio'),
('Certificado de notas'),
('Otra');

-- Insert sample academic programs
INSERT INTO programa_academico (codigo, nombre) VALUES
('90604', 'Técnica Profesional en Operaciones Logísticas'),
('90605', 'Tecnología en Gestión Logística Empresarial'),
('107860', 'Tecnología en Desarrollo de Software'),
('107861', 'Ingeniería de Software');

-- Insert sample students (passwords are plain text for demonstration)
INSERT INTO estudiante (nombre, apellido, email, password, programa_id, sede_id, jornada_id) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', '1234', 3, 1, 1),
('Maria', 'Gómez', 'maria.gomez@example.com', '1234', 4, 1, 1);

-- Insert sample administrator
INSERT INTO administrador (nombre, email, password) VALUES
('Administrador', 'admin@example.com', 'admin');

-- Insert sample requests
INSERT INTO solicitud (estudiante_id, tipo_solicitud_id, descripcion, estado) VALUES
(1, 1, 'Deseo cancelar el semestre por motivos personales.', 'Pendiente'),
(1, 3, 'Necesito cancelar la asignatura de Matemáticas.', 'Aprobada'),
(2, 4, 'Solicito cambio de jornada a nocturna.', 'Rechazada');