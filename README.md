## Exam App

**Descrição**

Este projeto é um aplicativo Flutter desenvolvido como teste técnico para a VM Tecnologia. O objetivo do app é gerar uma lista de números aleatórios, permitir que o usuário reordene os itens manualmente, valide se a lista está em ordem crescente e possibilitar o reinício do processo a qualquer momento.

---

## Índice

* [Funcionalidades](#funcionalidades)
* [Tecnologias e Arquitetura](#tecnologias-e-arquitetura)
* [Pré-requisitos](#pré-requisitos)
* [Instalação](#instalação)
* [Como Executar](#como-executar)
* [Testes](#testes)
* [Estrutura do Projeto](#estrutura-do-projeto)
* [Decisões de Design](#decisões-de-design)
* [Contribuição](#contribuição)

---

## Funcionalidades

* Solicitar ao usuário a quantidade de números aleatórios desejados.
* Gerar lista de números sem repetições usando a interface `ExamApi`.
* Exibir os números em tela dentro de um `ReorderableListView`.
* Permitir reordenação manual dos itens.
* Validar ordem crescente a partir de `ExamApi.checkOrder`.
* Exibir feedback visual (SnackBar) informando se a ordem está correta ou não.
* Botão para reiniciar o processo, limpando lista e campo de entrada.

---

## Tecnologias e Arquitetura

* **Flutter & Dart**: framework principal para desenvolvimento mobile multiplataforma.
* **Provider**: gerenciamento de estado simples e suficiente para o `ExamProvider`.
* **Material Design**: componentes nativos e estilo definido em conformidade com as diretrizes do Google.
* **Arquitetura MVVM**:

  * **Model**: definição da API `ExamApi` e entidade de números.
  * **ViewModel**: `ExamProvider` encapsula lógica de negócio e notifica a UI.
  * **View**: páginas e widgets responsivos (HomePage, InputField, NumberTile, ActionButtons).

A escolha do Provider se deu pela simplicidade de configuração e baixo overhead, ideal para projetos de porte pequeno a médio.

---

## Pré-requisitos

* Flutter 3.x ou superior
* Android Studio ou VS Code
* Git

---

## Instalação

Chave SSH: git@github.com:FelipeDominguess/exam_app.git

1. Clone este repositório:

   ```bash
   git clone git@github.com:FelipeDominguess/exam_app.git
   cd exam_app
   ```
2. Instale as dependências:

   ```bash
   flutter pub get
   ```

---

## Como Executar

* Emulador ou dispositivo físico conectado:

  ```bash
  flutter run
  ```

---

## Testes

* **Testes Unitários**

  ```bash
  flutter test test/unit
  ```

* **Testes de Widget**

  ```bash
  flutter test test/widget
  ```

Todos os testes devem passar sem erros.

---

## Estrutura do Projeto

```text
lib/
├─ services/        # Implementação da API (ExamApi)
├─ providers/       # Lógica de negócio (ExamProvider)
├─ widgets/         # Componentes reutilizáveis (InputField, NumberTile, ActionButtons)
├─ pages/           # Telas (HomePage)
test/
├─ unit/            # Testes unitários de ExamApi e ExamProvider
├─ widget/          # Testes de interface da HomePage
```

---

## Decisões de Design

* **ReorderableListView** facilita a lógica de drag-and-drop nativa do Flutter.
* **SnackBar** foi escolhido para feedback rápido e não intrusivo.
* **FilledButton** e ícones foram adotados para clareza nas ações principais (Gerar, Validar, Reset).
* **Provider** escalabilidade boa para gerenciamento de estado simples.

---
