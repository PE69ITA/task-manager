# Task Manager

Кроссплатформенное мобильное приложение для управления задачами. Позволяет создавать, просматривать, редактировать, удалять задачи и отслеживать их статус.

## Технологический стек

### Mobile
- Flutter
- Dart
- BLoC (flutter_bloc)
- Dio

### Backend
- Node.js
- Express.js
- Prisma ORM

### Database
- PostgreSQL

### DevOps
- Docker
- Docker Compose

## Функциональность

- Просмотр списка задач.
- Создание новых задач.
- Редактирование задач.
- Удаление задач.
- Изменение статуса задачи.
- Фильтрация по статусу.
- Отображение количества задач в каждой категории.

### Статусы задач

| Статус | Описание |
|---|---|
| TODO | Ожидает выполнения |
| IN_PROGRESS | В процессе выполнения |
| DONE | Завершена |

## Структура проекта

```text
task-manager/
├── mobile/
│   └── lib/
│       ├── core/
│       │   └── network/
│       └── features/
│           └── tasks/
│               ├── bloc/
│               ├── data/
│               ├── models/
│               └── presentation/
│                   └── widgets/
│
├── server/
│   ├── prisma/
│   │   ├── migrations/
│   │   └── schema.prisma
│   ├── src/
│   │   ├── controllers/
│   │   ├── lib/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── app.js
│   │   └── server.js
│   ├── Dockerfile
│   └── .dockerignore
│
├── docker-compose.yml
└── README.md
```

## Запуск проекта

### 1. Необходимые инструменты

Перед запуском необходимо установить:

- Git
- Docker Desktop
- Flutter SDK
- Android Studio (для Android Emulator)

### 2. Клонирование репозитория

```bash
git clone https://github.com/PE69ITA/task-manager.git
cd task-manager
```

### 3. Запуск Backend и PostgreSQL

Из корневой директории проекта выполнить:

```bash
docker compose up --build
```

Docker автоматически:
1. Создаст контейнер PostgreSQL.
2. Создаст базу данных `task_manager`.
3. Соберёт Docker-образ backend.
4. Сгенерирует Prisma Client.
5. Применит миграции Prisma.
6. Запустит Express-сервер.

Backend будет доступен по адресу:

```text
http://localhost:3000
```

Проверка работы API:

```text
http://localhost:3000/
```

Получение списка задач:

```text
http://localhost:3000/api/tasks
```

### 4. Запуск мобильного приложения

Открыть второе окно терминала:

```bash
cd mobile
flutter pub get
flutter run
```

Приложение настроено для работы с Android Emulator.

Адрес Backend для Android Emulator:

```text
http://10.0.2.2:3000/api
```

### 5. Остановка Docker

Для остановки контейнеров:

```bash
docker compose down
```

Данные PostgreSQL сохраняются в Docker volume и не удаляются при обычной остановке контейнеров.

## API Endpoints

Базовый адрес:

```text
http://localhost:3000/api
```

| Метод | Endpoint | Описание |
|---|---|---|
| GET | `/tasks` | Получить все задачи |
| GET | `/tasks/:id` | Получить задачу по ID |
| POST | `/tasks` | Создать задачу |
| PUT | `/tasks/:id` | Обновить задачу |
| DELETE | `/tasks/:id` | Удалить задачу |

### Пример создания задачи

**POST** `/tasks`

```json
{
  "title": "Learn Flutter",
  "description": "Study Flutter and BLoC"
}
```

## Управление состоянием

В мобильном приложении используется BLoC для разделения бизнес-логики и пользовательского интерфейса.

Основные компоненты:
- Events - события пользователя.
- States - состояния приложения.
- Bloc - обработка событий и управление состоянием.
- Repository - взаимодействие с API.

Для HTTP-запросов используется Dio. Операции с сервером выполняются асинхронно.

## Автор

Elmar Uzakov

**Project:** Task Manager  
**Type:** Mobile Application Development