function fhist::fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    $FHIST_FZF_DEFAULT_OPTS
    --no-sort
    --tac
  " fzf "$@"
}

function fhist::history() {
  fc -l 1 | fhist::fzf | sed -r 's/ *[0-9]* *//'
}
