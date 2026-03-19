#!/usr/bin/env zsh
# Fjord zsh theme (generated from Handlebars)
# Dusk-blue base with soft leaf-green accents, crisp blue/cyan separation

# --- Fjord palette (injected) ---
FJORD_BG="#1B2532"
FJORD_BG_ALT="#222E3F"
FJORD_SURFACE="#1F2A39"
FJORD_LINE="#233141"

FJORD_FG="#E8F0F3"
FJORD_MUTED="#6C7A86"
FJORD_MUTED_DIM="#51606B"

FJORD_GREEN="#9DD99A"
FJORD_BLUE="#5DA6EA"
FJORD_CYAN="#B8E7E9"
FJORD_YELLOW="#C8B860"
FJORD_RED="#F37C7C"
FJORD_PURPLE="#A8A4F8"

FJORD_BRIGHT_GREEN="#A3D5A0"
FJORD_BRIGHT_BLUE="#7BB8FF"
FJORD_BRIGHT_YELLOW="#D4CC7A"
FJORD_BRIGHT_RED="#FF9B9B"
FJORD_BRIGHT_PURPLE="#C8CCF7"
FJORD_BRIGHT_CYAN="#A1E9DE"
FJORD_BRIGHT_WHITE="#EFFAFF"

# --- Prompt configuration ---
setopt PROMPT_SUBST

# Optional glyphs (fallback to ASCII if needed)
: ${FJORD_PROMPT_GLYPH:="❯"}
: ${FJORD_GIT_BRANCH_GLYPH:=""}   # fallback: "git:"
: ${FJORD_SEP_GLYPH:=""}          # fallback: ">"

# Return current git branch or short SHA
fjord_git_branch() {
  local b
  b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return 1
  [[ -n "$b" ]] || return 1
  print -r -- "$b"
}

# Return "*" if working tree is dirty
fjord_git_dirty() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 1
  [[ -n "$(git status --porcelain 2>/dev/null)" ]] && print -r -- "*" || return 1
}

# Compose git segment
fjord_git_segment() {
  local b d
  b=$(fjord_git_branch) || return 0
  d=$(fjord_git_dirty) || d=""
  print -r -- "%F{$FJORD_BRIGHT_BLUE}${FJORD_GIT_BRANCH_GLYPH}%f %F{$FJORD_BRIGHT_BLUE}${b}%f%F{$FJORD_YELLOW}${d}%f"
}

# Left prompt: user@host dir [git]
PROMPT='%F{$FJORD_CYAN}%n%f@%F{$FJORD_GREEN}%m%f %F{$FJORD_BLUE}%~%f $(fjord_git_segment)
%(?.%F{$FJORD_GREEN}.%F{$FJORD_RED})$FJORD_PROMPT_GLYPH%f '

# Right prompt: time
RPROMPT='%F{$FJORD_MUTED}%*%f'

# Cursor and selection colors (supported terminals)
if [[ -n "$TERM" ]]; then
  # Some terminals honor OSC sequences for cursor/selection; safe no-ops otherwise
  # Cursor color (green on dark bg)
  print -n $'\e]12;'${FJORD_GREEN}$'\a' 2>/dev/null
fi

# Optional: colorize directory colors to match Fjord (if dircolors present)
if command -v dircolors >/dev/null 2>&1; then
  # This is a placeholder to allow users to inject LS_COLORS via their setup
  :
fi

# Notes:
# - Requires a Nerd Font for glyphs to render properly. If not available, set:
#     FJORD_GIT_BRANCH_GLYPH="git:" FJORD_SEP_GLYPH=">"
# - Colors use truecolor via %F{#RRGGBB}. PROMPT_SUBST enables variable expansion inside %F{...}.
