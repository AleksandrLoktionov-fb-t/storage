#!/usr/bin/env bash

# Восстановление зависимостей без кэша с автовыбором проекта/решения
dnrn() {
    if [ $# -gt 0 ]; then
        # Если вы вручную передали файл: dnrn MyProject.csproj
        dotnet restore --no-cache "$@"
    else
        # Ищем сначала .sln, если нет — то первый попавшийся .csproj
        local target
        target=$(find . -maxdepth 1 -name "*.sln" | head -n 1)
        [ -z "$target" ] && target=$(find . -maxdepth 1 -name "*.csproj" | head -n 1)

        if [ -n "$target" ]; then
            echo "--> Восстановление для: $target"
            dotnet restore --no-cache "$target"
        else
            # Если файлов нет, пусть упадет со стандартной ошибкой .NET
            dotnet restore --no-cache
        fi
    fi
}

# Ищет точное совпадение пакета NuGet и возвращает только последнюю версию
# Использование: dnps <ИмяПакеты> [-p|--prerelease]
dnps() {
    # Проверяем, передан ли первый аргумент
    if [ -z "$1" ]; then
        echo "Ошибка: Укажите точное имя пакета."
        echo "Использование:       dnps <ИмяПакеты> [-p|--prerelease]"
        echo "Пример (стабильная): dnps Microsoft.Extensions.Hosting"
        echo "Пример (пререлиз):   dnps OpenTelemetry.Instrumentation.Process -p"
        return 1
    fi

    local extra_flag=""
    
    # Если вторым аргументом передан флаг пререлиза
    if [ "$2" == "-p" ] || [ "$2" == "--prerelease" ]; then
        extra_flag="--prerelease"
    fi

    # Ищем пакет, парсим версии, сортируем и берем последнюю
    dotnet package search --exact-match $extra_flag "$1" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?' | sort -V | tail -n 1
}

