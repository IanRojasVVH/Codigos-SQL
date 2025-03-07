-- MySQL Script generated by MySQL Workbench
-- Thu Mar  6 10:31:17 2025
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`tipo_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tipo_usuarios` (
  `id_tipo_usuario` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL,
  `created` DATETIME NOT NULL,
  PRIMARY KEY (`id_tipo_usuario`),
  UNIQUE INDEX `descripcion_UNIQUE` (`descripcion` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `telefono` INT NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `RUT` INT NOT NULL,
  `created` DATETIME NOT NULL,
  `tipo_usuario_id_tipo_usuario` INT NOT NULL,
  PRIMARY KEY (`id_usuario`, `tipo_usuario_id_tipo_usuario`),
  UNIQUE INDEX `correo_UNIQUE` (`correo` ASC) VISIBLE,
  INDEX `fk_usuarios_tipo_usuario_idx` (`tipo_usuario_id_tipo_usuario` ASC) VISIBLE,
  UNIQUE INDEX `password_UNIQUE` (`password` ASC) VISIBLE,
  UNIQUE INDEX `RUT_UNIQUE` (`RUT` ASC) VISIBLE,
  CONSTRAINT `fk_usuarios_tipo_usuario`
    FOREIGN KEY (`tipo_usuario_id_tipo_usuario`)
    REFERENCES `mydb`.`tipo_usuarios` (`id_tipo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pacientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pacientes` (
  `id_paciente` INT NOT NULL AUTO_INCREMENT,
  `created` DATETIME NULL,
  `usuarios_id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_paciente`, `usuarios_id_usuario`),
  INDEX `fk_pacientes_usuarios1_idx` (`usuarios_id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_pacientes_usuarios1`
    FOREIGN KEY (`usuarios_id_usuario`)
    REFERENCES `mydb`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`medicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`medicos` (
  `id_medico` INT NOT NULL,
  `especialidad` VARCHAR(45) NULL,
  `created` DATETIME NULL,
  `usuarios_id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_medico`, `usuarios_id_usuario`),
  INDEX `fk_medicos_usuarios1_idx` (`usuarios_id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_medicos_usuarios1`
    FOREIGN KEY (`usuarios_id_usuario`)
    REFERENCES `mydb`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`consultas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`consultas` (
  `id_consulta` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NULL,
  `hora` INT NULL,
  `motivo` VARCHAR(45) NULL,
  `diagnostico` VARCHAR(45) NULL,
  `created` DATETIME NULL,
  PRIMARY KEY (`id_consulta`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tratamientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tratamientos` (
  `id_tratamiento` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `descripcion` VARCHAR(45) NULL,
  `created` DATETIME NULL,
  PRIMARY KEY (`id_tratamiento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`citas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`citas` (
  `id_cita` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NULL,
  `hora` INT NULL,
  `estado` VARCHAR(45) NULL,
  `created` DATETIME NULL,
  `pacientes_id_paciente` INT NOT NULL,
  `medicos_id_medico` INT NOT NULL,
  PRIMARY KEY (`id_cita`, `pacientes_id_paciente`, `medicos_id_medico`),
  INDEX `fk_citas_pacientes1_idx` (`pacientes_id_paciente` ASC) VISIBLE,
  INDEX `fk_citas_medicos1_idx` (`medicos_id_medico` ASC) VISIBLE,
  CONSTRAINT `fk_citas_pacientes1`
    FOREIGN KEY (`pacientes_id_paciente`)
    REFERENCES `mydb`.`pacientes` (`id_paciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_citas_medicos1`
    FOREIGN KEY (`medicos_id_medico`)
    REFERENCES `mydb`.`medicos` (`id_medico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`consultas_has_tratamientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`consultas_has_tratamientos` (
  `created` DATETIME NULL,
  `consultas_id_consulta` INT NOT NULL,
  `tratamientos_id_tratamiento` INT NOT NULL,
  PRIMARY KEY (`consultas_id_consulta`, `tratamientos_id_tratamiento`),
  INDEX `fk_consultas_has_tratamientos_tratamientos1_idx` (`tratamientos_id_tratamiento` ASC) VISIBLE,
  INDEX `fk_consultas_has_tratamientos_consultas1_idx` (`consultas_id_consulta` ASC) VISIBLE,
  CONSTRAINT `fk_consultas_has_tratamientos_consultas1`
    FOREIGN KEY (`consultas_id_consulta`)
    REFERENCES `mydb`.`consultas` (`id_consulta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consultas_has_tratamientos_tratamientos1`
    FOREIGN KEY (`tratamientos_id_tratamiento`)
    REFERENCES `mydb`.`tratamientos` (`id_tratamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Operaciones CRUD
-- -----------------------------------------------------
-- Insertar tipos de usuario
INSERT INTO tipo_usuarios (descripcion, created) 
VALUES 
  ('Paciente', NOW()), 
  ('Médico', NOW()), 
  ('Administrativo', NOW());

-- Insertar usuarios
INSERT INTO usuarios (nombre_usuario, correo, telefono, password, RUT, created, tipo_usuario_id_tipo_usuario) 
VALUES 
  ('Juan Pérez', 'juan@example.com', 123456789, 'pass123', 11111111, NOW(), 1),
  ('Ana López', 'ana@example.com', 987654321, 'pass456', 22222222, NOW(), 2),
  ('Carlos Ruiz', 'carlos@example.com', 564738291, 'pass789', 33333333, NOW(), 3),
  ('Elena Torres', 'elena@example.com', 657483920, 'passabc', 44444444, NOW(), 1),
  ('Marta Vega', 'marta@example.com', 182736454, 'passdef', 55555555, NOW(), 2);

-- Insertar pacientes
INSERT INTO pacientes (created, usuarios_id_usuario) 
VALUES 
  (NOW(), 1),
  (NOW(), 4);

-- Insertar médicos
INSERT INTO medicos (id_medico, especialidad, created, usuarios_id_usuario) 
VALUES 
  (1, 'Cardiología', NOW(), 2),
  (2, 'Neurología', NOW(), 5);

-- Insertar consultas
INSERT INTO consultas (fecha, hora, motivo, diagnostico, created) 
VALUES 
  ('2025-03-10', 10, 'Dolor de cabeza', 'Migraña', NOW()),
  ('2025-03-11', 15, 'Dolor de pecho', 'Cardiopatía leve', NOW());

-- Insertar tratamientos
INSERT INTO tratamientos (nombre, descripcion, created) 
VALUES 
  ('Paracetamol', 'Analgésico común', NOW()),
  ('Aspirina', 'Antiinflamatorio y antipirético', NOW()),
  ('Ibuprofeno', 'Antiinflamatorio no esteroideo', NOW());

-- Insertar citas
INSERT INTO citas (fecha, hora, estado, created, pacientes_id_paciente, medicos_id_medico) 
VALUES 
  ('2025-03-15', 11, 'Aprobada', NOW(), 1, 1),
  ('2025-03-16', 14, 'Pendiente', NOW(), 2, 2);

-- Asociar consultas con tratamientos (relación muchos a muchos)
INSERT INTO consultas_has_tratamientos (consultas_id_consulta, tratamientos_id_tratamiento, created) 
VALUES 
  (1, 1, NOW()),
  (1, 2, NOW()),
  (2, 3, NOW());


-- Obtener todos los usuarios
SELECT * FROM usuarios;

-- Ver todas las consultas con sus detalles
SELECT * FROM consultas;

-- Consultar los tratamientos asociados a cada consulta
SELECT c.id_consulta, c.motivo, t.nombre AS tratamiento
FROM consultas_has_tratamientos cht
JOIN consultas c ON cht.consultas_id_consulta = c.id_consulta
JOIN tratamientos t ON cht.tratamientos_id_tratamiento = t.id_tratamiento;


-- Cambiar el estado de una cita
UPDATE citas 
SET estado = 'Aprobada' 
WHERE id_cita = 2;

-- Modificar el diagnóstico de una consulta
UPDATE consultas 
SET diagnostico = 'Hipertensión leve' 
WHERE id_consulta = 2;


-- Eliminar una consulta específica
DELETE FROM consultas 
WHERE id_consulta = 2;

-- Nota: Si la consulta tiene relaciones en otras tablas (como `consultas_has_tratamientos`),
-- primero hay que eliminar esos registros relacionados antes de eliminar la consulta.
DELETE FROM consultas_has_tratamientos WHERE consultas_id_consulta = 2;
DELETE FROM consultas WHERE id_consulta = 2;