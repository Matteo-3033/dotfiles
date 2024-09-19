#!/usr/bin/bash

eval "$(fzf --zsh)"
alias fzf=~/.config/fzf/fzf-tmux.sh

export FZF_DEFAULT_OPTS='
  --height="40%" --layout="reverse"
  --prompt="> " --marker=">" --pointer="◆" --separator="─"
  --scrollbar="│"
  --info="inline"
  --bind "ctrl-y:execute-silent(readlink -f {} | xclip -selection clipboard)"
  --bind "ctrl-o:execute-silent(xdg-open {+})"
  --bind "ctrl-y:preview-up"
  --bind "ctrl-e:preview-down"
  --bind "ctrl-u:preview-half-page-up"
  --bind "ctrl-d:preview-half-page-down"
'

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
	git)          fzf --preview 'git diff --color=always {}' "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

_fzf_complete_git() {
   subcommand=`echo $1 | awk '{print $2}'`
   
   local -r get_selected_branch='echo {} | sed "s/^[* ]*//" | awk "{print \$1}"'
   local -r git_root_dir=$(git rev-parse --show-toplevel)

   list=""
   preview="bat --color=always --style=grid --line-range :500 {}"
   preview_title=""

   case "$subcommand" in
	  checkout|merge|switch|pull|push|rebase)
		 list=`
			git branch \
			   --all --color \
			   --format=$'%(HEAD) %(color:yellow)%(refname:short)\t%(color:green)%(committerdate:short)\t%(color:blue)%(subject)' \
			| column --table --separator=$'\t'
		 `
		 preview="git log \$($get_selected_branch) --graph --color --format='%C(white)%h - %C(green)%cs - %C(blue)%s%C(red)%d'"
		 preview_title="[ Commits ]"
		 ;;
	  add)
		 list=`git ls-files --modified --deleted --other --exclude-standard --deduplicate $git_root_dir`
		 preview='git diff --color=always {} | sed "1,4d"'
		 preview_title="[ Diff ]"
		 ;;
	  restore)
		 list=`git ls-files --modified --deleted $git_root_dir`
		 preview='git diff --color=always {} | sed "1,4d"'
		 preview_title="[ Diff ]"
		 ;;
	  rm)
		 list=`git ls-files $git_root_dir`
		 preview_title="[ Preview ]"
		 ;;
	esac

	_fzf_complete \
	 --height="40%" \
	 --layout="reverse" \
	 --info=inline \
	 --preview-window="border-rounded" \
	 --prompt="> " \
	 --marker=">" \
	 --pointer="◆" \
	 --separator="─" \
	 --scrollbar="│" \
	 --no-info \
	 --bind "ctrl-y:execute-silent(readlink -f {} | xclip -selection clipboard)" \
	 --ansi \
     --no-sort \
	 --reverse \
	 --preview "$preview" \
	 --preview-label "$preview_title" \
	 --bind "enter:become([[ {1} == '*' ]] && echo {2} || echo {1})" \
	 -- "$@" < <(echo "$list")
}
