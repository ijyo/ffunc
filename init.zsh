FFUNC_ROOT=${${(%):-%x}:A:h}

source $FFUNC_ROOT/fcd/fcd.plugin.zsh
source $FFUNC_ROOT/ffm/ffm.plugin.zsh
source $FFUNC_ROOT/fgit/fgit.plugin.zsh
source $FFUNC_ROOT/fhist/fhist.plugin.zsh

# fcd
alias c=fcd::all

# ffm
alias fo=ffm::open
alias fe="ffm::open ${VISUAL:-${EDITOR:-less}}"
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
