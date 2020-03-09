# ffunc

ffunc is zsh utilities with [fzf](https://github.com/junegunn/fzf).

## Installation

### e.g. [zinit](https://github.com/zdharma/zinit)

```zsh
zinit ice from'gitlab' atload'() {
  alias c=ffunc::cd

  function __put-ffunc_history() {
    BUFFER=$(ffunc::history)
    CURSOR=$#BUFFER
    zle -R -c
  }
  zle -N __put-ffunc_history
  for m in viins vicmd; do
    bindkey -M $m "^r" __put-ffunc_history
  done

  alias gl=ffunc::git::log
}'
zinit light ijyo/ffunc.git
```
