# ffunc

ffunc is zsh utilities with [fzf](https://github.com/junegunn/fzf).

## Installation

### e.g. [zinit](https://github.com/zdharma/zinit)

```zsh
zinit ice from'gitlab' atload'() {
  alias c=fcd::cd

  alias fo=ffm::open

  alias gl=fgit::log
  alias gs=fgit::status

  function __put-fhist() {
    BUFFER=$(fhist::history)
    CURSOR=$#BUFFER
    zle -R -c
  }
  zle -N __put-fhist
  for m in viins vicmd; do
    bindkey -M $m "^r" __put-fhist
  done
}'
zinit light ijyo/ffunc.git
```
