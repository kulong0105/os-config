# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#alias google-chrome_skydata="google-chrome --proxy-pac-url=http://x.tu26.net/t/4mdlktt.pac &> /dev/null"
alias google-chrome_skydata="google-chrome --proxy-server=\"http://127.0.0.1:8118;https://127.0.0.1:8118\"" 

alias c="conda"
alias s="ssh"

alias ll="ls -al"
alias l="ls -al"
alias lt="ll --full-time -t"

alias blog="bundle exec jekyll s"
alias ..="cd .. && ls"
alias ...="cd ../.. && ls"
alias ....="cd ../../../ && ls"

alias gg="git grep --color -n"
alias gpr="git pull --rebase"
alias gd="git diff HEAD"
alias gr="git rebase HEAD~10"
alias gs="git st"
alias gl="git lg"
alias ga="git add -u"
alias gc="git ci -m"

alias tl="tmux ls"
alias ta="tmux a"

alias net="systemctl restart NetworkManager.service"
alias ipl="sudo iptables -L -n -v --line-numbers"

alias dg="dmesg| grep -Ei"
alias grep='grep --color --exclude=cscope.out --exclude=tags'
alias g='grep -E -I'
alias gi='grep -E -Ii'
alias gr='grep -E -Ir'
alias gir='grep -E -Iir'
alias gf='find . -type f -print0 | xargs -0 grep -E'
alias gh='history 0 | grep -E'
alias pss='processes=`ps aux`; echo "$processes" | head -n1; echo "$processes" |grep -E'

alias sd='find -maxdepth 1 -print0 |xargs -0i du -ks {} |sort -rn |head -11 | cut -f2 | xargs -i du -hs {}'
alias sc='sort | uniq -c | sort -nr | more'

export PATH="/home/renyl/SkyDiscovery/bin:$PATH"

eval $(thefuck --alias)
