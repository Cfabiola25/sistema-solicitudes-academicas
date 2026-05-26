-- =========================================================
-- Base de datos: fesc_solicitudes
-- Proyecto: Sistema de Solicitudes Académicas FESC
-- Motor recomendado: MySQL 8.x / MariaDB 10.x
-- =========================================================

DROP DATABASE IF EXISTS fesc_solicitudes;

CREATE DATABASE fesc_solicitudes
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE fesc_solicitudes;

-- =========================================================
-- Tablas maestras
-- =========================================================

CREATE TABLE sede (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,

  CONSTRAINT uk_sede_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE jornada (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,

  CONSTRAINT uk_jornada_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE programa_academico (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(20) NOT NULL,
  nombre VARCHAR(200) NOT NULL,

  CONSTRAINT uk_programa_codigo UNIQUE (codigo),
  CONSTRAINT uk_programa_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE tipo_solicitud (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tiempo_respuesta_dias INT UNSIGNED NOT NULL DEFAULT 5,
  tipo_tiempo ENUM('habiles', 'calendario') NOT NULL DEFAULT 'habiles',
  activo TINYINT(1) NOT NULL DEFAULT 1,

  CONSTRAINT uk_tipo_solicitud_nombre UNIQUE (nombre),
  CONSTRAINT chk_tipo_solicitud_tiempo CHECK (tiempo_respuesta_dias > 0)
) ENGINE=InnoDB;

-- =========================================================
-- Usuarios del sistema
-- =========================================================

CREATE TABLE estudiante (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL,
  password VARCHAR(255) NOT NULL,
  programa_id INT UNSIGNED NOT NULL,
  sede_id INT UNSIGNED NOT NULL,
  jornada_id INT UNSIGNED NOT NULL,
  terminos_aceptados TINYINT(1) NOT NULL DEFAULT 0,
  recuperacion_token VARCHAR(150) NULL,
  token_expiracion DATETIME NULL,
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT uk_estudiante_email UNIQUE (email),
  CONSTRAINT fk_estudiante_programa
    FOREIGN KEY (programa_id) REFERENCES programa_academico(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_estudiante_sede
    FOREIGN KEY (sede_id) REFERENCES sede(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_estudiante_jornada
    FOREIGN KEY (jornada_id) REFERENCES jornada(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_estudiante_terminos CHECK (terminos_aceptados IN (0, 1))
) ENGINE=InnoDB;

CREATE TABLE administrador (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL,
  password VARCHAR(255) NOT NULL,
  rol ENUM('SuperAdmin', 'Admin', 'Secretaria') NOT NULL DEFAULT 'Admin',
  recuperacion_token VARCHAR(150) NULL,
  token_expiracion DATETIME NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT uk_administrador_email UNIQUE (email),
  CONSTRAINT chk_administrador_activo CHECK (activo IN (0, 1))
) ENGINE=InnoDB;

CREATE TABLE tipo_solicitud_responsable (
  tipo_solicitud_id INT UNSIGNED NOT NULL,
  admin_id INT UNSIGNED NOT NULL,
  fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (tipo_solicitud_id, admin_id),
  CONSTRAINT fk_tipo_responsable_tipo
    FOREIGN KEY (tipo_solicitud_id) REFERENCES tipo_solicitud(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_tipo_responsable_admin
    FOREIGN KEY (admin_id) REFERENCES administrador(id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- Solicitudes académicas
-- =========================================================

CREATE TABLE solicitud (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  estudiante_id INT UNSIGNED NOT NULL,
  tipo_solicitud_id INT UNSIGNED NOT NULL,
  descripcion TEXT NOT NULL,
  fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('Enviada', 'Pendiente', 'Aprobada', 'Rechazada', 'Anulada') NOT NULL DEFAULT 'Enviada',
  documento VARCHAR(255) NULL,
  fecha_limite DATETIME NULL,
  fecha_respuesta DATETIME NULL,
  comentario_respuesta TEXT NULL,
  admin_id INT UNSIGNED NULL,
  responsable_id INT UNSIGNED NULL,

  CONSTRAINT fk_solicitud_estudiante
    FOREIGN KEY (estudiante_id) REFERENCES estudiante(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_solicitud_tipo
    FOREIGN KEY (tipo_solicitud_id) REFERENCES tipo_solicitud(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_solicitud_admin_respuesta
    FOREIGN KEY (admin_id) REFERENCES administrador(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_solicitud_responsable
    FOREIGN KEY (responsable_id) REFERENCES administrador(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE solicitud_mensaje (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  solicitud_id INT UNSIGNED NOT NULL,
  autor_rol ENUM('student', 'admin') NOT NULL,
  autor_nombre VARCHAR(150) NOT NULL,
  mensaje TEXT NOT NULL,
  archivo VARCHAR(255) NULL,
  fecha_envio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_mensaje_solicitud
    FOREIGN KEY (solicitud_id) REFERENCES solicitud(id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE auditoria_retraso (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  solicitud_id INT UNSIGNED NOT NULL,
  admin_id INT UNSIGNED NOT NULL,
  dias_retraso INT UNSIGNED NOT NULL,
  fecha_auditoria DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_auditoria_solicitud
    FOREIGN KEY (solicitud_id) REFERENCES solicitud(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_auditoria_admin
    FOREIGN KEY (admin_id) REFERENCES administrador(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- Índices para búsquedas frecuentes
-- =========================================================

CREATE INDEX idx_estudiante_programa ON estudiante(programa_id);
CREATE INDEX idx_estudiante_sede ON estudiante(sede_id);
CREATE INDEX idx_estudiante_jornada ON estudiante(jornada_id);
CREATE INDEX idx_solicitud_estudiante ON solicitud(estudiante_id);
CREATE INDEX idx_solicitud_tipo ON solicitud(tipo_solicitud_id);
CREATE INDEX idx_solicitud_estado ON solicitud(estado);
CREATE INDEX idx_solicitud_fecha ON solicitud(fecha_solicitud);
CREATE INDEX idx_solicitud_responsable ON solicitud(responsable_id);
CREATE INDEX idx_mensaje_solicitud ON solicitud_mensaje(solicitud_id);
CREATE INDEX idx_auditoria_solicitud ON auditoria_retraso(solicitud_id);

-- =========================================================
-- Datos iniciales
-- =========================================================

INSERT INTO sede (nombre) VALUES
('Cúcuta'),
('Ocaña');

INSERT INTO jornada (nombre) VALUES
('Diurna'),
('Nocturna'),
('Distancia'),
('Virtual');

INSERT INTO programa_academico (codigo, nombre) VALUES
('90604', 'Técnica Profesional en Operaciones Logísticas'),
('90605', 'Tecnología en Gestión Logística Empresarial'),
('107860', 'Tecnología en Desarrollo de Software'),
('107861', 'Ingeniería de Software');

INSERT INTO tipo_solicitud (nombre, tiempo_respuesta_dias, tipo_tiempo) VALUES
('Cancelación de semestre', 5, 'habiles'),
('Curso dirigido', 5, 'habiles'),
('Cancelación de asignaturas', 5, 'habiles'),
('Cambio de jornada', 5, 'habiles'),
('Transferencia interna', 5, 'habiles'),
('Examen de validación por suficiencia', 7, 'calendario'),
('Reingreso', 5, 'habiles'),
('Matrícula mínima de créditos', 5, 'habiles'),
('Traslado de sede', 5, 'habiles'),
('Pago de créditos adicionales', 5, 'habiles'),
('Constancia de estudio', 3, 'habiles'),
('Certificado de notas', 3, 'habiles'),
('Otra', 5, 'habiles');

UPDATE tipo_solicitud
SET nombre = 'Cancelación de asignaturas'
WHERE nombre = 'Cancelación de asignaturas';

-- Contraseña de prueba: conservar el hash generado por la aplicación.
INSERT INTO estudiante
(nombre, apellido, email, password, programa_id, sede_id, jornada_id, terminos_aceptados)
VALUES
('Juan', 'Pérez', 'juan.perez@example.com',
 'NH0ODzMnTen8FGAGFnnUnQ==:ek1xhK2SWdyyhvOUJ0TrHd4pstSJT21bMrVEBaf/+sA=',
 3, 1, 1, 1),
('María', 'Gómez', 'maria.gomez@example.com',
 'NH0ODzMnTen8FGAGFnnUnQ==:ek1xhK2SWdyyhvOUJ0TrHd4pstSJT21bMrVEBaf/+sA=',
 4, 1, 1, 1);

-- Usuario administrador inicial.
INSERT INTO administrador (nombre, email, password, rol)
VALUES
('Administrador', 'admin@example.com',
 'r5FLHDAUCXgd47rQLn+SzA==:g5u4G/HVfD85RntwRM/7z8HkDRRvpDKQp8b9M6pywT0=',
 'SuperAdmin');

SELECT 'BASE DE DATOS CREADA CORRECTAMENTE' AS resultado;
