# ffunc

ffunc is zsh utilities with [fzf](https://github.com/junegunn/fzf).

## Installation

### e.g. [zinit](https://github.com/zdharma/zinit)

```zsh
zinit ice from'gitlab' atload'() {
  alias c=fcd::cd

  alias fo=ffile::open

  alias gl=fgit::log
  alias gs=fgit::status

  function __put-fhistory() {
    BUFFER=$(fhistory::history)
    CURSOR=$#BUFFER
    zle -R -c
  }
  zle -N __put-fhistory
  for m in viins vicmd; do
    bindkey -M $m "^r" __put-fhistory
  done
}'
zinit light ijyo/ffunc.git
```
