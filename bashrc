#!/usr/bin/env bash
# testing
mkdir -p $HOME/tmp

DOT="$HOME/gits/timm/dot"
Files="bashrc tmux.conf gitignore vimrc"
GITS="$HOME/workspace $HOME/gits/[A-Za-z0-9_]*/[A-Za-z0-9_]*"

White="\033[00m"
Green="\033[01;32m"
Blue="\033[01;34m"
Yellow="\033[33m"

_c1="\[$Green\]"
_c2="\[$Blue\]"
_c3="\[\033[31m\]"
_c6="$Yellow"
_c5="\[\033[35m\]$"
_c0="\[${White}\]"
_c7="[\033]01;19\]"

ok() {
  if which $1 > /dev/null; then 
    true 
  else 
    echo ""
    echo "${Yellow}# ----| $1 |--------------------------------${White}"
    echo ""
    sudo apt-get -y install ${2:-$1}
  fi
}

ok mc
ok tree  
ok tmux  
ok ncdu
ok htop
ok clisp 
ok ranger
ok cmatrix
ok lua    lua5.2
ok gst    gnu-smalltalk
ok swipl  swi-prolog
ok robots bsdgames

clean() {
  sudo apt autoclean
  sudo apt-get clean
  sudo apt autoremove
}
bat0() {
  cd $HOME/tmp
  wget -nc https://github.com/sharkdp/bat/releases/download/v0.9.0/bat_0.9.0_amd64.deb
  sudo dpkg -i bat_0.9.0_amd64.deb
  rm  bat_0.9.0_amd64.deb
}
vim0() {
  echo -e "${Yellow}Vim8 update. Takes about a minute.${White}"
  read -t 10 -p "Continue? [Cnt-C to abort]"
  sudo add-apt-repository ppa:jonathonf/vim
  sudo apt update
  sudo apt-get upgrade vim
  clean
}
add2bash() {
  LINE=". $DOT/bashrc"
  FILE=$HOME/.bashrc
  grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
}
add2bash

for f in $Files; do
  g=$HOME/workspace/$f
  h=$HOME/.$f
  if [ -f "$g" ]; then
    if [ ! -f "$h" ]; then 
      echo "# $h"
      ln -sf $g $h 
    fi 
  fi
done
saves() {
  for d in $GITS; do
    if [ -d "$d" ]; then
      printf "\n${Yellow}#---| $d |-----------${White}\n"
      (cd $d
      git commit -am saving; git  push
      )
    fi
  done
}
here() { cd $1; basename "$PWD"; }

PROMPT_COMMAND='echo -ne "${_c6}\033]0;$(here ../..)/$(here ..)/$(here .)\007";PS1="${_c1}$(here ../..)/$_c2$(here ..)/$_c3$(here .) ${_c6}\!>${_c0}\e[m "'

alias ll='ls -GF'
alias get='git pull'
alias put='git commit -am saving; git push; git status'
alias gc="git config credential.helper 'cache --timeout=3600'"
alias vi=vim
