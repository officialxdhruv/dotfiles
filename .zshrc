
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d $ZINIT_HOME ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load completions
# fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"


# add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::vscode
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose

zinit cdreplay -q

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh)"
fi

# Keybindings
bindkey -e 
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select no
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:*' fzf-preview "$show_file_or_dir_preview"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --color=always $realpath | head -200'
zstyle ':fzf-tab:complete:(export|unset):*' fzf-flags '--preview-window=wrap'
zstyle ':fzf-tab:complete:(export|unset):*' fzf-preview 'val=${(P)word}; [[ -n $val ]] && printf "%s\n" "$val" || echo "<unset>"'

# Aliases
alias ls='eza'
alias c='clear'
alias cat='bat'
alias zshrc="code ~/.zshrc"
alias sz="source ~/.zshrc"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"


# Shell integration
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/node@24/lib"
export CPPFLAGS="-I/opt/homebrew/opt/node@24/include"