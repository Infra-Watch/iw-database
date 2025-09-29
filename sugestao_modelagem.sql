-- Na tabela componente serão inseridos de forma pré definida todas categorias de leituras realizadas, uma a uma como segue exemplo
INSERT INTO componente(nome, descricao, unidade_de_medida, potencia_de_dez) VALUES
	('Porcentagem de uso de CPU', 'Monitora em porcentagem com precisão de duas casas decimais o uso médio de CPU da máquina', '%', 2),
	('Porcentagem de uso de RAM', 'Monitora em porcentagem com precisão de duas casas decimais o uso médio de RAM da máquina', '%', 2),
	('Porcentagem de uso de disco', 'Monitora em porcentagem com precisão de duas casas decimais o uso médio de disco da máquina', '%', 2),
    ('Velocidade de leitura de disco', 'Monitora em mbps com precisão de quatro casas decimais a velocidade de leitura do disco', 'mbps', 4),
    ('Quantidade de processos abertos', 'Monitora a quantidade em unidades de processos sendo executados na máquina', 'unidade', 1),
    ('Frequência de CPU', 'Monitora em Hz a frequência média com três casas decimais de precisão da CPU', 'Hz', 3);
    
# A tabela alerta será pré definida, contendo as informações sobre os tipos de alerta e suas criticidades como segue exemplo
INSERT INTO alerta(nivel_de_criticidade, tipo_de_alerta) VALUES 
	(1, 'Moderadamente alto'),
	(1, 'Moderadamente baixo'),
	(2, 'Muito alto'),
	(2, 'Muito baixo'),
	(3, 'Criticamente alto'),
	(3, 'Criticamente baixo');
    
# A tabela coleta será atualizada automaticamente pelo app client através de um PROCEDURE que irá adicionar as leituras 
# de cada componente a partir de somente uma requisição.
# Exemplo, no python será chamado: "procedure_de_insert_coleta(uso_cpu, uso_ram, ..., freq_cpu);" e no própio procedure será feito o insert individual por componente
# Importante destacar que o alerta será validado por trigger, quando inserido o valor é inserido na coleta automaticamente acessa a tabela parametro
# e compara com o valor para associar um alerta ou não

# A tabela empresa será utilizada por funcionarios internos da Infrawatch que cadastrarão os clientes a partir de uma tela de cadastro
# Essa tabela já virá por padrão a própia Infrawatch, como segue exemplo:
INSERT INTO empresa(idEmpresa, razao_social, cnpj, nome_fantasia) VALUE (1000, 'Infrawatch LTDA.', 1234567890001, 'Infrawatch');

# A tabela token será um CRUD do site onde o usuário administrador pode criar e gerenciar tokens de acesso que serão distibuídos aos funcionários
# Importante destacar que o atributo "codigo_de_permissoes" será fundamental para definir quais funcionalidades o usuario associado terá acesso
# O primeiro token, com as permissoes de adm será gerado automaticamente durante o cadastro de empresa cliente e disponibilizado ao contratante
# Haverá uma permissão específica para acessar as telas internas da Infrawatch, como exemplo cadastro de empresa cliente
INSERT INTO token_de_acesso(fkEmpresa, nome, descricao, token, data_expiracao, codigo_de_permissoes) VALUES
	(1000, 'Funcionário Infrawatch', 'Permite acessar as telas de cadastro de empresa cliente', '1AFG3K', '2050-01-01 00:00:00', '1000'),
	(3000, 'Adm representante GRU', 'Permite acesso administrativo à empresa GRU', '4HJK1V', '2050-01-01 00:00:00', '0111');
    
# A tabela usuario armazena as informações do usuário que são obtidas na hora do cadastro, importante observar que por ser dependente de uma empresa e
# de um token liberado pela empresa, o usuário só pode se cadastrar caso ele tenha o token de acesso.
# Igualmente, caso o token dele esteja expirado ele deve registrar outro token ou pedir para seu administrador reativar o seu.
# Isso implica numa tela de cadastro de usuario, validaçao de token ativo e tela de inserir outro token caso o último tenha expirado 

# As tabelas maquina e config_de_componente serão inseridas no momento da instalação do app client, a aplicação python irá coletar o mac_adress
# para identificação da máquina, caso já esteja cadastrada ou não, e vai perguntar ao usuário os componentes que deseja monitorar --- ?
# nessa etapa um a um os status de componentes daquela máquina serão inseridos como 0 (não monitorado) ou 1 (monitoramento ativo)
# A tabela config_do_componente vai ser um CRUD do site onde o usuário administrador poderá personalizar os parâmetros de cada componente monitorado