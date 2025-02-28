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

# Todos
#
# t: git pull notes, then auto commit/push when neovim closed.
# to: git pull notes, then open neovim (without autosave when closed)
# ts: git pull/commit/push (sync).
alias t="cd ~/todo && git pull && nvim . && git add . && git commit -m \"Sync: $(date '+%Y-%m-%d %H:%M:%S')\" && git push && echo 'Synced Successfully.'"
alias to="cd ~/todo && git pull && nvim ."
alias ts="cd ~/todo && git pull && git add . && git commit -m \"Sync: $(date '+%Y-%m-%d %H:%M:%S')\" && git push && echo 'Synced Successfully.'"
