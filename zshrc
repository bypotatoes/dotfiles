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

# --- Prompt: robbyrussell (oh-my-zsh default) look, without oh-my-zsh ---
# green ➜ (red after a failed command), cyan dir, git:(branch), yellow ✗ when dirty
git_prompt_info() {
  local ref
  ref=$(command git symbolic-ref --short HEAD 2>/dev/null) \
    || ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
  local dirty=""
  [[ -n $(command git status --porcelain 2>/dev/null) ]] && dirty=" %B%F{yellow}✗%f%b"
  echo " %B%F{blue}git:(%F{red}${ref}%F{blue})%f%b${dirty}"
}
setopt PROMPT_SUBST
PROMPT='%(?:%B%F{green}➜%f%b :%B%F{red}➜%f%b )%B%F{cyan}%1~%f%b$(git_prompt_info) '

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
