DROP DATABASE IF EXISTS infrawatch;
CREATE DATABASE infrawatch;
USE infrawatch;

CREATE TABLE empresa (
  idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
  razaoSocial VARCHAR(100) NOT NULL,
  nomeFantasia VARCHAR(45),
  cnpj CHAR(14) NOT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuario (
  idUsuario INT PRIMARY KEY AUTO_INCREMENT,
  fkEmpresa INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  email VARCHAR(100) NOT NULL,
  senha VARCHAR(200) NOT NULL,
  cargo VARCHAR(45),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_usuario_empresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE tipoDeContato (
  idTipoDeContato INT PRIMARY KEY AUTO_INCREMENT,
  telefone VARCHAR(45),
  email VARCHAR(100),
  usuario_idUsuario INT NOT NULL,
  usuario_fkEmpresa INT NOT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_tipocontato_usuario FOREIGN KEY (usuario_idUsuario) REFERENCES usuario(idUsuario),
  CONSTRAINT fk_tipocontato_empresa FOREIGN KEY (usuario_fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE acesso (
  idPermissao INT PRIMARY KEY AUTO_INCREMENT,
  tipoDePermissao TINYINT NOT NULL,
  nomeDeAcesso VARCHAR(45) NOT NULL,
  data_inicial DATE,
  data_final DATE,
  usuario_idUsuario INT NOT NULL,
  usuario_fkEmpresa INT NOT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_acesso_usuario FOREIGN KEY (usuario_idUsuario) REFERENCES usuario(idUsuario),
  CONSTRAINT fk_acesso_empresa FOREIGN KEY (usuario_fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE parametros_maquina (
  idParams INT PRIMARY KEY AUTO_INCREMENT,
  cpu_percent_max FLOAT,
  memoria_percent_max FLOAT,
  disk_percent_max FLOAT,
  net_sent_kbps_max FLOAT,
  net_recv_kbps_max FLOAT,
  temp_max_c FLOAT,
  load_avg1_max FLOAT,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE maquina (
  idMaquina INT PRIMARY KEY AUTO_INCREMENT,
  hostname VARCHAR(128) NOT NULL,
  usuario VARCHAR(128) NOT NULL,
  statusMaquina VARCHAR(16) DEFAULT 'ATIVO',
  dataInstalacao DATETIME,
  empresa_idEmpresa INT NOT NULL,
  parametros_idParams INT,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_maquina_empresa FOREIGN KEY (empresa_idEmpresa) REFERENCES empresa(idEmpresa),
  CONSTRAINT fk_maquina_parametros FOREIGN KEY (parametros_idParams) REFERENCES parametros_maquina(idParams)
);

CREATE TABLE componentes (
  idLeitura INT PRIMARY KEY AUTO_INCREMENT,
  idMaquina INT NOT NULL,
  hostname VARCHAR(128),
  ip VARCHAR(45),
  porcentagem FLOAT,
  memoria FLOAT,
  maquina_cpu FLOAT,
  disk_percent FLOAT,
  disk_read_mb_s FLOAT,
  disk_write_mb_s FLOAT,
  net_sent_kbps FLOAT,
  net_recv_kbps FLOAT,
  swap_percent FLOAT,
  uptime_segundos INT,
  processos INT,
  cpu_freq_mhz FLOAT,
  cpu_temp_c FLOAT,
  load_avg_1min FLOAT,
  data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_componentes_maquina FOREIGN KEY (idMaquina) REFERENCES maquina(idMaquina)
);

CREATE TABLE alerta (
  idAlerta INT PRIMARY KEY AUTO_INCREMENT,
  leitura_idLeitura INT NOT NULL,
  idMaquina INT NOT NULL,
  tipoAlerta VARCHAR(21) NOT NULL,
  statusAlerta CHAR(9) DEFAULT 'ABERTO',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_alerta_leitura FOREIGN KEY (leitura_idLeitura) REFERENCES componentes(idLeitura),
  CONSTRAINT fk_alerta_maquina FOREIGN KEY (idMaquina) REFERENCES maquina(idMaquina)
);

CREATE TABLE parametrosDoAlerta (
  idparametrosDoAlerta INT PRIMARY KEY AUTO_INCREMENT,
  componente TINYINT NOT NULL,
  minimo VARCHAR(45),
  maximo VARCHAR(45),
  alerta_idAlerta INT NOT NULL,
  alerta_leitura_idLeitura INT NOT NULL,
  alerta_idMaquina INT NOT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pda_alerta FOREIGN KEY (alerta_idAlerta) REFERENCES alerta(idAlerta),
  CONSTRAINT fk_pda_leitura FOREIGN KEY (alerta_leitura_idLeitura) REFERENCES componentes(idLeitura),
  CONSTRAINT fk_pda_maquina FOREIGN KEY (alerta_idMaquina) REFERENCES maquina(idMaquina)
);

INSERT INTO empresa (razaoSocial, nomeFantasia, cnpj)
VALUES ('Empresa Padrão', 'Default', '00000000000000');

INSERT INTO maquina (hostname, usuario, empresa_idEmpresa)
VALUES ('AIR_MACHINE', 'EFELIX', 1);
