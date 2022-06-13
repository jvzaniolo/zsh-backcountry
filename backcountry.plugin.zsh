#!/usr/bin/env zsh

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)
bold=$(tput bold)

export PATH="/usr/local/opt/openjdk@8/bin:$PATH"

[[ -f /usr/libexec/java_home ]] && export JAVA_HOME=${JAVA_HOME:-$(/usr/libexec/java_home -v 1.8.0_311)}
export ATGJRE=$JAVA_HOME/bin/java
export DYNAMO_HOME=/opt/atg/atg11.3.2/home
export JAVA_VM=$JAVA_HOME/bin/java
export JBOSS_HOME=/opt/jboss-eap-7.2
export WEB_ASSETS_PATH=${BCS_DIR:-$HOME/Developer}/bc-frontend
export BC_APACHE_HOME=${BCS_DIR:-$HOME/Developer}/atg-apache-configs
export ATG_HOME=/opt/atg/atg11.3.2

function _check-vpn() {
    if ! curl -Is http://integration.backcountry.com | grep 301 &>/dev/null; then
        echo "${red}==>${reset} ${bold}Please connect the GlobalProtect VPN"
        return 1
    fi

    return 0
}

function _check-node-manager() {
    if ! command -v nvm &>/dev/null || ! command -v fnm &>/dev/null; then
        echo "${red}==>${reset} ${bold}Please install ${green}nvm ${reset}or ${green}fnm"
        return 1
    fi

    return 0
}

function _start-bcs() {
    BCS_DIR=${BCS_DIR:-$HOME/Developer}

    if ! _check-vpn; then
        return
    fi

    case $1 in
    apache)
        echo "${green}==>${reset} ${bold}Starting ${green}apache${reset}"
        if command -v colima &>/dev/null; then
            if colima ls | grep Stopped &>/dev/null; then
                colima start
            fi
        fi
        cd $BCS_DIR/atg-apache-configs
        HOSTIP=${HOSTIP:-""} make start
        cd $HOME
        ;;
    apache-logs)
        echo "${green}==>${reset} ${bold}Starting ${green}apache${reset} with logs"
        if command -v colima &>/dev/null; then
            if colima ls | grep Stopped &>/dev/null; then
                colima start
            fi
        fi
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
        if ! _check-node-manager; then
            return
        fi
        cd $BCS_DIR/bc-frontend
        echo "${green}==>${reset} ${bold}Navigate to public folder and run 'npm run watch:<site>' to compile the css"
        node server.js
        ;;
    kraken-css)
        echo "${green}==>${reset} ${bold}Starting ${green}kraken-css${reset} (bc-frontend/public)"
        echo "==> npm run watch:$2"
        if ! _check-node-manager; then
            return
        fi
        cd $BCS_DIR/bc-frontend/public
        npm run watch:$2
        ;;
    next)
        echo "${green}==>${reset} ${bold}Starting ${green}next${reset} (bc-frontend-web)"
        if ! _check-node-manager; then
            return
        fi
        echo "==> yarn dev:$2"
        cd $BCS_DIR/bc-frontend-web
        yarn dev:$2
        ;;
    all)
        if ! _check-node-manager; then
            return
        fi
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
        if command -v colima &>/dev/null; then
            if colima ls | grep Running &>/dev/null; then
                colima stop
            fi
        fi
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
        # Remove this once bc-frontend is migrated to GitHub
        if git remote get-url origin | grep bcinfra &>/dev/null; then
            if ! _check-vpn; then
                return
            fi
        fi
        #
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
        bcs update next
        bcs update apache
        bcs update atg
        bcs update kraken
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

function _code-bcs() {
    BCS_DIR=${BCS_DIR:-$HOME/Developer}

    if ! command -v code &>/dev/null; then
        echo "${red}==>${reset} ${bold}code${reset} command not found."
        return
    fi

    case $1 in
    apache)
        echo "${green}==>${reset} ${bold}Opening ${green}apache${reset} in vscode"
        code $BCS_DIR/atg-apache-configs
        cd $HOME
        ;;
    atg)
        echo "${green}==>${reset} ${bold}Opening ${green}atg${reset} in vscode"
        code $BCS_DIR/atg-backcountry-ca
        cd $HOME
        ;;
    kraken)
        echo "${green}==>${reset} ${bold}Opening ${green}kraken${reset} (bc-frontend) in vscode"
        code $BCS_DIR/bc-frontend
        cd $HOME
        ;;
    next)
        echo "${green}==>${reset} ${bold}Opening ${green}next${reset} (bc-frontend-web) in vscode"
        code $BCS_DIR/bc-frontend-web
        cd $HOME
        ;;
    help)
        echo "Usage: bcs code {apache|atg|kraken|next|help}"
        ;;
    *)
        bcs code help
        ;;
    esac
}

function bcs() {
    if [[ ! -v BCS_DIR ]]; then
        echo "${yellow}==>${reset} BCS_DIR is not defined. Using '\$HOME/Developer' instead."
    fi

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
    code)
        _code-bcs $2
        ;;
    *)
        echo "Usage: bcs {start|stop|update|code} {apache|apache-logs|atg|kraken|all|help}"
        echo "Usage: bcs start {kraken-css|next} {bcs|cc|moto|sac}"
        ;;
    esac
}
