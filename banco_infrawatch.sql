CREATE DATABASE IF NOT EXISTS infrawatch;
USE infrawatch;

-- Empresa
CREATE TABLE empresa (
  idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
  nomeEmpresa VARCHAR(100) NOT NULL,
  cnpj CHAR(14) NOT NULL,
  telefone CHAR(11) NULL,
  codigoCadastro CHAR(5) NOT NULL
);

-- Usuário
CREATE TABLE usuario (
  idUsuario INT PRIMARY KEY AUTO_INCREMENT,
  fkEmpresa INT NOT NULL,
  nomeUsuario VARCHAR(45) NOT NULL,
  emailUsuario VARCHAR(100) NOT NULL,
  senhaUsuario VARCHAR(200) NOT NULL, 
  cargo VARCHAR(45) NULL,
  codigoCadastro CHAR(5) NOT NULL,
  CONSTRAINT fk_usuario_empresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

-- CPU (máquina/host)
CREATE TABLE cpu (
  idCpu INT PRIMARY KEY AUTO_INCREMENT,
  hostname VARCHAR(128) NOT NULL,
  usuario VARCHAR(128) NOT NULL,
  statusCpu VARCHAR(16) DEFAULT 'ATIVO',
  dataInstalacao DATETIME NULL,
  fkEmpresa INT NULL,
  UNIQUE KEY uq_host_user (hostname, usuario),
  CONSTRAINT fk_cpu_empresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

-- Leituras da CPU
CREATE TABLE componentes (
  idLeitura INT PRIMARY KEY AUTO_INCREMENT,
  fkCpu INT NOT NULL,
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
  cpu_temp_c FLOAT NULL,
  load_avg_1min FLOAT NULL,
  data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_componentes_fkCpu_data (fkCpu, data_hora),
  CONSTRAINT fk_componentes_cpu FOREIGN KEY (fkCpu) REFERENCES cpu(idCpu)
);

-- Parâmetros ideais de CPU
CREATE TABLE parametros_cpu (
  idParams INT PRIMARY KEY AUTO_INCREMENT,
  fkCpu INT NOT NULL,
  cpu_percent_max FLOAT NULL,
  memoria_percent_max FLOAT NULL,
  disk_percent_max FLOAT NULL,
  net_sent_kbps_max FLOAT NULL,
  net_recv_kbps_max FLOAT NULL,
  temp_max_c FLOAT NULL,
  load_avg1_max FLOAT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_parametros_cpu FOREIGN KEY (fkCpu) REFERENCES cpu(idCpu)
);

-- Alertas (FK ajustada para 'componentes')
CREATE TABLE alerta (
  idAlerta INT PRIMARY KEY AUTO_INCREMENT,
  fkLeitura INT NOT NULL,
  fkCpu INT NOT NULL,
  tipoAlerta VARCHAR(21) NOT NULL,
  statusAlerta CHAR(9) NOT NULL DEFAULT 'ABERTO',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_alerta_fk (fkCpu, fkLeitura),
  CONSTRAINT fk_alerta_leitura FOREIGN KEY (fkLeitura) REFERENCES componentes(idLeitura),
  CONSTRAINT fk_alerta_cpu FOREIGN KEY (fkCpu) REFERENCES cpu(idCpu)
);
