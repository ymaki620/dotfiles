# zshrc

# for local zshrc
test -r ~/.zshrc && . ~/.zshrc

# zsh history
# 
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY

# environment variable
export LANG=ja_JP.UTF-8

# alias
case ${OSTYPE} in
    darwin*)
        # Mac OS X
        alias ls='ls -G'
        ;;
    linux*)
        # Linux
        alias ls='ls --color=auto'
        ;;
esac

# setting prompt
if [ -z "$MYENV" ]; then
    MYENV=`uname -s`
fi
case ${OSTYPE} in
    darwin*)
        PROMPT="%F{cyan}[%n@${MYENV}]%f %c %# "
        ;;
    linux*)
        PROMPT="%F{green}[%n@${MYENV}]%f %c %# "
        ;;
esac

function rprompt-git-current-branch {
  local branch_name st branch_status

  branch='\ue0a0'
  color='%{\e[38;5;'
  green='114m%}'
  red='001m%}'
  yellow='227m%}'
  blue='033m%}'
  reset='%{\e[0m%}'

  if [ ! -e  ".git" ]; then
    echo "[%D %*]"
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全て commit されてクリーンな状態
    branch_status="${color}${green}${branch} "
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # git 管理されていないファイルがある状態
    branch_status="${color}${red}${branch} ?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git add されていないファイルがある状態
    branch_status="${color}${red}${branch} +"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commit されていないファイルがある状態
    branch_status="${color}${yellow}${branch} !"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "${color}${red}${branch} !(no branch)${reset}"
    return
  else
    # 上記以外の状態の場合
    branch_status="${color}${blue}${branch}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}$branch_name${reset}"
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプトの右側にメソッドの結果を表示させる
RPROMPT='`rprompt-git-current-branch`'
