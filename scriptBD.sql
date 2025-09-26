CREATE DATABASE IF NOT EXISTS InfraWatch;
USE InfraWatch;

CREATE TABLE IF NOT EXISTS empresa (
    idEmpresa INT PRIMARY KEY,
    razão_social VARCHAR(100),
    cnpj CHAR(14),
    nome_fantasia VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS perfil_usuario (
    idperfil_usuario INT PRIMARY KEY,
    top_usuario VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS usuario (
    idUsuario INT PRIMARY KEY,
    nome VARCHAR(45),
    senha VARCHAR(200),
    perfil_usuario INT,
    fk_empresa INT,
    FOREIGN KEY (perfil_usuario) REFERENCES perfil_usuario(idperfil_usuario) ON DELETE CASCADE,
    FOREIGN KEY (fk_empresa) REFERENCES empresa(idempresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS token_acceso (
    idtoken_acceso INT PRIMARY KEY,
    data_criacao DATETIME,
    data_expiracao VARCHAR(45),
    ativo TINYINT,
    token VARCHAR(45),
    fk_usuario INT,
    FOREIGN KEY (fk_usuario) REFERENCES usuario(idUsuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS parametros_maquina (
    idParametros INT PRIMARY KEY,
    cpu_percent_max FLOAT,
    memoria_percent_max FLOAT,
    disk_percent_max FLOAT,
    net_sent_kbps_max FLOAT,
    net_recv_kbps_max FLOAT,
    temp_max_c FLOAT,
    load_avg1_max FLOAT,
    created_at VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS maquina (
    idMaquina INT PRIMARY KEY,
    hostname VARCHAR(128),
    usuario VARCHAR(128),
    status_maquina TINYINT,
    data_instalacao DATETIME,
    fk_empresa INT,
    fk_parametros_maquina INT,
    FOREIGN KEY (fk_parametros_maquina) REFERENCES parametros_maquina(idParametros) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS leitura_maquina (
    idLeitura INT PRIMARY KEY,
    hostname VARCHAR(128),
    ip VARCHAR(45),
    memoria FLOAT,
    maquina_cpu FLOAT,
    disk_percent FLOAT,
    disk_read_mb_s FLOAT,
    disk_write_mb_s FLOAT,
    net_sent_kbps FLOAT,
    net_recv_kbps FLOAT,
    uptime_seconds FLOAT,
    processos INT,
    cpu_freq_mhz FLOAT,
    cpu_temp_c FLOAT,
    load_avg_1min FLOAT,
    data_hora TIMESTAMP,
    fk_maquina INT,
    FOREIGN KEY (fk_maquina) REFERENCES maquina(idMaquina) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS parametro_alerta (
    idparametro_alerta INT PRIMARY KEY,
    minimo FLOAT,
    maximo FLOAT
);

CREATE TABLE IF NOT EXISTS alerta (
    idAlerta INT PRIMARY KEY,
    tipoAlerta VARCHAR(21),
    status_alerta CHAR(9),
    created_at TIMESTAMP,
    fk_leitura_maquina INT,
    fk_parametro_alerta INT,
    FOREIGN KEY (fk_leitura_maquina) REFERENCES leitura_maquina(idLeitura) ON DELETE CASCADE,
    FOREIGN KEY (fk_parametro_alerta) REFERENCES parametro_alerta(idparametro_alerta) ON DELETE CASCADE
);
