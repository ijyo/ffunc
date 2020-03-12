function fhist::fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --no-sort
    --tac
    $FHIST_FZF_DEFAULT_OPTS
  " fzf "$@"
}

function fhist::history() {
  fc -l 1 | fhist::fzf | sed -r 's/ *[0-9]* *//'
}
