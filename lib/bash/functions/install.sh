#!/usr/bin/env bash


append_to_bashrc() {
  local START="# >>> dev-env config >>>"
  local END="# <<< dev-env config <<<"
  local CONTENT="$1"
  if ! grep -Fq "$START" "$HOME/.bashrc"; then
    {
      echo ""
      echo "$START"
      echo "$CONTENT"
      echo "$END"
    } >> "$HOME/.bashrc"
    log "bashrc-Konfiguration hinzugefügt."
  else
    log "bashrc-Konfiguration bereits vorhanden."
  fi
}

install_php_versions() {
  sudo add-apt-repository -y ppa:ondrej/php
  sudo apt update
  for version in "${PHP_VERSIONS[@]}"; do
    header "Installiere PHP $version"
    sudo apt install -y php$version
    IFS=' ' read -ra MODULES <<< "${PHP_MODULES[$version]}"
    for module in "${MODULES[@]}"; do
      sudo apt install -y php$version-$module
    done
  done
}

install_composer() {
  header "Installiere Composer"
  if ! command -v composer &> /dev/null; then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
  fi
}

install_nvm_and_node() {
  header "Installiere nvm & Node.js"
  export NVM_DIR="$HOME/.nvm"
  if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi
  source "$NVM_DIR/nvm.sh"
  for node_ver in "${NODE_VERSIONS[@]}"; do
    nvm install "$node_ver"
  done
}

install_docker_cli() {
  header "Installiere Docker CLI"
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce-cli docker-compose-plugin
}

install_symfony_cli() {
  header "Installiere Symfony CLI"
  if ! command -v symfony &> /dev/null; then
    curl -sS https://get.symfony.com/cli/installer | bash
    mkdir -p "$HOME/.local/bin"
    mv "$HOME/.symfony*/bin/symfony" "$HOME/.local/bin/symfony"
  fi
}
