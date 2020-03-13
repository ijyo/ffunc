# fcd
alias c=fcd::all

# ffm
alias fo=ffm::open
alias fcp=ffm::cp
alias fmv=ffm::mv

# fgit
alias gl=fgit::log
alias gs=fgit::status

# fhist
function __put-fhist() {
  BUFFER=$(fhist::history)
  CURSOR=$#BUFFER
  zle -R -c
}
zle -N __put-fhist
bindkey "^r" __put-fhist
