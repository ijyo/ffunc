function fcd::fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    $FCD_FZF_DEFAULT_OPTS
    --no-multi
  " fzf "$@"
}

function fcd::cdr::compact-chpwd_recent_dirs() {
  emulate -L zsh
  setopt extendedglob
  local -aU reply
  integer history_size
  autoload -Uz chpwd_recent_filehandler
  chpwd_recent_filehandler
  history_size=$#reply
  reply=(${^reply}(N))
  (( $history_size == $#reply )) || chpwd_recent_filehandler $reply
}

function fcd::cdr::list() {
  fcd::cdr::compact-chpwd_recent_dirs
  cdr -l | sed -e 's/^[^ ][^ ]* *//' | sed -e "s:^~:$HOME:"
}

function fcd::cdr() {
  if [ $# -gt 0 ]; then builtin cd $@; return; fi

  local d=$(fcd::cdr::list | sort -u | fcd::fzf)
  [[ -n "$d" ]] && builtin cd "${(Q)d}"
}

function fcd::ghq::list() {
  ghq list --full-path
}

function fcd::ghq() {
  if [ $# -gt 0 ]; then builtin cd $@; return; fi

  local d=$(fcd::ghq::list | sort -u | fcd::fzf)
  [[ -n "$d" ]] && builtin cd "${(Q)d}"
}

function fcd::all() {
  if [ $# -gt 0 ]; then builtin cd $@; return; fi

  IFS=$'\n'
  local list=($(fcd::cdr::list) $(fcd::ghq::list))
  local d=$(echo "${(F)list[@]}" | sort -u | fcd::fzf)
  [[ -n "$d" ]] && builtin cd "${(Q)d}"
}
