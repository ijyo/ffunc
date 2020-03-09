function ffunc::history() {
  fc -l 1 | fzf +s --tac | sed -r 's/ *[0-9]* *//'
}
