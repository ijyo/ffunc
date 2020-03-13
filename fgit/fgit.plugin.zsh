function fgit::fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --ansi
    --bind='ctrl-v:toggle-preview' \
    --preview-window='right:60%' \
    $FGIT_FZF_DEFAULT_OPTS
  " fzf "$@"
}

function fgit::bin() {
  print ${FGIT_GIT:-git}
}

function fgit::inside_work_tree() {
  eval "$(fgit::bin) rev-parse --is-inside-work-tree >/dev/null"
}

function fgit::log() {
  fgit::inside_work_tree || return 1

  local bin=$(fgit::bin)
  local cmd="$(fgit::bin) log --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr%' $@"

  local grep_hash="echo {} | grep -o '[a-f0-9]\{7\}'"
  local git_show="$grep_hash | head -1 | xargs -I% $bin show --color=always %"

  eval $cmd | \
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

  local bin=$(fgit::bin)
  local cmd="$bin -c color.status=always status -s $@"

  local git_unstage="[[ {1} = '??' ]] && return || $bin restore --staged {-1}"
  local git_restore="[[ {1} = '??' ]] && return || $bin restore {-1}"

  eval $cmd | \
    fgit::fzf +s +m \
      --bind="enter:execute($bin commit)+reload($cmd)" \
      --bind="ctrl-r:reload($cmd)" \
      --bind="space:execute($bin diff --color=always -- {-1} | LESS='-R' less)" \
      --bind="alt-space:execute($bin diff --staged --color=always -- {-1} | LESS='-R' less)" \
      --bind="[:execute($bin add {-1})+up+reload($cmd)" \
      --bind="]:execute($git_unstage)+up+reload($cmd)" \
      --bind="!:execute($git_restore)+reload($cmd)" \
      --bind='ctrl-y:execute(echo -n {-1} | xsel -ib)+abort' \
      --preview="$bin diff --color=always -- {-1}"
}
