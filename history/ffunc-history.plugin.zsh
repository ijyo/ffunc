function ffunc::history::fzf() {
  fzf "$@"
}

function ffunc::history() {
  fc -l 1 | ffunc::history::fzf --no-sort --tac | sed -r 's/ *[0-9]* *//'
}
