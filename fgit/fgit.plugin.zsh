function fgit::fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    $FGIT_FZF_DEFAULT_OPTS
    --ansi
    --bind='ctrl-v:toggle-preview'
    --preview-window='right:60%'
  " fzf "$@"
}

function fgit::inside_work_tree() {
  eval "${FGIT_GIT:-git} rev-parse --is-inside-work-tree >/dev/null"
}

function fgit::log() {
  fgit::inside_work_tree || return 1

  local bin=${FGIT_GIT:-git}
  local cmd="$bin log --graph --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' $@"

  local grep_hash="echo {} | grep -o '[a-f0-9]\{7\}'"
  local git_show="$grep_hash | head -1 | xargs -I% $bin show --color=always %"

  eval $cmd | \
    awk '$0 ~ /[a-f0-9]{7}/' | \
    fgit::fzf +s +m \
      --tiebreak=index \
      --bind="enter:execute($git_show | LESS='-R' less)" \
      --bind="ctrl-r:reload($cmd)" \
      --bind="ctrl-y:execute-silent($grep_hash | xargs -I% echo -n "%" | xsel -ib)+abort" \
      --bind="!:execute($grep_hash | xargs -I% $bin rebase -i %)+abort" \
      --preview="$git_show"
}

function fgit::status() {
  fgit::inside_work_tree || return 1

  local bin=${FGIT_GIT:-git}
  local cmd="$bin -c color.status=always status -s $@"

  local edit="${VISUAL:-${EDITOR:-less}} {-1}"
  local preview="[[ {1} = '??' ]] && cat {-1} || $bin diff --color=always -- {-1}"
  local git_unstage="[[ {1} = '??' ]] && return || $bin restore --staged {-1}"
  local git_restore="[[ {1} = '??' ]] && return || $bin restore {-1}"

  eval $cmd | \
    fgit::fzf +s +m \
      --bind="enter:execute($bin diff --color=always -- {-1} | LESS='-R' less)" \
      --bind="alt-enter:execute($bin diff --staged --color=always -- {-1} | LESS='-R' less)" \
      --bind="ctrl-r:reload($cmd)" \
      --bind="ctrl-o:execute($edit)+reload($cmd)" \
      --bind="ctrl-x:execute($bin commit)+reload($cmd)" \
      --bind="[:execute($bin add {-1})+up+reload($cmd)" \
      --bind="]:execute($git_unstage)+up+reload($cmd)" \
      --bind="!:execute($git_restore)+reload($cmd)" \
      --bind='ctrl-y:execute(echo -n {-1} | xsel -ib)+abort' \
      --preview="$preview"
}
