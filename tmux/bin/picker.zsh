# Shared look and plumbing for the tmux popup pickers (agent-panes, tmux-sessions),
# styled with the Asiimov palette (@thm_* options, so it follows light/dark).
#
# A picker script sources this file with its arguments, then defines:
#   picker_title  header block text      picker_empty  text when the list is empty
#   hints         footer pairs: key label key label …
#   load          fills ids (one entry per row) and anything row needs
#   row <i>       prints row i          counts  prints the header counts
#   preview_target / preview_label      pane shown under the list, and its label
#   on_key        handles $key for keys beyond j/k/arrows/q/Esc
# and calls picker_run. Called without PICKER_POPUP, picker_run reopens the
# script inside a themed popup on the client given as first argument.

setopt extendedglob
zmodload zsh/datetime  # EPOCHSECONDS
: ${LANG:=en_US.UTF-8}; export LANG  # popups may start without a locale
client="$1"

thm() { local v=$(tmux show -gv "@thm_$1" 2>/dev/null); print -r -- "${v:-$2}"; }
c_bg=$(thm bg '#141516')         c_fg=$(thm fg '#e6e8e9')
c_accent=$(thm blue '#ff5a00')   c_green=$(thm green '#5fcf7d')
c_yellow=$(thm yellow '#ffb547') c_red=$(thm red '#ff4d6a')
c_sub=$(thm subtext_0 '#a9aeb2') c_dim=$(thm overlay_1 '#6b7074')
c_line=$(thm surface_2 '#3a3d40') c_sel=$(thm surface_1 '#2c2f31')

rgb() { local h=${2#\#}; print -rn -- $'\e['"$1;2;$((16#${h[1,2]}));$((16#${h[3,4]}));$((16#${h[5,6]}))m"; }
F_fg=$(rgb 38 $c_fg) F_accent=$(rgb 38 $c_accent) F_green=$(rgb 38 $c_green)
F_yellow=$(rgb 38 $c_yellow) F_red=$(rgb 38 $c_red) F_sub=$(rgb 38 $c_sub)
F_dim=$(rgb 38 $c_dim) F_line=$(rgb 38 $c_line) F_bg=$(rgb 38 $c_bg)
B_sel=$(rgb 48 $c_sel) B_accent=$(rgb 48 $c_accent)
R=$'\e[0m' BOLD=$'\e[1m' EOL=$'\e[K'

# Agent logos from the AgentIcons font (tmux/agent-icons, mapped in
# ghostty/config). AGENT_PICKER_ICONS=0 shows names instead.
agents=(claude codex opencode)
typeset -A glyphs=(claude $'\U000F2000' codex $'\U000F2001' opencode $'\U000F2002')
typeset -A colors=(claude "$(rgb 38 '#D97757')" codex "$(rgb 38 '#7A9DFF')" opencode "$(rgb 38 '#CFCECD')")

typeset -a ids hints
sel=1 msg="" msg_color=$F_sub key=""

say() { msg=$1; msg_color=${2:-$F_sub}; }

ago() {  # ago <epoch> -> 12s / 5m / 3h / 2d (empty for 0)
  (( $1 )) || return 0
  local d=$(( EPOCHSECONDS - $1 ))
  if (( d < 60 )); then print -rn -- "${d}s"
  elif (( d < 3600 )); then print -rn -- "$(( d / 60 ))m"
  elif (( d < 86400 )); then print -rn -- "$(( d / 3600 ))h"
  else print -rn -- "$(( d / 86400 ))d"; fi
}

# Selection bar and background for row i: sets bar, bg, tcol (title color).
row_style() {
  bar=' ' bg='' tcol=$F_sub
  (( $1 == sel )) && { bar="$F_accent▌" bg=$B_sel tcol=$F_fg; }
}

footer() {
  local out=$'\e['$LINES$';1H  ' i
  if [[ -n $msg ]]; then
    out+="$msg_color$msg$R"
  else
    for (( i = 1; i < ${#hints}; i += 2 )); do
      out+="$F_accent$BOLD${hints[i]}$R  $F_dim${hints[i+1]}   "
    done
  fi
  print -rn -- "$out$R$EOL"
}

draw() {
  local cols=$COLUMNS rows=$LINES i line out
  out=$'\e[?2026h\e[H'
  # Header: accent block like the status bar's session block, then counts.
  out+=$'\n'"  $B_accent$F_bg$BOLD  $picker_title  $R  $(counts)$EOL"$'\n'"$EOL"$'\n'
  (( ${#ids} )) || out+="   $F_dim $picker_empty$EOL"$'\n'
  for (( i = 1; i <= ${#ids}; i++ )); do out+=$(row $i)$'\n'; done
  # Preview of the selected row's pane, colors kept.
  local room=$(( rows - (3 + ${#ids} + 2) - 2 ))
  if (( ${#ids} && room > 1 )); then
    local label=" $(preview_label) "
    out+="$EOL"$'\n'"  $F_line──$F_accent$label$F_line${(l:cols-6-${#label}::─:)}$R$EOL"$'\n'
    local -a prev=("${(@f)$(tmux capture-pane -e -p -t "$(preview_target)" 2>/dev/null)}")
    while (( ${#prev} )) && [[ -z ${${prev[-1]//$'\e'\[[0-9;:]#m/}// } ]]; do prev[-1]=(); done
    # No reset between lines: capture-pane -e only emits color changes, so a
    # highlight that reaches the right edge carries on into the next line.
    for line in "${(@)prev[-(room-1),-1]}"; do out+="   $line$EOL"$'\n'; done
    out+=$R
  fi
  out+=$'\e[J'
  print -rn -- "$out$(footer)"$'\e[?2026l'
}

# Reads one key into $key (arrows become j/k, Delete/Backspace become DEL,
# Return becomes \n). Returns 1 after a second without input.
readkey() {
  key=""
  read -s -k 1 -t 1 key || return 1
  if [[ $key == $'\e' ]]; then
    local seq=""; read -s -k 2 -t 0.05 seq
    case $seq in
      '[3') read -s -k 1 -t 0.05; key=DEL ;;
      '[A') key=k ;;
      '[B') key=j ;;
    esac
  fi
  [[ $key == ($'\x7f'|$'\b') ]] && key=DEL
  [[ $key == $'\r' ]] && key=$'\n'
  return 0
}

# confirm <question>: asks y/n in the footer.
confirm() {
  say "$1 ${BOLD}y${R}${F_red}/n" $F_red; draw
  local k; read -s -k 1 k
  [[ $k == [yY] ]] || { say "Cancelled."; return 1; }
}

# ask <label> [initial]: one line of text in the footer into $REPLY.
# Enter accepts, Esc cancels (returns 1), Ctrl+U clears.
ask() {
  local buf=$2 k
  printf '\e[?25h'
  while true; do
    print -rn -- $'\e['$LINES$';1H  '"$F_accent$BOLD$1$R  $F_fg$buf$EOL"
    read -s -k 1 k || continue
    case $k in
      $'\n'|$'\r') break ;;
      $'\e') read -s -k 2 -t 0.05 k; printf '\e[?25l'; return 1 ;;
      $'\x7f'|$'\b') buf=${buf[1,-2]} ;;
      $'\x15') buf='' ;;
      [[:print:]]) buf+=$k ;;
    esac
  done
  printf '\e[?25l'; REPLY=$buf
}

picker_run() {
  if [[ -z $PICKER_POPUP ]]; then
    exec tmux display-popup -c "$client" -E -w 90% -h 85% -b rounded \
      -S "fg=$c_line" -s "bg=$c_bg,fg=$c_fg" -e PICKER_POPUP=1 \
      "${(q)ZSH_ARGZERO} ${(q)client}"
  fi
  trap 'printf "\e[?25h\e[?7h\e[0m"' EXIT
  printf '\e[?25l\e[?7l'  # hide cursor, no autowrap (long lines clip)
  load
  (( ${+functions[on_start]} )) && on_start
  while true; do
    draw
    readkey || { load; continue; }  # timeout: live refresh
    msg=""
    case $key in
      j) (( sel < ${#ids} )) && (( sel++ )) ;;
      k) (( sel > 1 )) && (( sel-- )) ;;
      q|$'\e') exit 0 ;;
      *) on_key ;;
    esac
  done
}
