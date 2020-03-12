function ffile::fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --ansi
    --bind='ctrl-v:toggle-preview' \
    --preview-window='right:60%' \
    $FFILE_FZF_DEFAULT_OPTS
  " fzf "$@"
}

function ffile::preview() {
  local mime=$(file --mime-type -b "$1")
  if [[ "$mime" = "inode/directory" ]]; then
    ls -a -1 --color=always --group-directories-first "$1"
  elif [[ "$mime" =~ "^text/.*" ]]; then
    cat "$1"
  else
    echo "$mime"
  fi
}

function ffile::open() {
  local preview="$(typeset -f ffile::preview); ffile::preview {}"
  preview=${FFILE_PREVIEW:-"$preview"}

  local entries=$(ls -1 -a --color=always --group-directories-first | \
    ffile::fzf \
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

  if [[ -n "$FFILE_OPEN" ]]; then
    $FFILE_OPEN ${(f)entries}
    return
  fi

  local first=${entries[(f)1]}
  if [[ -d $first ]]; then
    builtin cd $first
  else
    xdg-open $first
  fi
}
