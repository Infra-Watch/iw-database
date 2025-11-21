CREATE DATABASE IF NOT EXISTS infrawatch;
USE infrawatch;

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
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    codigo_de_permissoes VARCHAR(45) NOT NULL,
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

CREATE TABLE IF NOT EXISTS chave_de_acesso (
    idChave_de_acesso INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(45) UNIQUE NOT NULL,
    status_ativacao TINYINT NOT NULL,
    data_criacao DATETIME NOT NULL,
    data_expiracao DATETIME NOT NULL,
	fkCategoria_acesso INT NOT NULL,
    fkEmpresa INT,
    fkUsuario INT,
    FOREIGN KEY (fkEmpresa, fkUsuario) REFERENCES usuario(fkEmpresa, idUsuario) ON DELETE CASCADE,
    FOREIGN KEY (fkCategoria_acesso) REFERENCES categoria_acesso(idCategoria_acesso) ON DELETE CASCADE
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

INSERT INTO categoria_acesso (idCategoria_acesso, fkEmpresa, codigo_de_permissoes, nome, descricao) VALUES
(1000, 1000, '1000', 'Funcionário Infrawatch', 'Permite acessar as telas de cadastro de empresa cliente'),
(3000, 3000, '0111', 'Adm representante GRU', 'Permite acesso administrativo à empresa GRU');

INSERT INTO chave_de_acesso (codigo, status_ativacao, data_criacao, data_expiracao, fkCategoria_acesso) VALUES
('1AFG3K', 1, NOW(), date_add(NOW(), INTERVAL 7 DAY), 1000),
('4HJK1V', 1, NOW(), date_add(NOW(), INTERVAL 7 DAY), 3000);

INSERT INTO recurso_monitorado (idRecurso, nome, descricao, unidade_de_medida) VALUES
(1001, 'cpu_uso_porcentagem', 'Porcentagem de uso de CPU', '%'),
(1002, 'cpu_freq_mhz', 'Frequência de CPU', 'Hz'),
(1003, 'cpu_temp_c', 'Temperatura média de CPU', 'Hz'),
(1004, 'ram_uso_porcentagem', 'Porcentagem de uso de RAM', '%'),
(1005, 'ram_uso_gb', 'Gigabytes em uso de RAM', '%'),
(1006, 'disco_uso_porcentagem', 'Porcentagem de uso de disco', '%'),
(1007, 'disco_velocidade_escrita', 'Velocidade de escrita de disco', 'mbps'),
(1008, 'disco_velocidade_leitura', 'Velocidade de leitura de disco', 'mbps'),
(1009, 'transferencia_entrada_kbps', 'Kilobytes de entrada na rede', 'kbps'),
(1010, 'transferencia_saida_kbps', 'Kilobytes de saida na rede', 'kbps'),
(1011, 'processos', 'Quantidade de processos abertos', 'unidade'),
(1012, 'servicos', 'Quantidade de seviços ativos', 'unidade'),
(1013, 'threads', 'Quantidade de threads abertas', 'unidade');

DELIMITER $$
CREATE PROCEDURE inserir_captura_python(
	v_mac_address VARCHAR(45),
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
	DECLARE idEmpresa INT DEFAULT (SELECT fkEmpresa FROM maquina WHERE mac_address = v_mac_address);
    DECLARE idMaquina INT DEFAULT (SELECT idMaquina FROM maquina WHERE mac_address = v_mac_address);
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
	v_mac_address VARCHAR(45),
	servicos FLOAT,
	processos FLOAT,
	threads FLOAT,
    transferencia_entrada_kbps FLOAT,
    transferencia_saida_kbps FLOAT,
    data_hora DATETIME)
BEGIN
	DECLARE idEmpresa INT DEFAULT (SELECT fkEmpresa FROM maquina WHERE mac_address = v_mac_address);
    DECLARE idMaquina INT DEFAULT (SELECT idMaquina FROM maquina WHERE mac_address = v_mac_address);
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
	DECLARE idCategoria INT DEFAULT (SELECT idCategoria_acesso FROM categoria_acesso AS cat 
									JOIN chave_de_acesso AS chave ON cat.idCategoria_acesso = chave.fkCategoria_acesso 
									WHERE codigo = chave_acesso LIMIT 1);
	DECLARE idEmpresa INT DEFAULT (SELECT fkEmpresa FROM categoria_acesso WHERE idCategoria_acesso = idCategoria LIMIT 1);
    DECLARE idUsuario INT;
    INSERT INTO usuario(fkEmpresa, nome, email, senha, fkCategoria_acesso) VALUE (idEmpresa, nome, email, sha2(senha, 0), idCategoria);
    SET idUsuario = (SELECT last_insert_id());
	UPDATE chave_de_acesso SET fkUsuario = idUsuario, fkEmpresa = idEmpresa, status_ativacao = 0 WHERE codigo = chave_acesso;
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
        u.nome AS nome_usuario,
        u.nome AS nome,
        e.nome_fantasia AS nome_empresa,
        c.codigo_de_permissoes AS permissoes        
    FROM usuario AS u
    JOIN categoria_acesso AS c 
		ON u.fkCategoria_acesso = c.idCategoria_acesso
    JOIN empresa AS e
        ON u.fkEmpresa = e.idEmpresa
	WHERE
		u.email = email AND
        u.senha = sha2(senha, 0);
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buscar_empresas_geral()
BEGIN
	SELECT
		IFNULL(nome_fantasia, '') AS nome_fantasia,
		IFNULL(CASE WHEN LENGTH(cnpj) = 14 THEN CONCAT(SUBSTRING(cnpj, 1, 2), '.', SUBSTRING(cnpj, 3, 3), '.', SUBSTRING(cnpj, 6, 3), '/', SUBSTRING(cnpj, 9, 4), '-', SUBSTRING(cnpj, 13, 2)) ELSE cnpj END, '') AS cnpj,
		IFNULL(r.nome, '') AS nome_representante,
		IFNULL(idEmpresa, '') AS idEmpresa,
		IFNULL(MIN(ch.codigo), '') AS chave_acesso_adm
	FROM empresa AS e
		LEFT JOIN representante AS r
			ON r.fkEmpresa = e.idEmpresa 
		LEFT JOIN endereco AS a
			ON a.fkEmpresa = e.idEmpresa
		LEFT JOIN categoria_acesso AS ct
			ON ct.fkEmpresa = e.idEmpresa AND codigo_de_permissoes = '0111'
		LEFT JOIN chave_de_acesso AS ch
			ON ch.fkCategoria_acesso = ct.idCategoria_acesso
	GROUP BY idEmpresa, idRepresentante, idEndereco, idCategoria_acesso;
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buscar_empresa(
	v_idEmpresa INT
)
BEGIN
	SELECT
		IFNULL(idEmpresa, '') AS idEmpresa,
		IFNULL(razao_social, '') AS razao_social,
		IFNULL(CASE WHEN LENGTH(cnpj) = 14 THEN CONCAT(SUBSTRING(cnpj, 1, 2), '.', SUBSTRING(cnpj, 3, 3), '.', SUBSTRING(cnpj, 6, 3), '/', SUBSTRING(cnpj, 9, 4), '-', SUBSTRING(cnpj, 13, 2)) ELSE cnpj END, '') AS cnpj,
		IFNULL(nome_fantasia, '') AS nome_fantasia,
		IFNULL(r.nome, '') AS nome_representante,
		IFNULL(r.email, '') AS email_representante,
		IFNULL(r.telefone, '') AS telefone_representante,
		IFNULL(cep, '') AS cep,
		IFNULL(numero, '') AS numero,
		IFNULL(complemento, '') AS complemento,
		IFNULL(cidade, '') AS cidade,
		IFNULL(estado, '') AS estado,
		IFNULL(GROUP_CONCAT(ch.codigo SEPARATOR ','), '') AS chave_acesso_adm
	FROM empresa AS e
		LEFT JOIN representante AS r
			ON r.fkEmpresa = e.idEmpresa 
		LEFT JOIN endereco AS a
			ON a.fkEmpresa = e.idEmpresa
		LEFT JOIN categoria_acesso AS ct
			ON ct.fkEmpresa = e.idEmpresa AND codigo_de_permissoes = '0111'
		LEFT JOIN chave_de_acesso AS ch
			ON ch.fkCategoria_acesso = ct.idCategoria_acesso
    WHERE idEmpresa = v_idEmpresa
	GROUP BY idEmpresa, idRepresentante, idEndereco, idCategoria_acesso;
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE cadastrar_maquina(
	idEmpresa INT,
    mac_address VARCHAR(45),
	apelido VARCHAR(100))
BEGIN
	DECLARE idMaquina INT;
	INSERT INTO maquina(fkEmpresa, status_maquina, mac_address, apelido, data_instalacao) VALUE (idEmpresa, 1, replace(replace(mac_address, ":", ""), "-", ""), apelido, NOW());
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

DELIMITER $$
CREATE PROCEDURE criar_categoria_acesso(
	nome VARCHAR(45),
    descricao VARCHAR(200),
    codigo_de_permissoes VARCHAR(45),
    idEmpresa INT
)
BEGIN
	INSERT INTO categoria_acesso(nome, descricao, codigo_de_permissoes, fkEmpresa) VALUE (nome, descricao, codigo_de_permissoes, idEmpresa);
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE gerar_chave_de_acesso(
	idCategoria_acesso INT
)
BEGIN
	INSERT INTO chave_de_acesso(codigo, status_ativacao, data_criacao, data_expiracao, fkCategoria_acesso) VALUE (LEFT(MD5(RAND()), 8), 1, NOW(), date_add(NOW(), INTERVAL 7 DAY), idCategoria_acesso);
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buscar_maquinas(
	idEmpresa INT
)
BEGIN
	SELECT
		m.apelido AS nome_maquina,
		m.mac_address AS mac_address,
		m.status_maquina AS ativacao,
		COALESCE(COUNT(a.idAlerta), 0) AS qtd_alertas_24h
	FROM 
		maquina AS m
	LEFT JOIN registro_coleta AS c 
		ON (c.fkMaquina, c.fkEmpresa) = (m.idMaquina, m.fkEmpresa)
		AND c.data_hora > DATE_SUB(NOW(), INTERVAL 1 DAY)
	LEFT JOIN alerta AS a 
		ON (a.fkColeta, a.fkRecurso, a.fkMaquina, a.fkEmpresa) = (c.idColeta, c.fkRecurso, c.fkMaquina, c.fkEmpresa)
	WHERE 
		m.fkEmpresa = idEmpresa 
	GROUP BY 
		m.idMaquina, 
		m.apelido, 
		m.mac_address, 
		m.status_maquina;
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buscar_kpis_geral(idEmpresa INT, intervalo INT)
BEGIN
SELECT
	(SELECT COUNT(idMaquina) FROM maquina WHERE fkEmpresa = idEmpresa AND status_maquina) AS maquinas_ativas, 
    (SELECT COUNT(idMaquina)FROM maquina WHERE fkEmpresa = idEmpresa) AS maquinas_totais ,
    (SELECT IFNULL(SUM(leitura), 0) FROM registro_coleta WHERE fkRecurso IN (1009, 1010) AND fkEmpresa = idEmpresa AND data_hora > DATE_SUB(NOW(), INTERVAL intervalo DAY)) AS trafego_total_24h,
    (SELECT COUNT(idAlerta) FROM alerta AS a JOIN registro_coleta AS c 
		ON (a.fkColeta, a.fkRecurso, a.fkMaquina, a.fkEmpresa) = (c.idColeta, c.fkRecurso, c.fkMaquina, c.fkEmpresa)
		WHERE a.fkEmpresa = idEmpresa AND c.data_hora > DATE_SUB(NOW(), INTERVAL intervalo DAY)) AS total_alertas,
	IFNULL((SELECT apelido FROM maquina WHERE idMaquina = (SELECT fkMaquina FROM alerta WHERE fkEmpresa = idEmpresa GROUP BY fkMaquina HAVING COUNT(idAlerta) > 4 ORDER BY COUNT(idAlerta) DESC LIMIT 1)), 'Nenhuma') AS nome_maquina;
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buscar_alertas(idEmpresa INT, intervalo INT)
BEGIN
SELECT 
	idAlerta,
	a.mensagem,
    CONCAT(c.leitura, r.unidade_de_medida) AS leitura,
    IF(a.nivel = 2, 'Crítico', 'Atenção') AS nivel_label,
    a.nivel AS nivel_num,
	r.descricao AS componente,
    m.apelido AS maquina,
    data_hora
    FROM alerta AS a
	JOIN registro_coleta AS c
		ON (a.fkColeta, a.fkRecurso, a.fkMaquina, a.fkEmpresa) = (c.idColeta, c.fkRecurso, c.fkMaquina, c.fkEmpresa)
	JOIN maquina AS m
		ON (c.fkMaquina, c.fkEmpresa) = (m.idMaquina, m.fkEmpresa)
	JOIN recurso_monitorado AS r
		ON c.fkRecurso = r.idRecurso
	WHERE a.fkEmpresa = idEmpresa
		AND c.data_hora > DATE_SUB(NOW(), INTERVAL intervalo DAY)
	ORDER BY c.data_hora DESC, nivel_num DESC, idAlerta;
END
$$ DELIMITER ;


CREATE USER IF NOT EXISTS 'api_webdataviz'@'%' IDENTIFIED BY 'infrawatch1234';
GRANT EXECUTE ON infrawatch.* TO 'api_webdataviz'@'%';

CREATE USER IF NOT EXISTS 'captura_python'@'%' IDENTIFIED BY 'pyInfrawatch1234';
GRANT EXECUTE ON PROCEDURE infrawatch.inserir_captura_python TO 'captura_python'@'%';

CREATE USER IF NOT EXISTS 'captura_java'@'%' IDENTIFIED BY 'jarInfrawatch1234';
GRANT EXECUTE ON PROCEDURE infrawatch.inserir_captura_java TO 'captura_java'@'%';
FLUSH PRIVILEGES;