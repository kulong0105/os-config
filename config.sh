#!/bin/bash -x

#Program:
#	config devlop env
#History:
#	renyl  2017/6/17   0.1v

shopt -s dotglob

config_src=$(dirname $(readlink -e -v $BASH_SOURCE))

# config bash
cp -f $config_src/bash/.bashrc /home/renyl/.bashrc

# config vim
cp -f  $config_src/vim/vimrc   /etc/vimrc
mkdir -p /home/renyl/.vim
cp -a  $config_src/vim/.vim/*  /home/renyl/.vim/

# config ssh
cp -f  $config_src/ssh/config   /home/renyl/.ssh/config

# config git
cp -f $config_src/git/.gitconfig   /home/renyl/.gitconfig

# config tmux
rpm -q tmux || sudo yum install -y tmux
cp -f  $config_src/tmux/.tmux.conf  /home/renyl/.tmux.conf

# config mutt
rpm -q mutt || sudo yum install -y mutt
rpm -q msmtp || sudo yum install -y msmtp
rpm -q getmail || sudo yum install -y getmail
rpm -q  procmail || sudo yum install -y procmail

cp -a $config_src/mutt/*   /home/renyl/
mkdir -p /home/renyl/.mail/inbox/{cur,tmp,new}
mkdir -p /home/renyl/.mail/mbox/{cur,tmp,new}
mkdir -p /home/renyl/.mail/postponed/{cur,tmp,new}
mkdir -p /home/renyl/.mail/tmp/{cur,tmp,new}


echo "=========completed==========="
