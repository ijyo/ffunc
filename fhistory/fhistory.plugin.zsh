function fhistory::fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --no-sort
    --tac
    $FHISTORY_FZF_DEFAULT_OPTS
  " fzf "$@"
}

function fhistory::history() {
  fc -l 1 | fhistory::fzf | sed -r 's/ *[0-9]* *//'
}
