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

# Запускает docker compose up --build -d --remove-orphans на основе приоритета файлов
dcu() {
    local compose_file=""
    local files=(
        "docker-compose.local.yml" "docker-compose.local.yaml"
        "docker-compose.debug.yml" "docker-compose.debug.yaml"
        "docker-compose.yml"       "docker-compose.yaml"
    )

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            compose_file="$file"
            break
        fi
    done

    if [[ -n "$compose_file" ]]; then
        echo "--> Найдено: $compose_file"

        local args=(-f "$compose_file")

        # Если пользователь НЕ передал свои аргументы ($# == 0),
        # автоматически докидываем профиль для запуска всех сервисов
        if [[ $# -eq 0 ]]; then
            args+=(--profile "*")
        fi

        # Выполняем один чистый запуск
        docker compose "${args[@]}" up --build -d --remove-orphans "$@"
    else
        echo "Ошибка: В текущей папке не найден ни один docker-compose файл." >&2
        return 1
    fi
}
