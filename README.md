Engenharia de Dados com dbt, Snowflake e Apache Airflow
Projeto de engenharia de dados integrando dbt, Snowflake e Apache Airflow para ingestão, transformação e orquestração de dados em ambiente cloud.

Arquitetura
CSV (Seeds) → dbt → Snowflake → Docker (imagem dbt) → Airflow (orquestração)

Tecnologias utilizadas

Python 3.13
dbt 1.11.7 com adapter Snowflake
Snowflake (cloud data warehouse)
Apache Airflow 2.10.0
Docker


Pré-requisitos

Python >= 3.8
Docker Desktop instalado e em execução
Conta no Snowflake
Git


Como configurar o projeto
1. Clone o repositório
bashgit clone https://github.com/SEU_USUARIO/NOME_DO_REPO.git
cd NOME_DO_REPO
2. Crie e ative o ambiente virtual
bashpython -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
3. Instale as dependências
bashpip install -r requirements.txt

Configuração do Snowflake
Execute o script de setup no Snowflake para criar os objetos necessários:
sql-- Disponível em scripts/snowflake-setup.sql
O script cria:

Database: DBT_DEV_DB
Schema: JM
Role: DBT_ROLE
User: DBT_USER
Warehouse: DBT_WH


Configuração do dbt
1. Configure o profiles.yml
Entre na pasta src/dbt e renomeie o arquivo example_profiles.yml para profiles.yml.
Edite o arquivo e informe o account da sua conta Snowflake. Para encontrar o account, acesse a URL do Snowflake no navegador:
https://app.snowflake.com/nnrdzqp/ip80242/...
                           ^^^^^^^^^^^^^^^^
                           nnrdzqp-ip80242 ← esse é o account
2. Verifique a conexão
bashcd src/dbt
dbt debug

Ingestão de dados com dbt seed
bashcd src/dbt
dbt seed
Seeds carregados:

bookings_1
bookings_2
customers
tb_developer


Modelos dbt
Os modelos estão organizados em camadas:
CamadaModelosintermediateint_combined_bookings, int_customer, int_prepped_data, int_prepped_developermartmrt_developer, mrt_hotel_count_by_day, mrt_thirty_day_avg_cost
Para executar:
bashdbt run

Build da imagem Docker do dbt
bashcd src
docker build -t dbt-snowflake .

Subindo o Airflow
bashcd airflow
docker-compose up
Acesse: http://localhost:8081
Credenciais:

Usuário: airflow
Senha: airflow


DAG de orquestração
A DAG dbt-snowflake-process orquestra a execução dos modelos dbt via Docker, com schedule @hourly.
Tasks:

run_transformn — executa os modelos de transformação
run_analysis — executa os modelos de análise


Estrutura do projeto
dbt-airflow/
├── airflow/
│   ├── dags/
│   ├── docker-compose.yaml
│   └── .env
├── src/
│   └── dbt/
│       ├── models/
│       │   ├── intermediate/
│       │   └── mart/
│       ├── seeds/
│       ├── macros/
│       ├── dbt_project.yml
│       └── profiles.yml
├── scripts/
│   └── snowflake-setup.sql
├── requirements.txt
└── README.md