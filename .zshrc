export ZSH=/usr/share/oh-my-zsh/

ZSH_THEME="superjarin"
DISABLE_AUTO_UPDATE="true"

plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-autocomplete dotbare)
source $ZSH/oh-my-zsh.sh

autoload -U compinit && compinit
export EDITOR='nvim'

# source aliases
source ~/.zsh_personal

# On-demand rehash
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

ls_csv() {
  cat $1 | column -t -s, | less -S
}

add-zsh-hook -Uz precmd rehash_precmd

# zsh-autocomplete
zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' widget-style menu-select
zstyle ':autocomplete:*' fzf-completion yes

# fnm
eval "$(fnm env)"

# Dotbare
_dotbare_completion_cmd
# _dotbare_completion_git
export DOTBARE_DIR="$HOME/.dotfiles"

# source /home/dni9/.config/broot/launcher/bash/br
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(navi widget zsh)"

colorscript random
