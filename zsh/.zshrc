## HISTORY
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
alias history='fc -l 1'

## ZOXIDE
eval "$(zoxide init zsh)"
## STARSHIP
eval "$(starship init zsh)"
## MISE
eval "$(mise activate zsh)"

## ALIASES
alias settings="nvim ~/.config/zsh/.zshrc && source ~/.config/zsh/.zshrc"
alias l="eza -l"
alias ll="l -a"
alias cd="z"
alias python=python3
alias claude="claude --dangerously-skip-permissions"


# Created by `pipx` on 2026-02-14 09:25:20
export PATH="$PATH:/Users/julien/.local/bin"

echo 'setup'
