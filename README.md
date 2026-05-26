# README

Задание для стажировки Ruby инженера для Учи.ру. Сделано на основе стандартного API-приложения RoR, проходит встроенные автоматические тесты. Кроме API, указанных в openapi.yaml, реализованы автоматические тесты.
 

## Технологии
- Ruby 3.4.9, Rails 8.1 (API-only)
- PostgreSQL 16
- Docker (docker compose up)

## Быстрый старт

```
git clone <URL репозитория>
cd <папка проекта>
docker compose up
```
Сервер будет доступен на http://localhost:3000. 
При первом запуске автоматически создаётся база данных PostgreSQL с начальными данными для тестирования.

### Автоматическое тестирование
```
docker compose exec -e RAILS_ENV=test web rspec
```
Покрыты все эндпоинты: успешные сценарии, ошибки валидации, авторизации и несуществующие записи.

### Эндпоинты (с примерами запросов)
#### Создание студента
```
curl -X POST http://localhost:3000/api/v1/students \
  -H "Content-Type: application/json" \
  -d '{
    "student": {
      "first_name": "Тест",
      "last_name": "Тестов",
      "surname": "Тестович",
      "class_id": 1,
      "school_id": 1
    }
  }'
```
#### Удаление студента
```
curl -X DELETE http://localhost:3000/api/v1/students/1 \
  -H "Authorization: Bearer <токен>"
```
#### Список классов школы
```
curl http://localhost:3000/api/v1/schools/1/classes
```
#### Список учеников класса
```
curl http://localhost:3000/api/v1/schools/1/classes/1/students
```
P.S. Школа и класс с индексом 1 уже существуют в базе данных, все эти запросы (кроме удаления) работают сразу после развёртывания
