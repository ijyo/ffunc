ffunc::fzf_cd() {
  builtin cd $(print ${(F)@} | sort -u | fzf --no-multi)
}

ffunc::cd::cdr::compact-chpwd_recent_dirs() {
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

ffunc::cd::cdr::list() {
  ffunc::cd::cdr::compact-chpwd_recent_dirs
  cdr -l | sed -e 's/^[^ ][^ ]* *//' | sed -e "s:^~:$HOME:"
}

ffunc::cd::cdr::cd() {
  if [ $# -gt 0 ]; then builtin cd $@; return; fi

  ffunc::fzf_cd $(ffunc::cd::cdr::list)
}

ffunc::cd::ghq::list() {
  ghq list --full-path
}

ffunc::cd::ghq::cd() {
  if [ $# -gt 0 ]; then builtin cd $@; return; fi

  ffunc::fzf_cd $(ffunc::cd::ghq::list)
}

ffunc::cd() {
  if [ $# -gt 0 ]; then builtin cd $@; return; fi

  local cdr=$(ffunc::cd::cdr::list)
  local ghq=$(ffunc::cd::ghq::list)

  ffunc::fzf_cd $(print "${cdr}\n${ghq}")
}
