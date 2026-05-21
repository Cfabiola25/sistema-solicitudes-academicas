-- SQL script to create and populate the database for the
-- Sistema de Solicitudes Académicas. Run this script in your
-- MySQL client to set up the schema and insert initial data.

CREATE DATABASE IF NOT EXISTS fesc_solicitudes;
USE fesc_solicitudes;

-- Drop tables in order of foreign key dependencies to allow clean recreation
DROP TABLE IF EXISTS auditoria_retraso;
DROP TABLE IF EXISTS solicitud_mensaje;
DROP TABLE IF EXISTS solicitud;
DROP TABLE IF EXISTS estudiante;
DROP TABLE IF EXISTS administrador;
DROP TABLE IF EXISTS tipo_solicitud;
DROP TABLE IF EXISTS programa_academico;
DROP TABLE IF EXISTS sede;
DROP TABLE IF EXISTS jornada;


-- Table definitions

CREATE TABLE IF NOT EXISTS tipo_solicitud (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tiempo_respuesta_dias INT DEFAULT 5,
  tipo_tiempo ENUM('habiles', 'calendario') DEFAULT 'habiles'
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
  password VARCHAR(200),
  programa_id INT,
  sede_id INT,
  jornada_id INT,
  terminos_aceptados TINYINT(1) DEFAULT 0,
  recuperacion_token VARCHAR(100) NULL,
  token_expiracion DATETIME NULL,
  FOREIGN KEY (programa_id) REFERENCES programa_academico(id),
  FOREIGN KEY (sede_id) REFERENCES sede(id),
  FOREIGN KEY (jornada_id) REFERENCES jornada(id)
);

CREATE TABLE IF NOT EXISTS administrador (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(200),
  rol VARCHAR(50) DEFAULT 'Coordinador',
  recuperacion_token VARCHAR(100) NULL,
  token_expiracion DATETIME NULL
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
  responsable_id INT,
  fecha_limite DATETIME NULL,
  FOREIGN KEY (estudiante_id) REFERENCES estudiante(id),
  FOREIGN KEY (tipo_solicitud_id) REFERENCES tipo_solicitud(id),
  FOREIGN KEY (admin_id) REFERENCES administrador(id),
  FOREIGN KEY (responsable_id) REFERENCES administrador(id)
);

CREATE TABLE IF NOT EXISTS auditoria_retraso (
  id INT AUTO_INCREMENT PRIMARY KEY,
  solicitud_id INT NOT NULL,
  admin_id INT NOT NULL,
  dias_retraso INT NOT NULL,
  fecha_auditoria DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (solicitud_id) REFERENCES solicitud(id) ON DELETE CASCADE,
  FOREIGN KEY (admin_id) REFERENCES administrador(id)
);

CREATE TABLE IF NOT EXISTS solicitud_mensaje (
  id INT AUTO_INCREMENT PRIMARY KEY,
  solicitud_id INT NOT NULL,
  autor_rol ENUM('student','admin') NOT NULL,
  autor_nombre VARCHAR(150) NOT NULL,
  mensaje TEXT NOT NULL,
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (solicitud_id) REFERENCES solicitud(id) ON DELETE CASCADE
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

-- Insert sample students (passwords are secure hashes for '1234')
INSERT INTO estudiante (nombre, apellido, email, password, programa_id, sede_id, jornada_id, terminos_aceptados) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', 'NH0ODzMnTen8FGAGFnnUnQ==:ek1xhK2SWdyyhvOUJ0TrHd4pstSJT21bMrVEBaf/+sA=', 3, 1, 1, 1),
('Maria', 'Gómez', 'maria.gomez@example.com', 'NH0ODzMnTen8FGAGFnnUnQ==:ek1xhK2SWdyyhvOUJ0TrHd4pstSJT21bMrVEBaf/+sA=', 4, 1, 1, 1);

-- Insert sample administrator (password is secure hash for 'admin')
INSERT INTO administrador (nombre, email, password, rol) VALUES
('Administrador', 'admin@example.com', 'r5FLHDAUCXgd47rQLn+SzA==:g5u4G/HVfD85RntwRM/7z8HkDRRvpDKQp8b9M6pywT0=', 'SuperAdmin');

-- Insert sample requests
INSERT INTO solicitud (estudiante_id, tipo_solicitud_id, descripcion, estado) VALUES
(1, 1, 'Deseo cancelar el semestre por motivos personales.', 'Pendiente'),
(1, 3, 'Necesito cancelar la asignatura de Matemáticas.', 'Aprobada'),
(2, 4, 'Solicito cambio de jornada a nocturna.', 'Rechazada');