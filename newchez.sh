#!/bin/sh

# Colorized output
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# Function to prompt the user
prompt_continue() {
  while true; do
    printf "${YELLOW}Do you want to continue? [y/n]: ${RESET}"
    read -r choice
    case $choice in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) printf "${YELLOW}Please answer y(es) or n(o).${RESET}\n";;
    esac
  done
}

printf "${GREEN}Running 'chezmoi re-add'...${RESET}\n"
chezmoi re-add
if prompt_continue; then
  printf "${GREEN}Running 'chezmoi apply'...${RESET}\n"
  chezmoi apply
  if prompt_continue; then
    printf "${GREEN}Changing directory to chezmoi's git repository...${RESET}\n"
    cd "$HOME/.local/share/chezmoi" || exit 1

    printf "${GREEN}Running 'git status'...${RESET}\n"
    git status
    if prompt_continue; then
      printf "${YELLOW}Enter the commit message: ${RESET}"
      read -r commit_message

      printf "${GREEN}Running 'git commit'...${RESET}\n"
      git commit -m "$commit_message"
      if prompt_continue; then
        printf "${YELLOW}Do you want to push the commit? [y/n]: ${RESET}"
        read -r push_choice
        case $push_choice in
          [Yy]* )
            printf "${GREEN}Running 'git push'...${RESET}\n"
            git push origin;;
          [Nn]* )
            printf "${GREEN}Commit has been updated locally. You can push it later.${RESET}\n";;
          * ) printf "${YELLOW}Invalid choice. Commit has been updated locally. You can push it later.${RESET}\n";;
        esac
      fi
    fi
  fi
else
  printf "${GREEN}Aborted.${RESET}\n"
fi
