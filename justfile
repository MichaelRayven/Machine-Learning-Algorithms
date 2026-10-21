# Экспорт локального каталога .bin в PATH и каталогов кэша для безопасной работы в песочнице
export PATH := invocation_directory() + "/.bin:" + env_var('PATH')
export MPLCONFIGDIR := env_var_or_default('MPLCONFIGDIR', '/tmp/matplotlib')
export IPYTHONDIR := env_var_or_default('IPYTHONDIR', '/tmp/ipython')
export JUPYTER_CONFIG_DIR := env_var_or_default('JUPYTER_CONFIG_DIR', '/tmp/jupyter')

# Список доступных общих команд
default:
    @just --list

# Инициализация виртуального окружения uv и установка хуков prek
setup:
    uv sync
    uv run python -c "import site, pathlib; [(pathlib.Path(p) / 'mpl_env.pth').write_text('import os; os.environ.setdefault(\"MPLCONFIGDIR\", \"/tmp/matplotlib\"); os.environ.setdefault(\"IPYTHONDIR\", \"/tmp/ipython\"); os.environ.setdefault(\"JUPYTER_CONFIG_DIR\", \"/tmp/jupyter\")\n') for p in site.getsitepackages() if pathlib.Path(p).is_dir()]"
    uv run prek install
    uv run prek install --hook-type commit-msg

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
    uv run prek run --all-files

# Делегирование команд в модуль 4-й лабораторной работы
[no-cd]
lab4 *args:
    just -f src/lab4/justfile {{args}}

# Делегирование команд в модуль 5-й лабораторной работы
[no-cd]
lab5 *args:
    just -f src/lab5/justfile {{args}}
