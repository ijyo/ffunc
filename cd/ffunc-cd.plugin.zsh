function ffunc::cd::fzf() {
  fzf --no-multi "$@"
}

function ffunc::cd::do() {
  builtin cd $(print ${(F)@} | sort -u | ffunc::cd::fzf)
}

function ffunc::cd::cdr::compact-chpwd_recent_dirs() {
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

function ffunc::cd::cdr::list() {
  ffunc::cd::cdr::compact-chpwd_recent_dirs
  cdr -l | sed -e 's/^[^ ][^ ]* *//' | sed -e "s:^~:$HOME:"
}

function ffunc::cd::cdr() {
  if [ $# -gt 0 ]; then builtin cd $@; return; fi

  ffunc::cd::do $(ffunc::cd::cdr::list)
}

function ffunc::cd::ghq::list() {
  ghq list --full-path
}

function ffunc::cd::ghq() {
  if [ $# -gt 0 ]; then builtin cd $@; return; fi

  ffunc::cd::do $(ffunc::cd::ghq::list)
}

function ffunc::cd() {
  if [ $# -gt 0 ]; then builtin cd $@; return; fi

  local cdr=$(ffunc::cd::cdr::list)
  local ghq=$(ffunc::cd::ghq::list)

  ffunc::cd::do $(print "${cdr}\n${ghq}")
}
