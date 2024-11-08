#!/bin/bash

tput reset
tput civis

INSTALLATION_PATH="$HOME/blockmesh"

show_orange() {
    echo -e "\e[33m$1\e[0m"
}

show_blue() {
    echo -e "\e[34m$1\e[0m"
}

show_green() {
    echo -e "\e[32m$1\e[0m"
}

show_red() {
    echo -e "\e[31m$1\e[0m"
}

exit_script() {
    show_red "Скрипт остановлен (Script stopped)"
        echo ""
        exit 0
}

incorrect_option () {
    echo ""
    show_red "Неверная опция. Пожалуйста, выберите из тех, что есть."
    echo ""
    show_red "Invalid option. Please choose from the available options."
    echo ""
}

process_notification() {
    local message="$1"
    show_orange "$message"
    sleep 1
}

run_commands() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo ""
        show_green "Успешно (Success)"
        echo ""
    else
        sleep 1
        echo ""
        show_red "Ошибка (Fail)"
        echo ""
    fi
}

run_commands_info() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo ""
        show_green "Успешно (Success)"
        echo ""
    else
        sleep 1
        echo ""
        show_blue "Не найден (Not Found)"
        echo ""
    fi
}

run_node_command() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        show_green "НОДА ЗАПУЩЕНА (NODE IS RUNNING)!"
        echo
    else
        show_red "НОДА НЕ ЗАПУЩЕНА (NODE ISN'T RUNNING)!"
        echo
    fi
}

stop_session() {
    local name="$1"

    process_notification "Закрываем screen сессию (Closing screen session)..."
    run_commands_info "screen -r $name -X quit"
}

start_session_and_run() {
    local name="$1"
    local privat_key="$2"

    process_notification "Создаем и запускаем  (Creating and starting)..."
    run_node_command "screen -dmS $name bash -c \"curl -o- https://console.icn.global/downloads/install/start.sh | bash -s -- -p $privat_key\""
}

show_orange "      ___        ______ .__   __. " && sleep 0.2
show_orange "     /   \      /      ||  \ |  | " && sleep 0.2
show_orange "    /  ^  \    |  ,----'|   \|  | " && sleep 0.2
show_orange "   /  /_\  \   |  |     |  .    | " && sleep 0.2
show_orange "  /  _____  \  |   ----.|  |\   | " && sleep 0.2
show_orange " /__/     \__\  \______||__| \__| " && sleep 0.2
echo
sleep 1

while true; do
    show_green "----- MAIN MENU -----"
    echo "1. Установка (Install)"
    echo "2. Логи (Logs)"
    echo "3. Запуск/Перезапуск/Остановка (Start/Restart/Stop)"
    echo "4. Выход (Exit)"
    echo ""
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            process_notification "Начинаем установку (Starting installation)..."
            echo

            # Update packages
            process_notification "Обновляем пакеты (Updating packages)..."
            run_commands "sudo apt update && sudo apt upgrade -y && sudo apt install -y screen"

            echo
            show_green "----- ЗАВЕРШЕНО. COMPLETED! ------"
            echo
            ;;
        2)
            # Logs
            process_notification "Подключаемся (Connecting)..."
            screen -r ICN
            ;;
        3)
            echo
            show_orange "Выберете (Choose)"
            echo
            echo "1. Запуск/Перезапуск (Start/Restart)"
            echo "2. Остановка (Stop)"
            echo
            read -p "Выберите опцию (Select option): " option
                case $option in
                    1)
                        # Start or Restart
                        read -p "Введите (Enter) private key: " PRIVATE_KEY

                        stop_session "ICN"

                        start_session_and_run "ICN" "$PRIVATE_KEY"
                        echo
                        ;;
                    2)
                        stop_session "ICN"
                        echo
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac
                ;;

        4)
            exit_script
            ;;
        *)
            incorrect_option
            ;;
    esac
done
