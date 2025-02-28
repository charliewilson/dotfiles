# SSH tunnel mapping port 80 to local 1234
# Useful for accessing a remote localhost-only phpmyadmin
# tunnel example.com
tunnel() {
  ssh -L 1234:$1:80 root@$1
}

# open project folder in neovim
#
# proj Example - opens ~/Projects/Example in neovim
proj() {
  cd ~/Projects/$1
  nvim .
}

# Git pull in todo directory
#
# todo_pull
todo_pull() {
  TODO_DIR="/home/${SUDO_USER:-$USER}/todo"
  CURRENT_DIR=$(pwd)

  cd $TODO_DIR
  git pull
  echo 'Pulled Successfully.'
  cd $CURRENT_DIR
}

# Git pull/push all in todo directory
#
# todo_pull
todo_sync() {
  TODO_DIR="/home/${SUDO_USER:-$USER}/todo"
  CURRENT_DIR=$(pwd)

  cd $TODO_DIR
  git pull
  git add .
  git commit -m "Sync: $(date '+%Y-%m-%d %H:%M:%S')"
  git push
  echo 'Synced Successfully.'
  cd $CURRENT_DIR
}

# Git pull, open neovim to todo inbox, then autocommit/sync on exit
#
# todo_edit
todo_edit() {
  TODO_DIR="/home/${SUDO_USER:-$USER}/todo"
  CURRENT_DIR=$(pwd)

  cd $TODO_DIR
  git pull

  nvim "inbox.org"

  git pull
  git add .
  git commit -m "Sync: $(date '+%Y-%m-%d %H:%M:%S')"
  git push
  echo 'Synced Successfully.'
  cd $CURRENT_DIR
}

# Adds a task to journal.esg.org
# Generated with Claude - needed some hand holding but infinitely faster than if I wrote myself!
#
# journal "Did this task"
journal() {

  # Check if a task description is provided
  if [ $# -eq 0 ]; then
    echo "Usage: $0 'task description'"
    exit 1
  fi

  # git pull
  todo_pull

  # The task description from arguments
  TASK="$*"

  # Path to the org file
  ORG_FILE="/home/charlie/todo/esg/journal.esg.org"

  # Get today's date in the format used in your org file
  TODAY=$(date +"%Y-%m-%d")

  # Get current timestamp for the task
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M")

  # Check if the file exists
  if [ ! -f "$ORG_FILE" ]; then
    echo "Error: $ORG_FILE does not exist"
    exit 1
  fi

  # Check if today's header already exists
  if grep -q "^\* $TODAY" "$ORG_FILE"; then
    # Today's header exists
    # Find the position where to insert the new task

    # Find the next header after today's header (if any)
    TODAY_LINE=$(grep -n "^\* $TODAY" "$ORG_FILE" | cut -d: -f1)
    NEXT_HEADER=$(tail -n +$((TODAY_LINE + 1)) "$ORG_FILE" | grep -n "^\* " | head -1)

    if [ -n "$NEXT_HEADER" ]; then
      # There is a next header
      NEXT_HEADER_OFFSET=$(echo "$NEXT_HEADER" | cut -d: -f1)
      NEXT_HEADER_LINE=$((TODAY_LINE + NEXT_HEADER_OFFSET))

      # Insert task right before the next header, ensuring one blank line
      # First add the task at the line before the next header
      sed -i "$((NEXT_HEADER_LINE - 1))i- $TASK ($TIMESTAMP)" "$ORG_FILE"

      # Ensure there's exactly one blank line between the task and the next header
      sed -i "$((NEXT_HEADER_LINE))i\\" "$ORG_FILE"
      # Remove any additional blank lines
      sed -i "$((NEXT_HEADER_LINE - 1)),$((NEXT_HEADER_LINE + 1))s/\n\n\n/\n\n/g" "$ORG_FILE"
    else
      # No next header, so append to the end of the file
      echo "- $TASK ($TIMESTAMP)" >>"$ORG_FILE"
    fi
  else
    # Today's header doesn't exist, create it right after the title line
    # Use a more direct approach with awk to ensure correct formatting
    awk 'NR==1{print; print "* '"$TODAY"'"; print "- '"$TASK"' ('"$TIMESTAMP"')"; print ""; next} {print}' "$ORG_FILE" >"${ORG_FILE}.tmp" && mv "${ORG_FILE}.tmp" "$ORG_FILE"
  fi

  echo "Task added to $ORG_FILE"

  # git sync
  todo_sync

}

# Aliases
#
# t: git pull notes, then auto commit/push when neovim closed.
# to: git pull notes, then open neovim (without autosave when closed)
# ts: git pull/commit/push (sync).
# j: run journal function to append to journal.esg.org in toto/esg folder
#alias t="cd ~/todo && git pull && nvim . && git add . && git commit -m \"Sync: $(date '+%Y-%m-%d %H:%M:%S')\" && git push && echo 'Synced Successfully.'"
alias t="todo_edit"
alias ts="todo_sync"
alias j="journal"
