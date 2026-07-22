#!/usr/bin/env bash

bind dtg 'docker run -d   --name tg-ws-proxy   --restart=always   -p 1443:1443   -e TG_WS_PROXY_SECRET="2c43e37bf228f8d5fc78689759d670e2"   tg-ws-proxy:latest'
bind dpa 'docker ps -a --format "table {{.ID}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"'

# Останавливает и удаляет ВСЕ контейнеры
dgga() {
    local containers=$(docker ps -aq)
    
    if [ -z "$containers" ]; then
        echo "Контейнеров не обнаружено. Всё чисто!"
        return 0
    fi

    docker stop $containers && docker rm $containers && echo wp
}

# Останавливает и удаляет ОДИН контейнер по ID или имени
dggo() {
    if [ -z "$1" ]; then
        echo "Ошибка: Укажите ID или имя контейнера."
        echo "Пример: dggo ebc242df"
        return 1
    fi

    docker stop "$1" && docker rm "$1" && echo wp
}

# Запускает docker compose up --build -d на основе приоритета файлов в текущей папке
dcu() {
    local compose_file=""

    # Ищем файлы в порядке приоритета для локальной разработки
    if [ -f "docker-compose.local.yml" ]; then
        compose_file="docker-compose.local.yml"
    elif [ -f "docker-compose.debug.yml" ]; then
        compose_file="docker-compose.debug.yml"
    elif [ -f "docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    fi

    # Если нашли файл — запускаем, если нет — ругаемся
    if [ -n "$compose_file" ]; then
        echo "--> Найдено: $compose_file"
        docker compose -f "$compose_file" up --build -d
    else
        echo "Ошибка: В текущей папке не найден ни один docker-compose файл."
        return 1
    fi
}
