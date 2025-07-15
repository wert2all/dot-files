#!/usr/bin/env sh
#
# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

start_mail() {
    echo -e "${GREEN}󰸻 Starting Mail...${NC}"
    tmux new-session -s mail -d
    tmux send-keys -t mail:0 "mailspring --password-store=\"gnome-libsecret\" " C-m
}

start_dashboard() {
    echo -e "${BLUE}󰸻 Starting Home Dashboard...${NC}"
    PROJECT="dashboard"

    cd ~/work/angular-home-page || {
        echo "Error: Could not change directory to ~/work/angular-home-page/"
        exit 1
    }

    tmux new-session -s $PROJECT -d
    tmux send-keys -t $PROJECT:0 "pnpm install && pnpm start" C-m
    tmux new-window -t $PROJECT -d
}
start_obsidian() {
    echo -e "${GREEN}󰸻 Starting Obsidian...${NC}"
    cd ~/Documents/obsidian/ || {
        echo "Error: Could not change directory to ~/Documents/obsidian/"
        exit 1
    }
    tmux new-session -s obsidian -d
}

show_menu() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${BOLD}${WHITE}   󰀻    Application Launcher    󰀻   ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} ${YELLOW}1)${NC} ${GREEN}󰇮 Mail${NC}                          ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} ${YELLOW}2)${NC} ${BLUE}󰠮 Dashboard${NC}                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} ${YELLOW}4)${NC} ${GREEN}󰠮 Obsidian${NC}                      ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} ${YELLOW}5)${NC} ${RED}󰩈 Exit${NC}                          ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
    echo ""
}

# Unified function to handle all application choices
handle_choice() {
    local choice="$1"

    case "$choice" in
    1 | mail)
        start_mail
        return 0
        ;;
    2 | dashboard)
        start_dashboard
        return 0
        ;;
    4 | obsidian)
        start_obsidian
        return 0
        ;;
    5 | exit)
        echo -e "${YELLOW}󰈆 Goodbye!${NC}"
        exit 0
        ;;
    *)
        return 1
        ;;
    esac
}

interactive_menu() {
    while true; do
        show_menu
        printf "${BOLD}${WHITE}Please select an option (1-5): ${NC}"
        read -r choice

        if handle_choice "$choice"; then
            break
        else
            echo ""
            echo -e "${RED}󰀪 Invalid option. Please select 1-5.${NC}"
            echo ""
            sleep 1
        fi
    done
}

# Check if argument is provided
if [ $# -eq 0 ]; then
    # No arguments provided, show interactive menu
    interactive_menu
else
    # Argument provided, use unified handler
    if ! handle_choice "$1"; then
        echo "Usage: $0 {mail|previewly|timeline|obsidian}"
        echo "Or run without arguments for interactive menu."
        exit 1
    fi
fi

exit 0
