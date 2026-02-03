-- =====================================================
-- 1. Crear base de datos
-- =====================================================
CREATE DATABASE IF NOT EXISTS GestiOneDB
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE GestiOneDB;

-- =====================================================
-- 2. Tablas de catálogo / maestras (Sin dependencias)
-- =====================================================
CREATE TABLE roles (
  codigoRol INT AUTO_INCREMENT PRIMARY KEY,
  descripcionRol VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE estados (
  codigoEstado INT AUTO_INCREMENT PRIMARY KEY,
  descripcionEstado VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tipo_averia (
  codigoTipoAveria INT AUTO_INCREMENT PRIMARY KEY,
  descripcionTipoAv VARCHAR(100) NOT NULL,
  tiempoPromRepar INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tipo_maquinaria (
  codigoTipoMaquinaria INT AUTO_INCREMENT PRIMARY KEY,
  descripcionMaq VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- =====================================================
-- 3. Entidades principales
-- =====================================================

-- Tabla Usuario con EMAIL ÚNICO
CREATE TABLE usuario (
  codigoUsuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  codigoRolFK INT NOT NULL,
  telefono VARCHAR(17) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE, -- Restricción de unicidad aplicada
  password VARCHAR(100) NOT NULL,
  intentos INT DEFAULT 0,
  ultimoAcceso TIMESTAMP NULL,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT fk_usuario_rol
    FOREIGN KEY (codigoRolFK) REFERENCES roles(codigoRol)
) ENGINE=InnoDB;

-- Tabla Maquinaria
CREATE TABLE maquinaria (
  codigoMaquinaria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  codigoEstadoFK INT NOT NULL,
  fechaAlta DATE NOT NULL,
  fechaBaja DATE NULL,
  tipoMaquinariaFK INT NOT NULL,
  CONSTRAINT fk_maquinaria_estado
    FOREIGN KEY (codigoEstadoFK) REFERENCES estados(codigoEstado),
  CONSTRAINT fk_maquinaria_tipo
    FOREIGN KEY (tipoMaquinariaFK) REFERENCES tipo_maquinaria(codigoTipoMaquinaria)
) ENGINE=InnoDB;

-- Tabla Avería (Depende de Usuario, Maquinaria y Tipo de Avería)
CREATE TABLE averia (
  codigoAveria INT AUTO_INCREMENT PRIMARY KEY,
  descInicAveria VARCHAR(255) NOT NULL,
  fechaInicioAver DATETIME NOT NULL,
  fechaAsigTecnico DATETIME NULL,
  fechaAcepTecnico DATETIME NULL,
  fechaFinalizTecnico DATETIME NULL,
  procRealizadoTecnico VARCHAR(255) NULL,

  usuarioReportaFK INT NOT NULL,
  usuarioTecnicoFK INT NULL,
  maquinariaFK INT NOT NULL,
  tipoAveriaFK INT NOT NULL,

  CONSTRAINT fk_averia_reporta
    FOREIGN KEY (usuarioReportaFK) REFERENCES usuario(codigoUsuario),

  CONSTRAINT fk_averia_tecnico
    FOREIGN KEY (usuarioTecnicoFK) REFERENCES usuario(codigoUsuario),

  CONSTRAINT fk_averia_maquinaria
    FOREIGN KEY (maquinariaFK) REFERENCES maquinaria(codigoMaquinaria),

  CONSTRAINT fk_averia_tipo
    FOREIGN KEY (tipoAveriaFK) REFERENCES tipo_averia(codigoTipoAveria)
) ENGINE=INNODB;