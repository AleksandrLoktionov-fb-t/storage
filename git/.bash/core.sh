#!/usr/bin/env bash

# Функция для безопасного создания алиасов
bind() {
    unalias "$1" &> /dev/null
    alias "$1"="$2"
}
