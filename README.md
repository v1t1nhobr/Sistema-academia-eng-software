## 🎓 Informações Acadêmicas

| Informação | Descrição |
|---|---|
| **Instituição** | UniRuy Wyden |
| **Curso** | Análise e Desenvolvimento de Sistemas |
| **Disciplina** | Engenharia de Software |
| **Professor** | Heleno Cardoso |
| **Aluno** | João Vitor Ferreira da Silva |
| **Ano** | 2026 |
| **Projeto** | Sistema de Gerenciamento de Academia |

---
# 🏋️ ATLAS — Sistema de Gerenciamento de Academia
## 🎯 Objetivos do Projeto

O projeto **Atlas — Sistema de Gerenciamento de Academia** foi desenvolvido com o objetivo de propor uma solução para organizar e gerenciar as principais atividades administrativas de uma academia de ginástica.

### Objetivo Geral

Desenvolver a documentação, a modelagem de dados e a prototipação de um sistema de gerenciamento de academia, aplicando os conceitos estudados na disciplina de Engenharia de Software.

### Objetivos Específicos

- Centralizar o cadastro de alunos e instrutores.
- Organizar as atividades oferecidas pela academia.
- Gerenciar turmas, horários e períodos.
- Controlar matrículas e capacidade das turmas.
- Definir alunos monitores.
- Registrar e acompanhar ausências.
- Garantir a integridade dos dados por meio de regras de negócio.
- Desenvolver interfaces interativas para demonstrar as funcionalidades previstas.

---

## 🔗 Links e Arquivos do Projeto

### 🎨 Protótipo Interativo — Figma

O protótipo **Atlas — Gestão de Academias** contém sete telas que demonstram a navegação e as funcionalidades previstas para o sistema.

**[▶️ Acessar Protótipo Interativo no Figma](https://www.figma.com/proto/wfh6p1Q55WPm7nEKYABlWx/Atlas---Gest%C3%A3o-de-Academias?node-id=2-2&p=f&t=geJqIgIHocxzwyzv-1&scaling=min-zoom&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=2%3A2)**

### 📄 Documentação Acadêmica

A documentação reúne as etapas 2.1 a 2.10 da atividade de Engenharia de Software.

**[📥 Acessar Documentação Word](./Documentacao_Engenharia_Software_Joao_Vitor_Figma_Atualizado.docx)**

### 🗄️ Script do Banco de Dados

Arquivo SQL contendo a estrutura do banco PostgreSQL, relacionamentos, funções e triggers.

**[💻 Visualizar Código SQL](./01_criacao_banco.sql)**

---

## 📌 Sobre o Sistema

O Atlas é um projeto acadêmico voltado à organização das informações de uma academia.

A solução proposta permite estruturar o gerenciamento de alunos, instrutores, atividades, turmas, matrículas e ausências.

O trabalho contempla o levantamento de requisitos, a modelagem do banco de dados, a implementação de regras de negócio no PostgreSQL e a criação de protótipos interativos.

> **Nota:** O projeto apresenta documentação, banco de dados e prototipação. Não se trata de uma aplicação completa implantada.

---

## ⚙️ Funcionalidades Previstas

| Funcionalidade | Descrição |
|---|---|
| Cadastro de alunos | Registro e consulta dos dados dos alunos |
| Cadastro de instrutores | Gerenciamento de instrutores e telefones |
| Gestão de atividades | Cadastro das atividades oferecidas |
| Gestão de turmas | Controle de horários, duração e períodos |
| Matrículas | Associação de alunos às turmas |
| Monitores | Definição de aluno monitor por turma |
| Controle de capacidade | Limitação de matrículas por turma |
| Registro de ausências | Controle das faltas dos alunos |
| Consultas e relatórios | Visualização das informações cadastradas |

---

## 🛠️ Tecnologias e Ferramentas

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Figma](https://img.shields.io/badge/Figma-F24E1E?logo=figma&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Database-blue)

| Tecnologia | Finalidade |
|---|---|
| PostgreSQL | Banco de dados relacional |
| SQL | Criação de tabelas e relacionamentos |
| PL/pgSQL | Implementação das regras de negócio |
| DBeaver | Administração e testes do banco |
| Figma | Desenvolvimento dos protótipos |
| GitHub | Armazenamento e compartilhamento dos arquivos |

---

## 🗄️ Estrutura do Banco de Dados

O banco foi desenvolvido em PostgreSQL, contendo sete tabelas relacionadas.

### Tabelas Criadas

1. `alunos`
2. `instrutores`
3. `telefones_instrutor`
4. `atividades`
5. `turmas`
6. `matriculas_turma`
7. `ausencias`

### Regras de Negócio

As regras de negócio são implementadas por meio de funções e triggers no PostgreSQL.

- **RN01:** O monitor deve estar matriculado na própria turma.
- **RN02:** A quantidade de alunos matriculados não pode ultrapassar a capacidade da turma.
- **RN03:** As ausências devem ser registradas dentro do período da turma.
- **RN04:** Alterações no período não podem invalidar ausências existentes.
- **RN05:** A capacidade da turma não pode ser reduzida para menos do que o número de alunos matriculados.

---

## 🧪 Testes e Validações

Foram realizados cinco testes práticos no PostgreSQL, utilizando o DBeaver.

| Teste | Resultado |
|---|---|
| Bloqueio de matrículas acima da capacidade | ✅ Aprovado |
| Validação da matrícula do monitor | ✅ Aprovado |
| Bloqueio de ausências fora do período | ✅ Aprovado |
| Validação de alteração do período | ✅ Aprovado |
| Bloqueio de redução inválida da capacidade | ✅ Aprovado |

**Resultado: 5 de 5 testes aprovados.**

Os testes utilizaram dados fictícios e transações revertidas com `ROLLBACK`.

---

## 📚 Etapas da Documentação

| Etapa | Descrição |
|---|---|
| **2.1** | Levantamento de requisitos |
| **2.2** | Requisitos funcionais |
| **2.3** | Regras de negócio |
| **2.4** | Requisitos não funcionais |
| **2.5** | Diagramas de Fluxo de Dados (DFD) |
| **2.6** | Modelo lógico |
| **2.7** | Modelo físico (DER) |
| **2.8** | Script SQL (DDL) |
| **2.9** | Telas de interface |
| **2.10** | Protótipos no Figma |

---

## 🚀 Como Executar o Banco de Dados

### Pré-requisitos

- PostgreSQL instalado.
- DBeaver ou outro cliente SQL compatível.

### Instruções

1. Criar um banco de dados chamado `academia_eng_software`.
2. Abrir o DBeaver e conectar-se ao banco criado.
3. Abrir o arquivo `01_criacao_banco.sql`.
4. Executar o script SQL completo.
5. Verificar a criação das tabelas, funções e triggers.

> **Importante:** Execute o script em um banco novo para evitar conflitos com tabelas já existentes.

---

## 📁 Arquivos do Repositório

```text
sistema-academia-eng-software/
│
├── README.md
│
├── 01_criacao_banco.sql
│
└── Documentacao_Engenharia_Software_Joao_Vitor_Figma_Atualizado.docx
```

---

## 📖 Considerações Finais

O desenvolvimento do projeto Atlas permitiu aplicar conhecimentos de Engenharia de Software, incluindo levantamento de requisitos, análise de regras de negócio, modelagem de banco de dados e prototipação de interfaces.

A implementação das regras de negócio no PostgreSQL e os testes realizados demonstraram o funcionamento das validações previstas.

O projeto integra conhecimentos teóricos e práticos, contribuindo para o desenvolvimento de competências em análise, modelagem e documentação de sistemas.

---

**Projeto acadêmico desenvolvido para a disciplina de Engenharia de Software — UniRuy Wyden, 2026.**
