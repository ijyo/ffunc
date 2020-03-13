function ffm::fzf() {
  local preview=${FFM_PREVIEW:-'() {
    local mime=$(file --mime-type -b {})
    if [[ "$mime" = "inode/directory" ]]; then
      ls -a -1 --color=always --group-directories-first {}
    elif [[ "$mime" =~ "^text/.*" ]]; then
      cat {}
    else
      echo "$mime"
    fi
  }'}

  local opts="
    $FZF_DEFAULT_OPTS
    --ansi
    --no-sort
    --multi
    --tac
    --bind='ctrl-v:toggle-preview'
    --preview-window='right:60%'
    --preview='$preview'
    $FFM_FZF_DEFAULT_OPTS
  "

  FZF_DEFAULT_OPTS="$opts" fzf "$@"
}

function ffm::ls() {
  local p; [[ $# -eq 1 && -d $1 ]] && p="$1/"
  ls -1 -a --color=always --group-directories-first "$@" | \
    awk -v p="$p" '{print p $0}'
}

function ffm::open() {
  local entries=$(cat - | ffm::fzf)

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
  ffm::fzf | xargs -t -I% cp -r % "$1"
}

function ffm::mv() {
  ffm::fzf | xargs -t -I% mv % "$1"
}
