#!/bin/sh

# Colorized output
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# Function to prompt the user
prompt_continue() {
  while true; do
    printf '%sDo you want to continue? [y/n]: %s' "$YELLOW" "$RESET"
    read -r choice
    case $choice in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) printf '%sPlease answer y(es) or n(o).%s\n' "$YELLOW" "$RESET";;
    esac
  done
}

printf '%sRunning '\''chezmoi re-add'\''...%s\n' "$GREEN" "$RESET"
chezmoi re-add
if prompt_continue; then
  printf '%sRunning '\''chezmoi apply'\''...%s\n' "$GREEN" "$RESET"
  chezmoi apply
  if prompt_continue; then
    printf '%sChanging directory to chezmoi'\''s git repository...%s\n' "$GREEN" "$RESET"
    cd "$HOME/.local/share/chezmoi" || exit 1

    printf '%sRunning '\''git status'\''...%s\n' "$GREEN" "$RESET"
    git status
    if prompt_continue; then
      printf '%sEnter the commit message: %s' "$YELLOW" "$RESET"
      read -r commit_message

      printf '%sRunning '\''git commit'\''...%s\n' "$GREEN" "$RESET"
      git commit -m "$commit_message"
      if prompt_continue; then
        printf '%sDo you want to push the commit? [y/n]: %s' "$YELLOW" "$RESET"
        read -r push_choice
        case $push_choice in
          [Yy]* )
            printf '%sRunning '\''git push'\''...%s\n' "$GREEN" "$RESET"
            git push origin;;
          [Nn]* )
            printf '%sCommit has been updated locally. You can push it later.%s\n' "$GREEN" "$RESET";;
          * ) printf '%sInvalid choice. Commit has been updated locally. You can push it later.%s\n' "$YELLOW" "$RESET";;
        esac
      fi
    fi
  fi
else
  printf '%sAborted.%s\n' "$GREEN" "$RESET"
fi
