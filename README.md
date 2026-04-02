# Pipeline de Dados com dbt, Snowflake e Apache Airflow
 
Pipeline de dados construído com dbt, Snowflake e Apache Airflow, orquestrando a ingestão, transformação e disponibilização de dados em ambiente cloud.
 
---
 
## Sobre o Projeto
 
Desenvolvimento de um pipeline automatizado que ingere dados via dbt seeds, transforma em camadas intermediária e mart, e orquestra toda a execução através do Apache Airflow com containers Docker.
 
---
 
## Tecnologias Utilizadas
 
- **Python 3.13**
- **dbt 1.11.7** — transformação e modelagem de dados
- **Snowflake** — cloud data warehouse
- **Apache Airflow 2.10.0** — orquestração do pipeline
- **Docker + Docker Compose** — ambiente isolado e reproduzível
 
---
 
## Arquitetura
 
```
CSV (Seeds) → dbt → Snowflake → Imagem Docker (dbt) → Airflow (orquestração)
```
 
---
 
## Estrutura do Projeto
 
```
dbt-airflow/
│
├── airflow/
│   ├── dags/
│   │   └── docker-dbt-snowflake.py   # DAG principal do Airflow
│   ├── docker-compose.yaml           # Configuração do ambiente Docker
│   └── .env
│
├── src/
│   └── dbt/
│       ├── models/
│       │   ├── intermediate/         # Camada de transformação
│       │   └── mart/                 # Camada analítica
│       ├── seeds/                    # Arquivos CSV de entrada
│       ├── macros/
│       ├── dbt_project.yml
│       └── profiles.yml
│
├── scripts/
│   └── snowflake-setup.sql
├── requirements.txt
└── README.md
```
 
---
 
## Como Executar
 
### Pré-requisitos
 
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado e rodando
- Python >= 3.8
- Conta no Snowflake
 
### 1. Clonar o repositório
 
```bash
git clone https://github.com/IgorRamos099/dbt-snowflake-airflow.git
cd dbt-snowflake-airflow
```
 
### 2. Criar e ativar o ambiente virtual
 
```bash
python -m venv venv
 
venv\Scripts\activate
 
```
 
### 3. Instalar as dependências
 
```bash
pip install -r requirements.txt
```
 
### 4. Configurar o Snowflake
 
Execute o script `scripts/snowflake-setup.sql` no Snowflake para criar os objetos necessários (database, schema, role, user e warehouse).
 
### 5. Configurar o dbt
 
Renomeie `src/dbt/example_profiles.yml` para `profiles.yml` e informe o account da sua conta Snowflake.
 
Para encontrar o account, veja a URL do Snowflake:
```
https://app.snowflake.com/nnrdzqp/ip80242/...
                           → account: nnrdzqp-ip80242
```
 
Verifique a conexão:
```bash
cd src/dbt
dbt debug
```
 
### 6. Subir o Airflow
 
```bash
cd airflow
docker compose up -d
```
 
Acesse: `http://localhost:8081`
- Login: `airflow`
- Senha: `airflow`
 
### 7. Build da imagem Docker do dbt
 
```bash
cd src
docker build -t dbt-snowflake .
```
 
---
 
## Etapas do Pipeline
 
### Ingestão — `dbt seed`
- Lê os arquivos CSV da pasta `seeds/`
- Carrega no Snowflake sem transformações
- Tabelas: `bookings_1`, `bookings_2`, `customers`, `tb_developer`
 
### Intermediate — camada de transformação
- `int_combined_bookings` — unifica bookings_1 e bookings_2
- `int_customer` — prepara dados de clientes
- `int_prepped_data` — join entre clientes e bookings
- `int_prepped_developer` — prepara dados de developers
 
### Mart — camada analítica
- `mrt_developer` — visão analítica de developers
- `mrt_hotel_count_by_day` — contagem de hotéis por dia
- `mrt_thirty_day_avg_cost` — custo médio dos últimos 30 dias
 
---
 
## Resultados
 
Após a execução do pipeline, as seguintes views são materializadas no Snowflake:
 
| Model | Camada | Descrição |
|---|---|---|
| `int_combined_bookings` | Intermediate | Bookings unificados |
| `int_prepped_data` | Intermediate | Dados preparados para análise |
| `mrt_hotel_count_by_day` | Mart | Contagem de hotéis por dia |
| `mrt_thirty_day_avg_cost` | Mart | Custo médio 30 dias |
 
---
 
## Comandos Úteis
 
```bash
# Iniciar Airflow
docker compose up -d
 
# Parar Airflow
docker compose down
 
# Ver logs
docker compose logs -f
 
# Executar seeds do dbt
dbt seed
 
# Executar modelos do dbt
dbt run
 
# Testar conexão dbt
dbt debug
```
 
---
 
## Referências

- [Repositório base](https://github.com/wlcamargo/dbt-snowflake-airflow)
- [Documentação dbt](https://docs.getdbt.com)
- [Documentação Snowflake](https://docs.snowflake.com)
- [Documentação Apache Airflow](https://airflow.apache.org/docs/)
