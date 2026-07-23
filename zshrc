# --- Homebrew (Apple Silicon) ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- History: big, shared across tabs, searchable ---
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY       # timestamps in history
setopt SHARE_HISTORY          # share history between all sessions
setopt INC_APPEND_HISTORY     # write immediately, not on shell exit
setopt HIST_IGNORE_ALL_DUPS   # no duplicate entries
setopt HIST_IGNORE_SPACE      # commands starting with space are not saved
setopt HIST_REDUCE_BLANKS

# --- Completion (case-insensitive) ---
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

export EDITOR=vim

# --- Prompt: current dir + git branch ---
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{242}(%b)%f'
setopt PROMPT_SUBST
PROMPT='%F{cyan}%1~%f${vcs_info_msg_0_} %F{green}❯%f '

# --- Keybindings: standard (emacs-style) ---
bindkey -e                        # Ctrl-A/E/W/U/K work as expected
bindkey '^[[1;3C' forward-word    # Alt-Right: jump word forward
bindkey '^[[1;3D' backward-word   # Alt-Left: jump word back

# ↑/↓ search history filtered by what you already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# --- fzf: Ctrl-R fuzzy history search, Ctrl-T fuzzy file picker ---
source <(fzf --zsh)

# --- Autosuggestions (ghost text from history; Ctrl-E or → accepts) ---
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# --- Aliases ---
source $HOME/.zsh-aliases

# --- Machine-local config, not tracked in git ---
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# --- Syntax highlighting (must be sourced last) ---
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
