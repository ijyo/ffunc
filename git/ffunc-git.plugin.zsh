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
      --bind="ctrl-b:execute($grep_hash | xargs -I% git rebase -i %)+abort" \
      --bind='?:toggle-preview' \
      --preview-window='right:60%' \
      --preview="$git_show"
}
