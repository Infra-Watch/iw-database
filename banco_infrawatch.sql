CREATE DATABASE infrawatch;

USE infrawatch;

CREATE TABLE cpu (
    id INT PRIMARY KEY AUTO_INCREMENT,
    host VARCHAR(128),
    usuario VARCHAR(128),
    porcentagem FLOAT,          -- uso percentual de CPU (%)
    memoria FLOAT,              -- uso percentual de memória (%)
    maquina_cpu FLOAT,          -- memória usada em GB
    disk_percent FLOAT,         -- uso do disco (%)
    disk_read_mb_s FLOAT,       -- taxa de leitura em MB/s
    disk_write_mb_s FLOAT,      -- taxa de escrita em MB/s
    net_sent_kbps FLOAT,        -- taxa de envio em kbps
    net_recv_kbps FLOAT,        -- taxa de recebimento em kbps
    swap_percent FLOAT,         -- uso de memória swap (%)
    uptime_segundos INT,        -- tempo ligado desde o boot
    processos INT,              -- quantidade de processos ativos
    cpu_freq_mhz FLOAT,         -- frequência atual da CPU em MHz
    cpu_temp_c FLOAT NULL,      -- temperatura da CPU (pode ser null se não suportado)
    load_avg_1min FLOAT NULL,   -- load average 1 min (Unix-like)
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM cpu;

