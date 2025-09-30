CREATE DATABASE IF NOT EXISTS INFRAWATCH;
USE INFRAWATCH;

CREATE TABLE IF NOT EXISTS empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razao_social VARCHAR(100),
    cnpj CHAR(14),
    nome_fantasia VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS token_acesso (
    idToken_acesso INT PRIMARY KEY AUTO_INCREMENT,
    fkEmpresa INT,
    token VARCHAR(45),
    ativo TINYINT,
    codigo_de_permissoes VARCHAR(45),
    nome VARCHAR(45),
    descricao VARCHAR(45),
    data_criacao DATETIME,
    data_expiracao DATETIME,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    fkToken_acesso INT,
    fkEmpresa INT,
    nome VARCHAR(45),
    email VARCHAR(45),
    senha VARCHAR(45),
    FOREIGN KEY (fkToken_acesso) REFERENCES token_acesso(idToken_acesso) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS maquina (
    idMaquina INT PRIMARY KEY AUTO_INCREMENT,
    fkEmpresa INT,
    status_maquina TINYINT,
    mac_adress VARCHAR(45),
    data_instalacao DATETIME,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS componente (
    idComponente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    descricao VARCHAR(45),
    unidade_de_medida VARCHAR(45),
    potencia_de_dez INT
);

CREATE TABLE IF NOT EXISTS config_de_componente (
    fkComponente INT,
    fkMaquina INT,
    fkEmpresa INT,
    status_de_monitoramento TINYINT,
    parametro_maximo INT,
    parametro_minimo INT,
    PRIMARY KEY (fkComponente, fkMaquina),
    FOREIGN KEY (fkComponente) REFERENCES componente(idComponente) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS alerta (
    idAlerta INT PRIMARY KEY AUTO_INCREMENT,
    nivel_de_criticidade INT,
    tipo_de_alerta VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS coleta (
    idColeta INT PRIMARY KEY AUTO_INCREMENT,
    fkComponente INT,
    fkMaquina INT,
    fkEmpresa INT,
    leitura INT,
    data_hora DATETIME,
    fkAlerta INT,
    FOREIGN KEY (fkComponente) REFERENCES componente(idComponente) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE,
    FOREIGN KEY (fkAlerta) REFERENCES alerta(idAlerta) ON DELETE CASCADE
);
