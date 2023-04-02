#!/bin/bash

# Colorized output
BOLD="\033[1m"
GREEN="\033[32m"
ORANGE="\033[38;5;208m"
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

printf "${ORANGE}${BOLD}Running 'chezmoi re-add'...${RESET}\n"
readd_output=$(chezmoi re-add 2>&1)
if [[ -z $readd_output ]]; then
  printf "${GREEN}Nothing to re-add. Checking the repository for any changes to commit...${RESET}\n"
else
  printf "${GREEN}Re-added files:${RESET}\n${readd_output}\n"
  ask_continue

  printf "${ORANGE}${BOLD}Running 'chezmoi apply'...${RESET}\n"
  chezmoi apply
  ask_continue
fi

printf "${ORANGE}${BOLD}Changing directory to chezmoi's git repository...${RESET}\n"
cd "$HOME/.local/share/chezmoi" || exit

printf "${ORANGE}${BOLD}Running 'git status'...${RESET}\n"
git_status_output=$(git status --porcelain)
if [[ -z $git_status_output ]]; then
  printf "${GREEN}Nothing to commit. Exiting...${RESET}\n"
  exit 0
else
  git status
  ask_continue
fi

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
