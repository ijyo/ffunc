function ffunc::git::inside_work_tree() {
  local git=${GIT:-git}
  $git rev-parse --is-inside-work-tree >/dev/null
}

function ffunc::git::log() {
  ffunc::git::inside_work_tree || return 1

  local git=${GIT:-git}
  local grep_hash="echo {} | grep -o '[a-f0-9]\{7\}'"
  local git_show="$grep_hash | head -1 | xargs -I% $git show --color=always %"
  $git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr%" $@ | \
    fzf --ansi \
      --no-sort \
      --no-multi \
      --tiebreak=index \
      --bind="enter:execute($git_show | LESS='-R' less)" \
      --bind="ctrl-y:execute-silent($grep_hash | xargs -I% echo -n "%" | xsel -ib)+abort" \
      --bind="ctrl-r:execute($grep_hash | xargs -I% git rebase -i %)+abort" \
      --bind='?:toggle-preview' \
      --preview-window='right:60%' \
      --preview="$git_show"
}

function ffunc::git::status() {
  ffunc::git::inside_work_tree || return 1

  local git=${GIT:-git}
  local cmd="$git -c color.status=always status -s"

  local git_unstage="[[ {1} = '??' ]] && return || $git restore --staged {-1}"
  local git_restore="[[ {1} = '??' ]] && return || $git restore {-1}"

  eval $cmd | \
    fzf --ansi \
      --no-sort \
      --no-multi \
      --bind="enter:execute($git diff --color=always -- {-1} | LESS='-R' less)" \
      --bind="alt-enter:execute($git diff --staged --color=always -- {-1} | LESS='-R' less)" \
      --bind="ctrl-r:reload($cmd)" \
      --bind="space:execute($git commit)+reload($cmd)" \
      --bind="<:execute($git add {-1})+reload($cmd)" \
      --bind=">:execute($git_unstage)+reload($cmd)" \
      --bind="!:execute($git_restore)+reload($cmd)" \
      --bind='ctrl-y:execute(echo -n {-1} | xsel -ib)+abort' \
      --bind='ctrl-v:toggle-preview' \
      --preview-window='right:60%' \
      --preview="$git diff --color=always -- {-1}"
}
