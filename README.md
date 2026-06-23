# ~/.config

User configuration files for various tools.

## New machine setup

### 1. Bootstrap zsh config location

Add to `~/.zshenv` (must live at that exact path — zsh reads it before ZDOTDIR is known):

```sh
export ZDOTDIR="$HOME/.config/zsh"
```

### 2. Symlink Claude skills
