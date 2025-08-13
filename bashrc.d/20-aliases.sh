## ----------------------------------------------
## 🧠 ALIASES
## ----------------------------------------------

# 🔧 System & Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah --color=auto'
alias l='ls -CF'
alias cls='clear'
alias grep='grep --color=auto'
alias dfh='df -h'
alias duh='du -h -d 1'

# 🐘 PHP / Composer
alias art='php artisan'
alias ci='composer install'
alias cu='composer update'
alias cr='composer require'
alias cda='composer dump-autoload -o'
alias cc='php bin/console cache:clear'
alias csf='php bin/php-cs-fixer fix'


# 🐳 Docker / Docker Compose
alias d='docker'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcl='docker compose logs -f'
alias dce='docker compose exec'
alias dim='docker images'
alias dps='docker ps'
alias drm='docker rm $(docker ps -a -q)'
alias drmi='docker rmi $(docker images -q)'
alias dclean='docker system prune -af --volumes'


# ⚙️ Node / NPM / Yarn
alias ni='npm install'
alias ns='npm start'
alias nr='npm run'
alias nu='npm update'
alias nuxt='npx nuxi dev'
alias y='yarn'
alias ys='yarn start'
alias yb='yarn build'

# 🔄 Misc / Tools
alias serve='php -S localhost:8000'
alias uuid='uuidgen'
alias secret32='openssl rand -hex 32'
alias timestamp='date +%s'
alias now='date "+%Y-%m-%d %H:%M:%S"'

# 📦 Archivierung
alias untar='tar -xvf'
alias targz='tar -czvf'

# PHP
alias usephp82='sudo update-alternatives --set php /usr/bin/php8.2 && php -v'
alias usephp83='sudo update-alternatives --set php /usr/bin/php8.3 && php -v'
alias usephp84='sudo update-alternatives --set php /usr/bin/php8.4 && php -v'

# Composer
alias usecomposer82='/usr/bin/php8.2 /usr/local/bin/composer'
alias usecomposer83='/usr/bin/php8.3 /usr/local/bin/composer'
alias usecomposer84='/usr/bin/php8.4 /usr/local/bin/composer'

