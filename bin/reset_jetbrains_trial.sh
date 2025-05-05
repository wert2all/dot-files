#!/bin/bash

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;92m'
YELLOW='\033[0;33m'
BLUE='\033[0;94m'
PURPLE='\033[0;95m'
CYAN='\033[1;96m'
WHITE='\033[0;97m'
NC='\033[0m' # No Color

#~/.config/JetBrains/
config_path=~/.config/JetBrains/

# Version variables for JetBrains products
intellij_idea_version="IntelliJIdea"
webstorm_version="WebStorm"
datagrip_version="DataGrip"
phpstorm_version="PhpStorm"
clion_version="CLion"
pycharm_version="PyCharm"
goland_version="GoLand"
rubymine_version="RubyMine"

# Function to clear the screen
clear_screen() {
  clear
}

# Function to display the menu
show_menu() {
  clear_screen
  echo -e "${CYAN}---- RESET TRIAL IDE 1.0 ----${NC}"
  echo -e "[${BLUE}0${NC}] ${PURPLE}All IDE${NC}"
  echo -e "[${BLUE}1${NC}] ${WHITE}$intellij_idea_version${NC}"
  echo -e "[${BLUE}2${NC}] ${WHITE}$webstorm_version${NC}"
  echo -e "[${BLUE}3${NC}] ${WHITE}$datagrip_version${NC}"
  echo -e "[${BLUE}4${NC}] ${WHITE}$phpstorm_version${NC}"
  echo -e "[${BLUE}5${NC}] ${WHITE}$clion_version${NC}"
  echo -e "[${BLUE}6${NC}] ${WHITE}$pycharm_version${NC}"
  echo -e "[${BLUE}7${NC}] ${WHITE}$goland_version${NC}"
  echo -e "[${BLUE}8${NC}] ${WHITE}$rubymine_version${NC}"
  echo -e "[${BLUE}q${NC}] ${GREEN}Quit${NC}"
  echo -e "${CYAN}-------------------------${NC}"
}

# Function to reset trial period for all products
reset_all() {
  for product in $intellij_idea_version $webstorm_version $datagrip_version $phpstorm_version $clion_version $pycharm_version $goland_version $rubymine_version; do
    reset_application $product
  done
}

# Function to reset trial period for a specific product
reset_application() {
  local product_name=$(basename $config_path"$1"*)
  local name_path=$config_path"$product_name"

  #echo -e "${GREEN}config located: $name_path"

  if [ -d $name_path ]; then
    echo -e "${BLUE}[+] Resetting trial period for ${CYAN}$product_name${NC}"

    # Remove Evaluation Key
    echo -e "${BLUE}[+] Removing Evaluation Key..."
    rm -rf ~/.config/JetBrains/$product_name*/eval &>/dev/null
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}[+] Evaluation Key removed successfully${NC}"
    else
      echo -e "${RED}[!] Failed to remove Evaluation Key${NC}"
    fi

    # Remove evlsprt properties from options.xml
    echo -e "${BLUE}[+] Removing all evlsprt properties in options.xml..."
    sed -i 's/evlsprt//' ~/.config/JetBrains/$product_name*/options/other.xml &>/dev/null
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}[+] evlsprt properties removed successfully.${NC}"
    else
      echo -e "${RED}[!] Failed to remove evlsprt properties.${NC}"
    fi

    # Remove userPrefs files
    echo -e "${BLUE}[+] Removing userPrefs files..."
    rm -rf ~/.java/.userPrefs &>/dev/null
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}[+] userPrefs files removed successfully.${NC}"
    else
      echo -e "${RED}[!] Failed to remove userPrefs files.${NC}"
    fi

  else
    echo -e "${YELLOW}[warn] Directory for ${WHITE}$product_name${YELLOW} does not exist.${NC}"
  fi
}

# Function to validate user selection
validate() {
  case $application in
  0)
    reset_all
    ;;
  1 | 2 | 3 | 4 | 5 | 6 | 7 | 8)
    local application_name=""
    case $application in
    0)
      application_name="All IDE"
      ;;
    1)
      application_name=$intellij_idea_version
      ;;
    2)
      application_name=$webstorm_version
      ;;
    3)
      application_name=$datagrip_version
      ;;
    4)
      application_name=$phpstorm_version
      ;;
    5)
      application_name=$clion_version
      ;;
    6)
      application_name=$pycharm_version
      ;;
    7)
      application_name=$goland_version
      ;;
    8)
      application_name=$rubymine_version
      ;;
    esac
    reset_application $application_name
    ;;
  q | Q)
    echo -e "${GREEN}========= Exit =========="
    exit 0
    ;;
  *)
    echo -e "${RED}[!] Invalid selection${NC}"
    ;;
  esac
}

# Display the menu and read user selection
show_menu
echo -e -n "${WHITE}select option:${NC}"
read application
echo -e "${CYAN}-------------------------${NC}"

# Validate user selection
validate
