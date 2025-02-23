# Academic Project: Análise Exploratória de Dados Abertos do ENEM / INEP

## Table of Contents
- [Introduction](#introduction)
- [Objectives](#objectives)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction
Este projeto é parte da disciplina de Fundamentos de Bancos de Dados do Programa de Pós-Graduação em Ciência Aplicada - PPCA da UnB.

O principal objetivo é realizar uma análise exploratória de dados massivos por meio da contrução de um modelo relacional dos microdados 
do Exame Nacional do Ensino Médio - ENEM fornecidos pelo INEP através do portal [Dados Abertos](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/enem) do Governo Federal.

## Objectives
- Criar um Modelo Entidade-Relacionamento normalizado dos dados do ENEM
- Implementar um processo de extração, transformação e carga (ETL)
- Levantar e analisar 5 questões de interesse em relação a esses mesmos dados
- Utilizar álgebra relacional para realizar ao menos 3 análises
- Implementar ao menos uma procedure/function
- Implementar regras de negócio por meio de treiggers de banco

## Technologies Used
- Programming Language: SQL, PL/PgSQL
- Database: Postgres 17.3
- Other Tools: DBeaver, VSCode

## Installation
1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/your-repo-name.git
    ```
2. Navigate to the project directory:
    ```sh
    cd your-repo-name
    ```
3. Load microdata in nicrodados_enem table
4. Create database objects
    ```sh
    psql -h localhost -U postgres -d postgres -a -f project_dml.sql
    ```

## Usage
1. Run the database:
    ```sh
    docker run -d --name fbd -e POSTGRES_PASSWORD=passwd -p 5432:5432 -e PGDATA=/var/lib/postgresql/data/pgdata -v .\data:/var/lib/postgresql/data postgres
    ```
2. Access the application at:
    ```sh
    jdbc:postgresql://localhost:5432/postgres
    ```

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

## License
This project is licensed under the [License Name]. See the [LICENSE](LICENSE) file for more details.
