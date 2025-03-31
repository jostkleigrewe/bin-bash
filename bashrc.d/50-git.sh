## ----------------------------------------------
## 🧠 BIN BASH: Git
## ----------------------------------------------
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gca='git commit --amend --no-edit'
alias gcm='git commit  --no-edit'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git log --oneline --graph --decorate'
alias gb='git branch'
alias gco='git checkout'
alias gpull='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gpush='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gnew='git add .;git commit --amend --no-edit; git push --force-with-lease'
