function ffunc::history::fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --no-sort
    --tac
    $FFUNC_FZF_DEFAULT_OPTS
  " fzf "$@"
}

function ffunc::history() {
  fc -l 1 | ffunc::history::fzf | sed -r 's/ *[0-9]* *//'
}
