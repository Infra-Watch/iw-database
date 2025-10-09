CREATE DATABASE IF NOT EXISTS INFRAWATCH;
USE INFRAWATCH;

CREATE TABLE IF NOT EXISTS representante_empresa (
    idRepresentante INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(45) UNIQUE NOT NULL,
    telefone VARCHAR(11) UNIQUE NOT NULL,
    cargo VARCHAR(45) not null
);

CREATE TABLE IF NOT EXISTS empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razao_social VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    nome_fantasia VARCHAR(100),
    fkRepresentante INT NOT NULL,
    FOREIGN KEY (fkRepresentante) REFERENCES representante_empresa(idRepresentante) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS endereco_empresa (
    idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    cep CHAR(8) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(45),
    cidade VARCHAR(45) NOT NULL,
    estado VARCHAR(45) NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS token_acesso (
    idToken_acesso INT PRIMARY KEY AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    token VARCHAR(45) UNIQUE NOT NULL,
    ativo TINYINT NOT NULL,
    codigo_de_permissoes VARCHAR(45) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    data_criacao DATETIME NOT NULL,
    data_expiracao DATETIME NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    fkToken_acesso INT,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(100) NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE,
    FOREIGN KEY (fkToken_acesso) REFERENCES token_acesso(idToken_acesso) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS maquina (
    idMaquina INT PRIMARY KEY AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    status_maquina TINYINT NOT NULL,
    mac_address VARCHAR(45) NOT NULL,
    data_instalacao DATETIME,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS recurso_maquina (
    idRecurso INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(200),
    unidade_de_medida VARCHAR(45) NOT NULL,
    potencia_de_dez INT NOT NULL
);

CREATE TABLE IF NOT EXISTS config_recurso (
    fkRecurso INT NOT NULL,
    fkMaquina INT NOT NULL,
    fkEmpresa INT NOT NULL,
    status_de_monitoramento TINYINT NOT NULL,
    parametro_maximo INT,
    parametro_minimo INT,
    PRIMARY KEY (fkRecurso, fkMaquina, fkEmpresa),
    FOREIGN KEY (fkRecurso) REFERENCES recurso_maquina(idRecurso) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS alerta (
    idAlerta INT PRIMARY KEY AUTO_INCREMENT,
    nivel_de_criticidade INT NOT NULL,
    tipo_de_alerta VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS registro_coleta (
    idRegistro INT PRIMARY KEY AUTO_INCREMENT,
    fkRecurso INT NOT NULL,
    fkMaquina INT NOT NULL,
    fkEmpresa INT NOT NULL,
    leitura INT NOT NULL,
    data_hora DATETIME NOT NULL,
    fkAlerta INT,
    FOREIGN KEY (fkRecurso) REFERENCES recurso_maquina(idRecurso) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE,
    FOREIGN KEY (fkAlerta) REFERENCES alerta(idAlerta) ON DELETE CASCADE
);

-- INSERÇÃO DE DADOS

INSERT INTO representante_empresa (idRepresentante, nome, email, telefone, cargo) VALUES
(1, 'João da Silva', 'joao.silva@infrawatch.com', '11987654321', 'Gerente de Contas'),
(2, 'Maria Oliveira', 'maria.oliver@gru.com', '21998765432', 'Diretora Técnica');

INSERT INTO empresa (idEmpresa, razao_social, cnpj, nome_fantasia, fkRepresentante) VALUES
(1000, 'Infrawatch LTDA.', '12345678900001', 'Infrawatch', 1),
(3000, 'GRU Tecnologia S.A.', '98765432100001', 'GRU', 2);

INSERT INTO token_acesso (fkEmpresa, token, ativo, codigo_de_permissoes, nome, descricao, data_criacao, data_expiracao) VALUES
(1000, '1AFG3K', 1, '1000', 'Funcionário Infrawatch', 'Permite acessar as telas de cadastro de empresa cliente', NOW(), '2050-01-01 00:00:00'),
(3000, '4HJK1V', 1, '0111', 'Adm representante GRU', 'Permite acesso administrativo à empresa GRU', NOW(), '2050-01-01 00:00:00');

INSERT INTO recurso_maquina (nome, descricao, unidade_de_medida, potencia_de_dez) VALUES
('Porcentagem de uso de CPU', 'Monitora o uso médio de CPU da máquina', '%', 2),
('Porcentagem de uso de RAM', 'Monitora o uso médio de RAM da máquina', '%', 2),
('Porcentagem de uso de disco', 'Monitora o uso médio de disco da máquina', '%', 2),
('Velocidade de leitura de disco', 'Monitora a velocidade de leitura do disco', 'mbps', 4),
('Quantidade de processos abertos', 'Monitora o número de processos em execução', 'unidade', 1),
('Frequência de CPU', 'Monitora a frequência média da CPU', 'Hz', 3);

INSERT INTO alerta (nivel_de_criticidade, tipo_de_alerta) VALUES
(1, 'Moderadamente alto'),
(1, 'Moderadamente baixo'),
(2, 'Muito alto'),
(2, 'Muito baixo'),
(3, 'Criticamente alto'),
(3, 'Criticamente baixo');