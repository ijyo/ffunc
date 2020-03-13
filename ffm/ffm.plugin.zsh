function ffm::fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --ansi
    --bind='ctrl-v:toggle-preview' \
    --preview-window='right:60%' \
    $FFM_FZF_DEFAULT_OPTS
  " fzf "$@"
}

function ffm::preview() {
  local mime=$(file --mime-type -b "$1")
  if [[ "$mime" = "inode/directory" ]]; then
    ls -a -1 --color=always --group-directories-first "$1"
  elif [[ "$mime" =~ "^text/.*" ]]; then
    cat "$1"
  else
    echo "$mime"
  fi
}

function ffm::ls() {
  local p; [[ $# -eq 1 && -d $1 ]] && p="$1/"
  ls -1 -a --color=always --group-directories-first "$@" | \
    awk -v p="$p" '{print p $0}'
}

function ffm::open() {
  local preview="$(typeset -f ffm::preview); ffm::preview {}"
  preview=${FFM_PREVIEW:-"$preview"}

  local entries=$(cat - | \
    ffm::fzf \
      --no-sort \
      --multi \
      --tac \
      --preview="$preview"
  )

  [[ ${#entries} -eq 0 ]] && return 1

  if [[ $# -ge 1 ]]; then
    "$@" "${(f)entries}"
    return
  fi

  if [[ -n "$FFM_OPEN" ]]; then
    $FFM_OPEN ${(f)entries}
    return
  fi

  local first=${entries[(f)1]}
  if [[ -d $first ]]; then
    builtin cd $first
  else
    xdg-open $first
  fi
}

function ffm::cp() {
  local preview="$(typeset -f ffm::preview); ffm::preview {}"
  preview=${FFM_PREVIEW:-"$preview"}

  ffm::fzf \
    --no-sort \
    --multi \
    --tac \
    --preview="$preview" | \
  xargs -I% cp -r % "$1"
}

function ffm::mv() {
  local preview="$(typeset -f ffm::preview); ffm::preview {}"
  preview=${FFM_PREVIEW:-"$preview"}

  ffm::fzf \
    --no-sort \
    --multi \
    --tac \
    --preview="$preview" | \
  xargs -I% mv % "$1"
}
