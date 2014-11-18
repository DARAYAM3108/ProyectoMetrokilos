SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema metrokilos
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `metrokilos` ;
CREATE SCHEMA IF NOT EXISTS `metrokilos` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `metrokilos` ;

-- -----------------------------------------------------
-- Table `metrokilos`.`tienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`tienda` (
  `idtienda` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `ubicacion` VARCHAR(45) NULL,
  PRIMARY KEY (`idtienda`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`traslado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`traslado` (
  `idtraslado` INT NOT NULL AUTO_INCREMENT,
  `idTiendaOrigen` INT NOT NULL,
  `idTiendaDestino` INT NOT NULL,
  `cantidad` INT NULL,
  `fecha` DATE NULL,
  PRIMARY KEY (`idtraslado`),
  INDEX `fk_traslado_tienda1_idx` (`idTiendaOrigen` ASC),
  INDEX `fk_traslado_tienda2_idx` (`idTiendaDestino` ASC),
  CONSTRAINT `fk_traslado_tienda1`
    FOREIGN KEY (`idTiendaOrigen`)
    REFERENCES `metrokilos`.`tienda` (`idtienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_traslado_tienda2`
    FOREIGN KEY (`idTiendaDestino`)
    REFERENCES `metrokilos`.`tienda` (`idtienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`categoriaEspecifica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`categoriaEspecifica` (
  `idCategoria` INT NOT NULL,
  `nombreCategoria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCategoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`categoriaProducto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`categoriaProducto` (
  `idCategoriaProducto` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NULL,
  `colorProducto` VARCHAR(30) NULL,
  `unidadMedida` VARCHAR(45) NULL,
  `idCategoriaEspecifica` INT NOT NULL,
  PRIMARY KEY (`idCategoriaProducto`, `idCategoriaEspecifica`),
  INDEX `fk_categoriaProducto_categoriaEspecifica1_idx` (`idCategoriaEspecifica` ASC),
  CONSTRAINT `fk_categoriaProducto_categoriaEspecifica1`
    FOREIGN KEY (`idCategoriaEspecifica`)
    REFERENCES `metrokilos`.`categoriaEspecifica` (`idCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`producto` (
  `idProducto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `precio` INT(15) NULL,
  `estado` TINYINT(1) NULL,
  `tipoProducto` VARCHAR(25) NULL,
  `idCategoriaProducto` INT NOT NULL,
  PRIMARY KEY (`idProducto`),
  INDEX `fk_producto_categoriaProducto_idx` (`idCategoriaProducto` ASC),
  CONSTRAINT `fk_producto_categoriaProducto`
    FOREIGN KEY (`idCategoriaProducto`)
    REFERENCES `metrokilos`.`categoriaProducto` (`idCategoriaProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`producto_traslado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`producto_traslado` (
  `producto_idproducto` INT NOT NULL,
  `traslado_idtraslado` INT NOT NULL,
  PRIMARY KEY (`producto_idproducto`, `traslado_idtraslado`),
  INDEX `fk_producto_has_traslado_traslado1_idx` (`traslado_idtraslado` ASC),
  INDEX `fk_producto_has_traslado_producto1_idx` (`producto_idproducto` ASC),
  CONSTRAINT `fk_producto_has_traslado_producto1`
    FOREIGN KEY (`producto_idproducto`)
    REFERENCES `metrokilos`.`producto` (`idProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_producto_has_traslado_traslado1`
    FOREIGN KEY (`traslado_idtraslado`)
    REFERENCES `metrokilos`.`traslado` (`idtraslado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`provedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`provedor` (
  `cedulaJudirica` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `descripcion` VARCHAR(60) NULL,
  `ubicacion` VARCHAR(60) NULL,
  `telefono` INT(15) NULL,
  `correo` VARCHAR(30) NULL,
  `pais` VARCHAR(30) NULL,
  PRIMARY KEY (`cedulaJudirica`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`cliente` (
  `idcliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `apellido` VARCHAR(45) NULL,
  `direccion` VARCHAR(60) NULL,
  PRIMARY KEY (`idcliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`transaccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`transaccion` (
  `idtransaccion` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NULL,
  `detalle` VARCHAR(45) NULL,
  `idtienda` INT NOT NULL,
  `formaPago` VARCHAR(45) NULL,
  PRIMARY KEY (`idtransaccion`),
  INDEX `fk_transaccion_tienda1_idx` (`idtienda` ASC),
  CONSTRAINT `fk_transaccion_tienda1`
    FOREIGN KEY (`idtienda`)
    REFERENCES `metrokilos`.`tienda` (`idtienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`producto_transaccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`producto_transaccion` (
  `producto_idproducto` INT NOT NULL,
  `transaccion_idtransaccion` INT NOT NULL,
  `cantidad` INT NULL,
  `precioBase` INT NULL,
  PRIMARY KEY (`producto_idproducto`, `transaccion_idtransaccion`),
  INDEX `fk_producto_has_transaccion_transaccion1_idx` (`transaccion_idtransaccion` ASC),
  INDEX `fk_producto_has_transaccion_producto1_idx` (`producto_idproducto` ASC),
  CONSTRAINT `fk_producto_has_transaccion_producto1`
    FOREIGN KEY (`producto_idproducto`)
    REFERENCES `metrokilos`.`producto` (`idProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_producto_has_transaccion_transaccion1`
    FOREIGN KEY (`transaccion_idtransaccion`)
    REFERENCES `metrokilos`.`transaccion` (`idtransaccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`compra` (
  `cedulaJudirica` INT NOT NULL,
  `idtransaccion` INT NOT NULL,
  PRIMARY KEY (`cedulaJudirica`, `idtransaccion`),
  INDEX `fk_compra_transaccion1_idx` (`idtransaccion` ASC),
  CONSTRAINT `fk_compra_provedor1`
    FOREIGN KEY (`cedulaJudirica`)
    REFERENCES `metrokilos`.`provedor` (`cedulaJudirica`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_transaccion1`
    FOREIGN KEY (`idtransaccion`)
    REFERENCES `metrokilos`.`transaccion` (`idtransaccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`venta` (
  `idtransaccion` INT NOT NULL,
  `idcliente` INT NOT NULL,
  PRIMARY KEY (`idtransaccion`, `idcliente`),
  INDEX `fk_venta_cliente1_idx` (`idcliente` ASC),
  CONSTRAINT `fk_venta_transaccion1`
    FOREIGN KEY (`idtransaccion`)
    REFERENCES `metrokilos`.`transaccion` (`idtransaccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venta_cliente1`
    FOREIGN KEY (`idcliente`)
    REFERENCES `metrokilos`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`producto_has_tienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`producto_has_tienda` (
  `producto_idProducto` INT NOT NULL,
  `tienda_idtienda` INT NOT NULL,
  `existencia` INT NULL DEFAULT 0,
  PRIMARY KEY (`producto_idProducto`, `tienda_idtienda`),
  INDEX `fk_producto_has_tienda_tienda1_idx` (`tienda_idtienda` ASC),
  INDEX `fk_producto_has_tienda_producto1_idx` (`producto_idProducto` ASC),
  CONSTRAINT `fk_producto_has_tienda_producto1`
    FOREIGN KEY (`producto_idProducto`)
    REFERENCES `metrokilos`.`producto` (`idProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_producto_has_tienda_tienda1`
    FOREIGN KEY (`tienda_idtienda`)
    REFERENCES `metrokilos`.`tienda` (`idtienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`usuario` (
  `idUsuario` INT NOT NULL,
  `cedula` VARCHAR(15) NOT NULL,
  `nombre` VARCHAR(10) NOT NULL,
  `apellidos` VARCHAR(15) NOT NULL,
  `telefono` VARCHAR(15) NOT NULL,
  `contraseña` VARCHAR(15) NOT NULL,
  `tipoUsuario` VARCHAR(10) NOT NULL,
  `tienda_idtienda` INT NOT NULL,
  PRIMARY KEY (`idUsuario`),
  INDEX `fk_usuario_tienda1_idx` (`tienda_idtienda` ASC),
  CONSTRAINT `fk_usuario_tienda1`
    FOREIGN KEY (`tienda_idtienda`)
    REFERENCES `metrokilos`.`tienda` (`idtienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metrokilos`.`responsableTransaccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metrokilos`.`responsableTransaccion` (
  `usuario_idUsuario` INT NOT NULL,
  `transaccion_idtransaccion` INT NOT NULL,
  `fechaTramite` DATETIME NOT NULL,
  PRIMARY KEY (`usuario_idUsuario`, `transaccion_idtransaccion`),
  INDEX `fk_usuario_has_transaccion_transaccion1_idx` (`transaccion_idtransaccion` ASC),
  INDEX `fk_usuario_has_transaccion_usuario1_idx` (`usuario_idUsuario` ASC),
  CONSTRAINT `fk_usuario_has_transaccion_usuario1`
    FOREIGN KEY (`usuario_idUsuario`)
    REFERENCES `metrokilos`.`usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_has_transaccion_transaccion1`
    FOREIGN KEY (`transaccion_idtransaccion`)
    REFERENCES `metrokilos`.`transaccion` (`idtransaccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
