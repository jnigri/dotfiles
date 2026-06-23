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
alias settings="nvim ~/.zshrc && source ~/.zshrc"
alias l="eza -l"
alias ll="l -a"
alias cd="z"
alias python=python3
alias claude="claude --dangerously-skip-permissions"


# Created by `pipx` on 2026-02-14 09:25:20
export PATH="$PATH:/Users/julien/.local/bin"


# bsport
export GITLAB_PAT="glpat-Rgj02dEFmf91K44v63XZ-WM6MQpvOjEKdTppaTIydA8.01.171i3x5wg"
export GITLAB_ACCESS_TOKEN="glpat-Rgj02dEFmf91K44v63XZ-WM6MQpvOjEKdTppaTIydA8.01.171i3x5wg"


fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select

# --- bsport local auth helpers (bauth / bhttp) ---
export BAUTH_HOST="${BAUTH_HOST:-http://localhost:8000}"
export BAUTH_PASSWORD="${BAUTH_PASSWORD:-P@ssw0rd}"
export BAUTH_TOKEN_FILE="/tmp/.bauth"

bauth() {
  if [[ -z "$1" ]]; then
    echo "usage: bauth <user|partner>   e.g. bauth oliver.o | bauth usc" >&2
    return 1
  fi
  local name="$1"
  local email
  if [[ "$name" == *"@"* ]]; then
    email="$name"
  else
    email="${name}@example.com"
  fi

  local resp
  resp=$(http --ignore-stdin POST \
    "${BAUTH_HOST}/api/v1/authentication/signin/with-login/" \
    email="$email" password="$BAUTH_PASSWORD")
  local rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "bauth: request failed (rc=$rc)" >&2
    return $rc
  fi

  local token
  token=$(printf '%s' "$resp" | jq -r '.token // empty')
  if [[ -z "$token" ]]; then
    echo "bauth: no token in response:" >&2
    echo "$resp" >&2
    return 1
  fi

  umask 077
  printf '%s' "$token" > "$BAUTH_TOKEN_FILE"
  echo "bauth: logged in as $email -> $BAUTH_TOKEN_FILE"
}

bhttp() {
  if [[ ! -s "$BAUTH_TOKEN_FILE" ]]; then
    echo "bhttp: no token; run 'bauth <user>' first" >&2
    return 1
  fi
  if [[ $# -eq 0 ]]; then
    echo "usage: bhttp [METHOD] <path-or-url> [httpie args...]" >&2
    return 1
  fi
  local token
  token=$(< "$BAUTH_TOKEN_FILE")

  local method url
  case "$1" in
    GET|POST|PUT|PATCH|DELETE|HEAD|OPTIONS)
      method="$1"; shift
      url="$1"; shift
      ;;
    *)
      method="GET"
      url="$1"; shift
      ;;
  esac

  if [[ "$url" == /* ]]; then
    url="${BAUTH_HOST}${url}"
  fi

  http "$method" "$url" "Authorization:Token ${token}" "$@"
}
# --- end bsport local auth helpers ---

# --- USC instant-booking helper (HMAC signed) ---
export USC_CLIENT_SECRET_LOCAL="${USC_CLIENT_SECRET_LOCAL:-90beda82-391e-4cc4-8eee-91d0da1b7ad1}"

# usage: usc-book <event_id> <customer_id> <first_name> <last_name> [booking_id]
usc-book() {
  if [[ $# -lt 4 ]]; then
    echo "usage: usc-book <event_id> <customer_id> <first_name> <last_name> [booking_id]" >&2
    return 1
  fi
  local event_id="$1" customer_id="$2" first="$3" last="$4"
  local booking_id="${5:-usc-booking-$(date +%s)-$RANDOM}"
  local host="${BAUTH_HOST:-http://localhost:8000}"
  local url_path="/api/v1/partnership/urban_sports_club/book/"

  local body
  body=$(jq -nc \
    --arg id "$booking_id" --arg ev "$event_id" --arg cu "$customer_id" \
    --arg fn "$first" --arg ln "$last" \
    '{id:$id,event_id:$ev,customer_id:$cu,first_name:$fn,last_name:$ln}')

  local ts sig
  ts=$(python3 -c "from datetime import datetime,timezone; print(datetime.now(timezone.utc).isoformat(timespec='seconds'))")
  sig=$(python3 -c "
import base64,hmac,sys
from hashlib import sha256
secret=sys.argv[1].encode(); msg=sys.argv[2].encode()
print(base64.b64encode(hmac.new(secret,msg,sha256).digest()).decode())
" "$USC_CLIENT_SECRET_LOCAL" "POST
${url_path}
${ts}
${body}")

  http --ignore-stdin POST "${host}${url_path}" \
    "Content-Type:application/json" \
    "x-timestamp:${ts}" \
    "x-signature:${sig}" \
    --raw "$body"
}
# --- end USC instant-booking helper ---

export CLAUDE_CONFIG_DIR="$HOME/.config/claude"
