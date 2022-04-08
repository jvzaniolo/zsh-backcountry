#!/usr/bin/env zsh

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
bold=`tput bold`

export PATH="/usr/local/opt/openjdk@8/bin:$PATH"

export JAVA_HOME=${JAVA_HOME:-$(/usr/libexec/java_home -v 1.8.0_311)}
export ATGJRE=$JAVA_HOME/bin/java
export DYNAMO_HOME=/opt/atg/atg11.3.2/home
export JAVA_VM=$JAVA_HOME/bin/java
export JBOSS_HOME=/opt/jboss-eap-7.2
export WEB_ASSETS_PATH=${BCS_DIR:-$HOME/Developer}/bc-frontend
export BC_APACHE_HOME=${BCS_DIR:-$HOME/Developer}/atg-apache-configs
export ATG_HOME=/opt/atg/atg11.3.2

function _start-bcs() {
    BCS_DIR=${BCS_DIR:-$HOME/Developer}
    case $1 in
        apache)
            echo "${green}==>${reset} ${bold}Starting ${green}apache${reset}"
            cd $BCS_DIR/atg-apache-configs
            HOSTIP=${HOSTIP:-""} make start
            cd $HOME
            ;;
        apache-logs)
            echo "${green}==>${reset} ${bold}Starting ${green}apache${reset} with logs"
            cd $BCS_DIR/atg-apache-configs
            HOSTIP=${HOSTIP:-""} make start-logs
            cd $HOME
            ;;
        atg)
            echo "${green}==>${reset} ${bold}Starting ${green}atg${reset}"
            cd $BCS_DIR/atg-backcountry-ca
            make start
            cd $HOME
            ;;
        kraken)
            echo "${green}==>${reset} ${bold}Starting ${green}kraken${reset} (bc-frontend)"
            cd $BCS_DIR/bc-frontend
            nvm use
            echo "${green}==>${reset} ${bold}Navigate to public folder and run 'npm run watch:<site>' to compile the css"
            node server.js
            ;;
        kraken-css)
            echo "${green}==>${reset} ${bold}Starting ${green}kraken-css${reset} (bc-frontend/public)"
            cd $BCS_DIR/bc-frontend/public
            nvm use
            npm run watch:$2
            ;;
        next)
            echo "${green}==>${reset} ${bold}Starting ${green}next${reset} (bc-frontend-web)"
            cd $BCS_DIR/bc-frontend-web
            nvm use
            yarn dev:$2
            ;;
        all)
            bcs start apache
            bcs start atg
            bcs start kraken
            ;;
        help)
            echo "Usage: bcs start {apache|apache-logs|atg|kraken|kraken-css|next|all|help}"
            ;;
        *)
            echo "Assuming all is passed..."
            bcs start all
            ;;
    esac
}

function _stop-bcs() {
    BCS_DIR=${BCS_DIR:-$HOME/Developer}
    case $1 in
        apache)
            echo "${green}==>${reset} ${bold}Stopping ${green}apache${reset}"
            cd $BCS_DIR/atg-apache-configs
            HOSTIP=${HOSTIP:-""} make stop
            cd $HOME
            ;;
        atg)
            echo "${green}==>${reset} ${bold}Stopping ${green}atg${reset}"
            cd $BCS_DIR/atg-backcountry-ca
            cd dependencies/oracle
            vagrant halt
            cd ../../
            make stop
            cd $HOME
            ;;
        all)
            bcs stop apache
            bcs stop atg
            ;;
        help)
            echo "Usage: bcs stop {apache|atg|all|help}"
            ;;
        *)
            echo "Assuming all is passed..."
            bcs stop all
            ;;
    esac
}

function _update-bcs() {
    BCS_DIR=${BCS_DIR:-$HOME/Developer}
    case $1 in
        apache)
            echo "${green}==>${reset} ${bold}Updating ${green}apache${reset}"
            cd $BCS_DIR/atg-apache-configs
            git pull
            cd $HOME
            ;;
        atg)
            echo "${green}==>${reset} ${bold}Updating ${green}atg${reset}"
            cd $BCS_DIR/atg-backcountry-ca
            git pull
            make build
            cd $HOME
            ;;
        kraken)
            echo "${green}==>${reset} ${bold}Updating ${green}kraken${reset} (bc-frontend)"
            cd $BCS_DIR/bc-frontend
            git pull
            cd $HOME
            ;;
        next)
            echo "${green}==>${reset} ${bold}Updating ${green}next${reset} (bc-frontend-web)"
            cd $BCS_DIR/bc-frontend-web
            git pull
            cd $HOME
            ;;
        all)
            bcs update apache
            bcs update atg
            bcs update kraken
            bcs update next
            ;;
        help)
            echo "Usage: bcs update {apache|atg|kraken|next|all|help}"
            ;;
        *)
            echo "Assuming all is passed..."
            bcs update all
            ;;
    esac
}

function bcs () {
    if [[ ! -v BCS_DIR ]]; then
        echo "${yellow}==>${reset} BCS_DIR is not defined. Using '\$HOME/Developer' instead."
    fi
    if ! curl -Is http://integration.backcountry.com | grep 301 &> /dev/null; then
        echo "${red}==>${reset} ${bold}Please connect to the Backcountry VPN"
    elif ! command -v nvm &> /dev/null; then
        echo "${red}==>${reset} ${bold}Please install ${green}nvm"
    else
        case $1 in
            start)
                _start-bcs $2 $3
                ;;
            stop)
                _stop-bcs $2
                ;;
            update)
                _update-bcs $2
                ;;
            *)
                echo "Usage: bcs {start|stop|update} {apache|apache-logs|atg|kraken|all|help}"
                echo "Usage: bcs start {kraken-css|next} {bcs|cc|moto|sac}"
                ;;
        esac
    fi
}