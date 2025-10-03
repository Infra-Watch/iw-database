CREATE DATABASE IF NOT EXISTS INFRAWATCH;
USE INFRAWATCH;

-- Tabela Empresa
CREATE TABLE IF NOT EXISTS empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razao_social VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    nome_fantasia VARCHAR(100)
);

-- Tabela Token de Acesso
CREATE TABLE IF NOT EXISTS token_acesso (
    idToken_acesso INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
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

-- Tabela Usuario
CREATE TABLE IF NOT EXISTS usuario (
    idUsuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fkToken_acesso INT NOT NULL,
    fkEmpresa INT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    senha VARCHAR(45) NOT NULL,
    FOREIGN KEY (fkToken_acesso) REFERENCES token_acesso(idToken_acesso) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

-- Tabela Maquina
CREATE TABLE IF NOT EXISTS maquina (
    idMaquina INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fkEmpresa INT NOT NULL,
    status_maquina TINYINT NOT NULL,
    mac_adress VARCHAR(45) NOT NULL,
    data_instalacao DATETIME,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

-- Tabela Componente
CREATE TABLE IF NOT EXISTS componente (
    idComponente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(200),
    unidade_de_medida VARCHAR(45) NOT NULL,
    potencia_de_dez INT NOT NULL
);

-- Tabela Config de Componente
CREATE TABLE IF NOT EXISTS config_de_componente (
    fkComponente INT NOT NULL,
    fkMaquina INT NOT NULL,
    fkEmpresa INT NOT NULL,
    status_de_monitoramento TINYINT NOT NULL,
    parametro_maximo INT,
    parametro_minimo INT,
    PRIMARY KEY (fkComponente, fkMaquina, fkEmpresa),
    FOREIGN KEY (fkComponente) REFERENCES componente(idComponente) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

-- Tabela Alerta
CREATE TABLE IF NOT EXISTS alerta (
    idAlerta INT PRIMARY KEY AUTO_INCREMENT,
    nivel_de_criticidade INT NOT NULL,
    tipo_de_alerta VARCHAR(45) NOT NULL
);

-- Tabela Coleta
CREATE TABLE IF NOT EXISTS coleta (
    idColeta INT NOT NULL AUTO_INCREMENT,
    fkComponente INT NOT NULL,
    fkMaquina INT NOT NULL,
    fkEmpresa INT NOT NULL,
    leitura INT NOT NULL,
    data_hora DATETIME NOT NULL,
    fkAlerta INT,
    PRIMARY KEY (idColeta, fkComponente, fkMaquina, fkEmpresa),
    FOREIGN KEY (fkComponente) REFERENCES componente(idComponente) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE,
    FOREIGN KEY (fkAlerta) REFERENCES alerta(idAlerta) ON DELETE CASCADE
);

-- Inserir Empresas
INSERT INTO empresa (idEmpresa, razao_social, cnpj, nome_fantasia) VALUES
(1000, 'Infrawatch LTDA.', '12345678900001', 'Infrawatch'),
(3000, 'GRU Tecnologia S.A.', '98765432100001', 'GRU');

-- Inserir Tokens de Acesso
INSERT INTO token_acesso(fkEmpresa, token, ativo, codigo_de_permissoes, nome, descricao, data_criacao, data_expiracao) VALUES
(1000, '1AFG3K', 1, '1000', 'Funcionário Infrawatch', 'Permite acessar as telas de cadastro de empresa cliente', NOW(), '2050-01-01 00:00:00'),
(3000, '4HJK1V', 1, '0111', 'Adm representante GRU', 'Permite acesso administrativo à empresa GRU', NOW(), '2050-01-01 00:00:00');

-- Inserir Componentes
INSERT INTO componente(nome, descricao, unidade_de_medida, potencia_de_dez) VALUES
('Porcentagem de uso de CPU', 'Monitora em porcentagem com precisão de duas casas decimais o uso médio de CPU da máquina', '%', 2),
('Porcentagem de uso de RAM', 'Monitora em porcentagem com precisão de duas casas decimais o uso médio de RAM da máquina', '%', 2),
('Porcentagem de uso de disco', 'Monitora em porcentagem com precisão de duas casas decimais o uso médio de disco da máquina', '%', 2),
('Velocidade de leitura de disco', 'Monitora em mbps com precisão de quatro casas decimais a velocidade de leitura do disco', 'mbps', 4),
('Quantidade de processos abertos', 'Monitora a quantidade em unidades de processos sendo executados na máquina', 'unidade', 1),
('Frequência de CPU', 'Monitora em Hz a frequência média com três casas decimais de precisão da CPU', 'Hz', 3);

-- Inserir Alertas
INSERT INTO alerta(nivel_de_criticidade, tipo_de_alerta) VALUES 
(1, 'Moderadamente alto'),
(1, 'Moderadamente baixo'),
(2, 'Muito alto'),
(2, 'Muito baixo'),
(3, 'Criticamente alto'),
(3, 'Criticamente baixo');