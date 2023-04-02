#!/bin/bash

# Colorized output
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

ask_continue() {
  while true; do
    printf "${YELLOW}Do you want to continue? [y/n]: ${RESET}"
    read -r response
    case $response in
      [Yy]* ) break;;
      [Nn]* ) exit 0;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

printf "${GREEN}${BOLD}Running 'chezmoi re-add'...${RESET}\n"
chezmoi re-add
ask_continue

printf "${GREEN}${BOLD}Running 'chezmoi apply'...${RESET}\n"
chezmoi apply
ask_continue

printf "${GREEN}${BOLD}Changing directory to chezmoi's git repository...${RESET}\n"
cd "$HOME/.local/share/chezmoi" || exit

printf "${GREEN}${BOLD}Running 'git status'...${RESET}\n"
git status
ask_continue

printf "${YELLOW}Please enter a commit message: ${RESET}"
read -r commit_message
git commit -m "$commit_message"
ask_continue

printf "${YELLOW}Do you want to push the commit? [y/n]: ${RESET}"
read -r push_response
if [[ $push_response =~ ^[Yy] ]]; then
  git push origin main
else
  printf "${GREEN}${BOLD}You are updated locally. You can push your commits when you want.${RESET}\n"
fi
