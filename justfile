# Список доступных общих команд
default:
    @just --list

# Инициализация виртуального окружения uv и установка хуков prek
setup:
    uv sync
    prek install
    prek install --hook-type commit-msg

# Проверка кода и блокнотов линтером ruff
lint:
    uv run ruff check .

# Автоматическое исправление замечаний ruff
lint-fix:
    uv run ruff check --fix .

# Форматирование кода и блокнотов через ruff format
format:
    uv run ruff format .

# Проверка форматирования без изменения файлов
format-check:
    uv run ruff format --check .

# Комплексная проверка качества (линтинг + форматирование)
check: lint format-check

# Прогон хуков prek по всем файлам
hooks:
    prek run --all-files

# Делегирование команд в модуль 4-й лабораторной работы
[no-cd]
lab4 *args:
    just -f src/lab4/justfile {{args}}
