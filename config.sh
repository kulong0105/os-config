#!/bin/bash -x

#Program:
#	config devlop env
#History:
#   renyl  2017/6/17   0.1v
#   initial version
#
#   renyl  2017/7/25   0.2v
#   create email dir and add return value check

#   renyl  2017/11/11   0.3v
#   add autojump setting

shopt -s dotglob

config_src=$(dirname $(readlink -e -v $BASH_SOURCE))

# config bash
cp -f $config_src/bash/.bashrc /home/renyl/.bashrc || exit

# config vim
sudo yum install -y ctags || exit
sudo cp -f  $config_src/vim/vimrc   /etc/vimrc || exit
mkdir -p /home/renyl/.vim
cp -a  $config_src/vim/.vim/*  /home/renyl/.vim/ || exit

# config ssh
mkdir -p /home/renyl/.ssh
cp -f  $config_src/ssh/config   /home/renyl/.ssh/config || exit

# config git
cp -f $config_src/git/.gitconfig   /home/renyl/.gitconfig || exit

# config tmux
rpm -q tmux || sudo yum install -y tmux || exit
cp -f  $config_src/tmux/.tmux.conf  /home/renyl/.tmux.conf || exit

# config mutt
rpm -q mutt || sudo yum install -y mutt || exit
rpm -q msmtp || sudo yum install -y msmtp || exit
rpm -q getmail || sudo yum install -y getmail || exit
rpm -q  procmail || sudo yum install -y procmail || exit

cp -a $config_src/mutt/*   /home/renyl/ || exit
mkdir -p /home/renyl/.mail/inbox/{cur,tmp,new} || exit
mkdir -p /home/renyl/.mail/mbox/{cur,tmp,new} || exit
mkdir -p /home/renyl/.mail/postponed/{cur,tmp,new} || exit
mkdir -p /home/renyl/.mail/tmp/{cur,tmp,new} || exit

# config autojump
sudo yum install -y autojump || exit

echo "=========completed==========="
