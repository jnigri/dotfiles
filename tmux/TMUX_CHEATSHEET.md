# Tmux Cheat Sheet

Prefix: `Ctrl-b`

## Session

- Start new session: `tmux new -s <name>`
- List sessions: `tmux ls`
- Switch session picker: `Prefix` `S`
- Detach: `Prefix` `Ctrl-d`
- Lock server: `Prefix` `Ctrl-x`

## Windows

- New window: `Prefix` `c`
- Rename window: `Prefix` `r`
- List windows: `Prefix` `w`
- Choose window: `Prefix` `"`
- Previous window: `Prefix` `H`
- Next window: `Prefix` `L`
- Last window: `Prefix` `Ctrl-a`

## Panes

- Split vertically: `Prefix` `s`
- Split horizontally: `Prefix` `v`
- Move left: `Prefix` `h`
- Move down: `Prefix` `j`
- Move up: `Prefix` `k`
- Move right: `Prefix` `l`
- Toggle zoom: `Prefix` `z`
- Kill current pane: `Prefix` `X`
- Swap pane downward: `Prefix` `x`
- Toggle pane border status: `Prefix` `P`
- Clear pane: `Prefix` `K`

## Resize Panes

- Wider left: `Prefix` `,`
- Wider right: `Prefix` `.`
- Taller down: `Prefix` `-`
- Taller up: `Prefix` `=`

## Copy / Scroll

- Mouse scrolling is enabled.
- Enter copy mode: `Prefix` `[`
- In copy mode, selection starts with: `v`
- Copy mode uses `vi` keys.

## Reload / Refresh

- Reload tmux config: `Prefix` `R`
- Refresh client: `Prefix` `Ctrl-l`

## Plugins

- Install TPM plugins: `Prefix` `I`
- Update TPM plugins: `Prefix` `U`
- Floax popup: `Prefix` `p`
- SessionX switcher: `Prefix` `o`
- SessionX open in new window: `Ctrl-y` inside SessionX

## Behavior In This Config

- Window numbering starts at `1`.
- Status bar is at the top.
- Clipboard integration is enabled.
- History limit is `1000000`.
- Window numbers are shown on the right side of each pill.
- Theme: Catppuccin Mocha with rounded window style.

## Notes

- `Prefix` `|` uses tmux's plain split-window binding.
- `Prefix` `:` opens the tmux command prompt.
- `Prefix` `*` is bound to synchronize panes in the active window.
