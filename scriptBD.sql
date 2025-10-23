CREATE DATABASE IF NOT EXISTS INFRAWATCH;
USE INFRAWATCH;

CREATE TABLE IF NOT EXISTS empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razao_social VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    nome_fantasia VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS representante(
    idRepresentante INT AUTO_INCREMENT,
	fkEmpresa INT NOT NULL, 
	nome VARCHAR(45) NOT NULL,
    email VARCHAR(45) UNIQUE NOT NULL,
    telefone VARCHAR(11) UNIQUE NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE,
    CONSTRAINT pkCompostaRepresentanteEmpresa PRIMARY KEY (idRepresentante, fkEmpresa)
);

CREATE TABLE IF NOT EXISTS endereco (
    idEndereco INT AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    cep CHAR(8) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(45),
    cidade VARCHAR(45) NOT NULL,
    estado VARCHAR(45) NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE,
	CONSTRAINT pkCompostaEnderecoEmpresa PRIMARY KEY (idEndereco, fkEmpresa)
);

CREATE TABLE IF NOT EXISTS categoria_acesso (
    idCategoria_acesso INT PRIMARY KEY AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    chave_de_acesso VARCHAR(45) UNIQUE NOT NULL,
    status_ativacao TINYINT NOT NULL,
    codigo_de_permissoes VARCHAR(45) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    data_criacao DATETIME NOT NULL,
    data_expiracao DATETIME NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS usuario (
    idUsuario INT AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    fkCategoria_acesso INT,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE,
    FOREIGN KEY (fkCategoria_acesso) REFERENCES categoria_acesso(idCategoria_acesso) ON DELETE SET NULL,
	CONSTRAINT pkCompostaUsuarioEmpresa PRIMARY KEY (idUsuario, fkEmpresa)
);

CREATE TABLE IF NOT EXISTS maquina (
    idMaquina INT AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    status_maquina TINYINT NOT NULL,
    mac_address VARCHAR(45) NOT NULL UNIQUE,
    apelido VARCHAR(100) NOT NULL,
    data_instalacao DATETIME,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE,
	CONSTRAINT pkCompostaMaquinaEmpresa PRIMARY KEY (idMaquina, fkEmpresa)
);

CREATE TABLE IF NOT EXISTS recurso_monitorado (
    idRecurso INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(200),
    unidade_de_medida VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS config_recurso (
    fkRecurso INT NOT NULL,
    fkMaquina INT NOT NULL,
    fkEmpresa INT NOT NULL,
    status_de_monitoramento TINYINT NOT NULL,
    FOREIGN KEY (fkRecurso) REFERENCES recurso_monitorado(idRecurso) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES maquina(fkEmpresa) ON DELETE CASCADE,
    CONSTRAINT pkCompostaConfigRecurso PRIMARY KEY (fkRecurso, fkMaquina, fkEmpresa)
);

CREATE TABLE IF NOT EXISTS parametro (
    idParametro INT AUTO_INCREMENT,
    fkRecurso INT NOT NULL,
    fkMaquina INT NOT NULL,
    fkEmpresa INT NOT NULL,
    valor FLOAT NOT NULL,
    nivel INT NOT NULL,
    FOREIGN KEY (fkRecurso) REFERENCES config_recurso(fkRecurso) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES config_recurso(fkMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES config_recurso(fkEmpresa) ON DELETE CASCADE,
    CONSTRAINT pkCompostaParametro PRIMARY KEY (idParametro, fkRecurso, fkMaquina, fkEmpresa)
);

CREATE TABLE IF NOT EXISTS registro_coleta (
    idColeta INT AUTO_INCREMENT,
    fkRecurso INT NOT NULL,
    fkMaquina INT NOT NULL,
    fkEmpresa INT NOT NULL,
    leitura FLOAT,
    data_hora DATETIME NOT NULL,
    FOREIGN KEY (fkRecurso) REFERENCES config_recurso(fkRecurso) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES config_recurso(fkMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES config_recurso(fkEmpresa) ON DELETE CASCADE,
	CONSTRAINT pkCompostaColeta PRIMARY KEY (idColeta, fkRecurso, fkMaquina, fkEmpresa)
);

CREATE TABLE IF NOT EXISTS alerta (
    idAlerta INT AUTO_INCREMENT,
    fkColeta INT NOT NULL,
    fkRecurso INT NOT NULL,
    fkMaquina INT NOT NULL,
    fkEmpresa INT NOT NULL,
	mensagem VARCHAR(45),
    nivel INT,
    FOREIGN KEY (fkColeta) REFERENCES registro_coleta(idColeta) ON DELETE CASCADE,
    FOREIGN KEY (fkRecurso) REFERENCES registro_coleta(fkRecurso) ON DELETE CASCADE,
    FOREIGN KEY (fkMaquina) REFERENCES registro_coleta(fkMaquina) ON DELETE CASCADE,
    FOREIGN KEY (fkEmpresa) REFERENCES registro_coleta(fkEmpresa) ON DELETE CASCADE,
	CONSTRAINT pkCompostaAlerta PRIMARY KEY (idAlerta, fkColeta, fkRecurso, fkMaquina, fkEmpresa)
);

-- INSERÇÃO DE DADOS

INSERT INTO empresa (idEmpresa, razao_social, cnpj, nome_fantasia) VALUES
(1000, 'Infrawatch LTDA.', '12345678900001', 'Infrawatch'),
(3000, 'GRU Tecnologia S.A.', '98765432100001', 'GRU');

INSERT INTO representante (idRepresentante, nome, email, telefone, fkEmpresa) VALUES
(1, 'João da Silva', 'joao.silva@infrawatch.com', '11987654321', 1000),
(2, 'Maria Oliveira', 'maria.oliver@gru.com', '21998765432', 3000);

INSERT INTO categoria_acesso (fkEmpresa, chave_de_acesso, status_ativacao, codigo_de_permissoes, nome, descricao, data_criacao, data_expiracao) VALUES
(1000, '1AFG3K', 1, '1000', 'Funcionário Infrawatch', 'Permite acessar as telas de cadastro de empresa cliente', NOW(), '2050-01-01 00:00:00'),
(3000, '4HJK1V', 1, '0111', 'Adm representante GRU', 'Permite acesso administrativo à empresa GRU', NOW(), '2050-01-01 00:00:00');

INSERT INTO recurso_monitorado (idRecurso, nome, descricao, unidade_de_medida) VALUES
(1001, 'cpu_uso_porcentagem', 'Porcentagem de uso de CPU', '%'),
(1002, 'cpu_freq_mhz', 'Frequência de CPU', 'Hz'),
(1003, 'cpu_temp_c', 'Temperatura média de CPU', 'Hz'),
(1004, 'ram_uso_porcentagem', 'Porcentagem de uso de RAM', '%'),
(1005, 'ram_uso_gb', 'Gigabytes em uso de RAM', '%'),
(1006, 'disco_uso_porcentagem', 'Porcentagem de uso de disco', '%'),
(1007, 'disco_velocidade_escrita', 'Velocidade de escrita de disco', 'mbps'),
(1008, 'disco_velocidade_leitura', 'Velocidade de leitura de disco', 'mbps'),
(1009, 'transferencia_entrada_kbps', 'Kilobytes de entrada na rede', 'unidade'),
(1010, 'transferencia_saida_kbps', 'Kilobytes de saida na rede', 'unidade'),
(1011, 'processos', 'Quantidade de processos abertos', 'unidade'),
(1012, 'servicos', 'Quantidade de seviços ativos', 'unidade'),
(1013, 'threads', 'Quantidade de threads abertas', 'unidade');

DELIMITER $$
CREATE PROCEDURE inserir_captura_python(
	mac_address VARCHAR(45),
    cpu_uso_porcentagem FLOAT,
    cpu_freq_mhz FLOAT,
    cpu_temp_c FLOAT,
    ram_uso_porcentagem FLOAT,
    ram_uso_gb FLOAT,
    disco_uso_porcentagem FLOAT,
    disco_velocidade_escrita FLOAT,
    disco_velocidade_leitura FLOAT,
    transferencia_entrada_kbps FLOAT,
    transferencia_saida_kbps FLOAT,
    data_hora DATETIME)
BEGIN
	DECLARE idEmpresa INT DEFAULT (SELECT fkEmpresa FROM maquina WHERE mac_address = mac_address);
    DECLARE idMaquina INT DEFAULT (SELECT idMaquina FROM maquina WHERE mac_address = mac_address);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1001, idMaquina, idEmpresa, cpu_uso_porcentagem, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1002, idMaquina, idEmpresa, cpu_freq_mhz,data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1003, idMaquina, idEmpresa, cpu_temp_c, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1004, idMaquina, idEmpresa, ram_uso_porcentagem, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1005, idMaquina, idEmpresa, ram_uso_gb,  data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1006, idMaquina, idEmpresa, disco_uso_porcentagem, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1007, idMaquina, idEmpresa, disco_velocidade_escrita, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1008, idMaquina, idEmpresa, disco_velocidade_leitura, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1009, idMaquina, idEmpresa, transferencia_entrada_kbps, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1010, idMaquina, idEmpresa, transferencia_saida_kbps, data_hora);    
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE inserir_captura_java(
	mac_address VARCHAR(45),
	servicos FLOAT,
	processos FLOAT,
	threads FLOAT,
    transferencia_entrada_kbps FLOAT,
    transferencia_saida_kbps FLOAT,
    data_hora DATETIME)
BEGIN
	DECLARE idEmpresa INT DEFAULT (SELECT fkEmpresa FROM maquina WHERE mac_address = mac_address);
    DECLARE idMaquina INT DEFAULT (SELECT idMaquina FROM maquina WHERE mac_address = mac_address);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1009, idMaquina, idEmpresa, transferencia_entrada_kbps, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1010, idMaquina, idEmpresa, transferencia_saida_kbps, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1011, idMaquina, idEmpresa, processos, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1012, idMaquina, idEmpresa, serviços, data_hora);
    INSERT INTO registro_coleta (fkRecurso, fkMaquina, fkEmpresa, leitura, data_hora) VALUE (1013, idMaquina, idEmpresa, threads, data_hora);
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE cadastrar_usuario(
	nome VARCHAR(45),
    email VARCHAR(100),
    senha VARCHAR(255),
    chave_acesso VARCHAR(45))
BEGIN
	DECLARE idCategoria INT DEFAULT (SELECT idCategoria_acesso FROM categoria_acesso WHERE chave_de_acesso = chave_acesso LIMIT 1);
	DECLARE idEmpresa INT DEFAULT (SELECT fkEmpresa FROM categoria_acesso WHERE idCategoria_acesso = idCategoria LIMIT 1);
    INSERT INTO usuario(fkEmpresa, nome, email, senha, fkCategoria_acesso) VALUE (idEmpresa, nome, email, sha2(senha, 0), idCategoria);
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE autenticar_usuario(
	email VARCHAR(45),
    senha VARCHAR(255)
)
BEGIN
	SELECT
		u.idUsuario AS idUsuario,
        u.fkEmpresa AS idEmpresa,
        u.fkCategoria_acesso AS idCategoria,
        u.nome AS nome,
        u.email AS email,
        c.status_ativacao AS status_ativacao,
        c.codigo_de_permissoes AS permissoes        
    FROM usuario AS u
    JOIN categoria_acesso AS c 
		ON u.fkCategoria_acesso = c.idCategoria_acesso
	WHERE
		u.email = email AND
        u.senha = sha2(senha, 0);
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE cadastrar_maquina(
	idEmpresa INT,
    mac_address VARCHAR(45),
	apelido VARCHAR(100))
BEGIN
	DECLARE idMaquina INT;
	INSERT INTO maquina(fkEmpresa, status_maquina, mac_address, apelido, data_instalacao) VALUE (idEmpresa, 1, mac_address, apelido, NOW());
    SET idMaquina = (SELECT last_insert_id());
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1001, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1002, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1003, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1004, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1005, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1006, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1007, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1008, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1009, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1010, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1011, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1012, idMaquina, idEmpresa, 1);
    INSERT INTO config_recurso (fkRecurso, fkMaquina, fkEmpresa, status_de_monitoramento) VALUE (1013, idMaquina, idEmpresa, 1);
END
$$ DELIMITER ;


CREATE USER 'api_webdataviz'@'%' IDENTIFIED BY 'infrawatch1234';
GRANT EXECUTE ON infrawatch.* TO 'api_webdataviz'@'%';

CREATE USER 'captura_python'@'%' IDENTIFIED BY 'pyInfrawatch1234';
GRANT EXECUTE ON PROCEDURE infrawatch.inserir_captura_python TO 'captura_python'@'%';

CREATE USER 'captura_java'@'%' IDENTIFIED BY 'jarInfrawatch1234';
GRANT EXECUTE ON PROCEDURE infrawatch.inserir_captura_java TO 'captura_java'@'%';
FLUSH PRIVILEGES;