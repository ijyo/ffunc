# fcd
alias c=fcd::cd

# ffm
function fo=() {
  ffm::ls | ffm::open
}

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
for m in viins vicmd; do
  bindkey -M $m "^r" __put-fhist
done
