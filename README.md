# Mini Projeto Avaliativo - TODOs

Aplicação mobile desenvolvida em Flutter como projeto avaliativo do Módulo 02 do curso de Desenvolvimento Mobile.

O projeto implementa o fluxo básico de uma aplicação com autenticação, persistência de sessão, consumo de API REST, armazenamento local em SQLite e gerenciamento de tarefas.

## Objetivo

Desenvolver uma aplicação Flutter capaz de integrar diferentes formas de persistência e consumo de dados, aplicando conceitos de Programação Orientada a Objetos, arquitetura MVVM, gerenciamento de estado e tratamento de erros.

A aplicação permite:

- realizar login utilizando uma API;
- manter a sessão do usuário utilizando SharedPreferences;
- consultar tarefas através de uma API REST;
- armazenar as tarefas localmente utilizando SQLite;
- pesquisar e filtrar tarefas;
- marcar tarefas como concluídas;
- manter localmente o estado das tarefas;
- realizar logout da aplicação.

## Funcionalidades

### Splash Screen

Ao iniciar a aplicação, a Splash Screen verifica se existe uma sessão salva no dispositivo.

- Usuário autenticado: navega para a Home.
- Usuário não autenticado: navega para o Login.

### Login

A tela de login possui:

- campo de usuário;
- campo de senha;
- opção para mostrar ou ocultar a senha;
- validação de campos obrigatórios;
- autenticação através da API;
- tratamento de erros;
- armazenamento do nome, sobrenome e estado da sessão através de SharedPreferences.

### Home

Após a autenticação, a Home apresenta:

- nome e sobrenome do usuário;
- lista de tarefas;
- pesquisa pelo texto da tarefa;
- filtro por todas, pendentes e concluídas;
- representação visual diferenciada para tarefas concluídas;
- atualização do estado da tarefa através de checkbox;
- persistência das alterações no SQLite;
- opção de logout.

## Arquitetura

O projeto foi organizado utilizando o padrão MVVM (Model-View-ViewModel), buscando separar a interface gráfica, o gerenciamento de estado e o acesso aos dados.

Fluxo simplificado:

```text
View
  ↓
ViewModel
  ↓
Repository
  ↓
Datasource
  ├── API REST
  ├── SQLite
  └── SharedPreferences
```

Além das camadas principais, o projeto possui componentes compartilhados para comunicação HTTP, tratamento de exceções, banco de dados, rotas e padrão Result.

### Estrutura principal

```text
lib/
├── main.dart
└── src/
    ├── data/
    │   ├── auth/
    │   ├── preferences/
    │   └── todo/
    ├── shared/
    │   ├── app_client/
    │   ├── database/
    │   ├── result/
    │   └── routes/
    ├── view/
    │   ├── home/
    │   ├── login/
    │   └── splash/
    └── viewmodel/
```

## Tecnologias e conceitos utilizados

- Flutter
- Dart
- Dio
- Provider
- SQFlite
- SharedPreferences
- Path
- API REST
- SQLite
- MVVM
- Repository Pattern
- Datasource Pattern
- Result Pattern
- Programação Orientada a Objetos
- abstrações e polimorfismo
- tratamento de exceções
- navegação nomeada
- gerenciamento de estado
- manipulação de coleções com `map`, `where` e `every`
- Git e GitFlow simplificado

## APIs utilizadas

A aplicação utiliza os endpoints disponibilizados pelo DummyJSON:

```text
POST /auth/login
GET /todos
```

O login é realizado remotamente e os TODOs recebidos são convertidos em objetos da aplicação e armazenados no banco SQLite.

## Persistência de dados

O projeto utiliza duas estratégias de persistência local.

### SharedPreferences

Utilizado para armazenar:

- estado da sessão;
- nome do usuário;
- sobrenome do usuário.

Esses dados são utilizados pela Splash Screen para determinar o fluxo inicial da aplicação.

### SQLite

Utilizado para armazenar as tarefas recebidas da API.

Após o primeiro carregamento, os dados persistidos podem ser consultados localmente. Alterações no estado das tarefas também são gravadas no banco, permitindo preservar o estado local entre execuções da aplicação.

## Tratamento de erros

A comunicação com a API é abstraída através de um Client baseado em Dio.

O projeto possui exceções específicas para situações como:

- problemas de conexão;
- autenticação não autorizada;
- falha na conversão de dados.

Os repositories utilizam o padrão `Result`, representando operações através de estados de sucesso (`Success`) ou falha (`Failure`).

## Como executar

### Pré-requisitos

- Flutter SDK instalado;
- Dart SDK;
- Android SDK ou dispositivo compatível;
- Git.

### Clonar o projeto

```bash
git clone https://github.com/eribertotorres/clayton_dev.git
cd mini_projeto_avaliativo_todos
```

### Instalar as dependências

```bash
flutter pub get
```

### Verificar o ambiente

```bash
flutter doctor
```

### Executar

Com um dispositivo ou emulador disponível:

```bash
flutter run
```

## Versionamento

O desenvolvimento utiliza um fluxo simplificado baseado em GitFlow.

Principais branches:

- `main`: versão estável do projeto;
- `develop`: integração das funcionalidades;
- `feature/app-infrastructure`: infraestrutura de comunicação com API;
- `feature/auth`: autenticação e sessão;
- `feature/todos`: consumo, persistência e gerenciamento das tarefas.

As feature branches foram integradas à `develop`, preservando o histórico das etapas de desenvolvimento.

## Melhorias futuras

Algumas possíveis evoluções do projeto:

- criação e exclusão de tarefas;
- sincronização bidirecional entre dados locais e API;
- suporte a funcionamento offline mais completo;
- testes unitários e testes de widgets;
- melhoria da interface e experiência do usuário;
- maior detalhamento das mensagens de erro;
- implementação de estratégias adicionais para sincronização e cache.

## Autor

Eriberto Torres de Oliveira

Projeto desenvolvido como atividade avaliativa do curso de Desenvolvimento Mobile.
