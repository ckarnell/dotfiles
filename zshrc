export PYTHONPATH=.
export NODE_PATH=/usr/local/lib/node_modules
# List colors
# export LSCOLORS=ExFxCxDxBxegedabagacad
# For yellow directories use this instead:
# export LSCOLORS=dxfxcxdxbxegedabagacad
export CLICOLOR=1

# Always use current version of python's pip
alias pip='python -m pip'

alias rm='rm -i' # Don't default to forced rm
alias mv='mv -i' # Don't default to mv clobbering files
alias neodel="find . -type f -name '*@neomake_*.*' -delete"

# Show current dir in bash line
# Not necessary with bash-it, I guess
# [ -z "$PS1" ] && return
# PS1="\w> "

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
# export PATH="/usr/local/bin:${PATH}" # Changed wile trying to fix python. Fix eslint?
# Virtual environment source
# export WORKON_HOME=$HOME/.virtualenvs
# export PYTHONPATH=. # Changed wile trying to fix python
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2.7 # THIS FINALLY FUCKING DID IT
# source /usr/local/bin/virtualenvwrapper.sh

# Some sensible settings:
# Perform file completion in a case insensitive fashion
# bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
# bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
# bind "set show-all-if-ambiguous on" # This was annoying with git completion
# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '
# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null # Doesn't seem to work
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# These are commmented out because they cause an error on bash tab load
# # Tmux configuration source
# tmux source ~/.tmux.conf
# # Tmux alias for 256 colors
alias tmux="tmux -2"

# Tmux related bindings
# Create tmux session
function tms {
  if [ $# -eq 0 ]
    then
      echo "No arguments supplied"
    else
      tmux new-session -s $1
  fi
}

# Kill tmux session
function tmk {
  if [ $# -eq 0 ]
    then
      echo "No arguments supplied"
    else
      tmux kill-session -t $1
  fi
}
alias tml="tmux list-sessions"
alias tma="tmux attach"

# Use this to access rememeber file
alias rem="vim ~/Desktop/learning/spark_specific/remember.txt"
alias auh="alembic upgrade head"
alias auhs="alembic upgrade heads"
alias rauh="PYTHONPATH=. SPARK_ENVIRONMENT=development POSTGRESQL_URL=postgresql://localhost:1612/db alembic -x with-data upgrade head"
alias dauh='docker exec spark_scout-flask_1 sh -c "alembic -x with-data upgrade head"'
alias dauhp='docker exec spark_pilot-flask_1 sh -c "alembic -x with-data upgrade head"'
alias dauhs='docker exec spark_scout-flask_1 sh -c "alembic -x with-data upgrade heads"'
alias dahs='docker exec spark_scout-flask_1 sh -c "alembic heads"'
alias damh='docker exec spark_scout-flask_1 sh -c "alembic merge heads"'
alias av='alembic-viz --filename alemvizzy --format pdf; open alemvizzy.png'
alias dadb='docker exec spark_scout-flask_1 sh -c "alembic downgrade base"'
alias entryp="docker-compose run --entrypoint bash pilot-flask"
alias entry="docker-compose run --entrypoint bash svs-flask"
alias entrysc="docker-compose run --entrypoint bash scout-flask"

# Alembic downgrade by number
function ad {
  if [ -z "$1" ]
  then
    alembic downgrade -1
  else
    alembic downgrade -$1
  fi
}

# Docker alembic downgrade by number
function dad {
  if [ -z "$1" ]
  then
    docker exec spark_scout-flask_1 sh -c "alembic downgrade -1"
  else
    docker exec spark_scout-flask_1 sh -c "alembic downgrade -$1"
  fi
}

# Docker autogenerate migration, or merge heads if no message is provided
function darag {
  if [ -z "$1" ]
  then
    docker exec spark_scout-flask_1 sh -c "alembic merge heads"
  else
    docker exec spark_scout-flask_1 sh -c "alembic revision --autogenerate -m \"$1\""
  fi
}
function daragp {
  if [ -z "$1" ]
  then
    docker exec spark_pilot-flask_1 sh -c "alembic merge heads"
  else
    docker exec spark_pilot-flask_1 sh -c "alembic revision --autogenerate -m \"$1\""
  fi
}

alias pips='pipenv shell'
# Aptible login set to a week
alias aptiblelogin='aptible login --lifetime=7d'

# Set the project dir and make it easy to get there
export PROJECTDIR="/Users/cohen/spark"
alias pd="cd $PROJECTDIR"
alias pcp="pwd|pbcopy"
alias envs="env | LC_ALL=C sort"


# Make ag easier to use while ignoring unwanted directories
alias agnore="ag --ignore-dir node_modules --ignore-dir .git"

# Add sbin to path, particularly to allow rabbitmq-server to run
PATH=$PATH:/usr/local/sbin
PATH=$PATH:/usr/local/bin
PATH="$PATH:/Users/cohenkarnell/Downloads/Visual\ Studio\ Code.app/Contents/Resources/app/bin"

# Use macvim instead of normal vim for the terminal
alias vim="mvim -v"
# alias vim='/path/to/MacVim.app/Contents/MacOS/Vim'
# Source this file
alias sb="source ~/.bashrc"
# Edit this file
alias vb='vim ~/.bashrc'
# Source tmux
alias st="tmux source-file ~/.tmux.conf"
# Edit .vimrc
alias vv='mvim ~/.vimrc'

# Alias for ctags since it was installed with homebrew
export PATH="/opt/homebrew/bin:$PATH"
alias ctags="`brew --prefix`/bin/ctags --python-kinds=-i"
# This command gets tags for site-packages: ctags -R -f ./tags `python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()`

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# This is needed for scss-lint to work in vim!
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Add capability to rename tabs
# Taken from here: https://makandracards.com/makandra/21369-set-the-title-of-your-terminal-tab-bash
function t_title {
  if [ -z "$1" ]
  then
    title=${PWD##*/} # current directory
  else
    title=$1 # first param
  fi
  echo -n -e "\033]0;$title\007"
}

function gpsu {
  if [ "$(git rev-parse --abbrev-ref HEAD)" = "master" ]; then
    echo "Cannot push to master!"
  else
    git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
  fi
}


# Fancy git log. Takes one argument which is the number of parent commits to display
function glg {
  if [ -z "$1" ]
  then
    git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all
  else
    git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all -$1
  fi
}

# Fancy git log. Takes one argument which is the number of parent commits to display
function gl {
  if [ -z "$1" ]
  then
    git log --pretty=format:'%C(bold blue)%h %C(bold green)(%ar) %C(magenta)%an %Creset%s%C(bold yellow)%d'
  else
    git log --pretty=format:'%C(bold blue)%h %C(bold green)(%ar) %C(magenta)%an %Creset%s%C(bold yellow)%d' -$1
  fi
}

# Run pre-commit on all the files changed in the last x number of commits, defaulting to 1
function pcr {
  if [ -z "$1" ]
  then
    pre-commit run --files $(git diff --name-only HEAD HEAD^)
  else
    pre-commit run --files $(git diff --name-only HEAD HEAD~$1)
  fi
}

# Git diff, name only. Takes one argument which is the number of commits to go back
function gdno {
  if [ -z "$1" ]
  then
    git diff --name-only HEAD HEAD^
  else
    git diff --name-only HEAD HEAD~$1
  fi
}

# Git bindings
# Prioritize the shorter aliases on the more common commands
alias gpsunv='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD) --no-verify'
alias gpfnv='git push --force --no-verify'
alias ga='git add -A'
alias gs='git status'
alias gst='git stash'
alias gstp='git stash pop'
alias gb='git branch'
alias gfo='git fetch --prune origin'
alias gfor='git fetch origin && git rebase origin/master'
alias grom='git rebase origin/main'
alias gpr='git pull --rebase'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
# alias gc='git commit'
alias gca='git commit --amend'
alias gac='git add -A && git commit'
alias gaca='git add -A && git commit --amend'
alias gacan='git add -A && git commit --amend --no-edit'
alias gprp='git fetch origin && git add -A && git commit --amend --no-edit && git push -f'
alias gacap='git add -A && git commit --amend --no-edit && git push -f'
alias gacapnv='git add -A && git commit --amend --no-edit && git push -f --no-verify'
alias gacapsu='git add -A && git commit --amend --no-edit && git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias gpl='git pull'
alias gps='git push'
alias gpf='git push -f'
# alias gpsu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gast='git add -A && git stash'
# Delete local branches that have been merged into the currently checked out branch
alias gbd='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
alias gbD='git branch | grep -v "master" | xargs git branch -D'
alias grH='git reset HEAD'
alias grH^='git reset HEAD^'
alias gacm='git add -A && git commit -n -m "TEMP COMMIT"'
alias gcm='git commit -n -m "TEMP COMMIT"'
# Show a history of branches you've checked out
alias gfef="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) - %(color:red)%(objectname:short)%(color:reset)'"
# Add only untracked files to the index
alias au='echo -e "a\n*\nq\n"|git add -i'
alias gclean='git checkout -q master && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'
alias update='gco master && gfo && grom'

# Used for dockerized development
export COMPOSE_HTTP_TIMEOUT=120

# Spark specific bindings
alias inst='pip install -r requirements.txt; yarn install'
alias ts='workon ts'
alias ts3='workon ts3'
alias ts37='workon ts37'

# Docker bindings
alias dcs='docker-compose stop'
alias dcu='docker-compose up --build'
alias dcuscout='docker-compose up --build scout scout-flask'
alias dcupilot='docker-compose up --build pilot pilot-flask'
alias dcudispatch='docker-compose up --build dispatch dispatch-flask'
alias dcusvs='docker-compose up --build svs svs-flask'
alias dcssvs='docker-compose stop svs svs-flask'
alias dcsscout='docker-compose stop scout scout-flask'
alias dcspilot='docker-compose stop pilot pilot-flask'
alias dcrm='docker-compose rm -v pilot scout svs screenshot'
alias dsp='docker system prune -a --volumes'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# export SCM_GIT_SHOW_DETAILS=true
export FLASK_APP=/Users/cohenkarnell/spark/scout/run.py

# Aptible related bindings
alias sshstaging='aptible ssh --app pilot-staging'
alias sshprod='aptible ssh --app spark-prod'
alias sshprodrep='aptible ssh --app spark-prod-readonly'
alias stagingssh='aptible ssh --environment spark-staging --app spark-staging'
alias prodssh='aptible ssh --app spark-prod'
# alias stagingdb='aptible db:tunnel --port 1235 spark-staging-201906171416'
alias stagingdb='aptible db:tunnel "$(aptible db:list | grep --color=never spark-staging- | grep --color=never -v nightly | sort -r | head -n1)" --port 1233'
alias proddb='aptible db:tunnel spark-production --port 1236'
alias prodrepdb='aptible db:tunnel spark-production-read-only --port 1237'

# Yarn
alias upgrade-yarn='curl -o- -L https://yarnpkg.com/install.sh | bash'

# Graphql
alias ggts='yarn workspace @trialspark/scout generate-graphql-types'
alias ggtd='yarn workspace @trialspark/dispatch generate-graphql-types'

# Ag
alias ag='ag --hidden'

# nvm use 8.11.3
export PATH=$PATH:/Users/cohenkarnell/.tmp
alias ls='if [[ $(($RANDOM % 64)) -eq 0 ]]; then terminal-parrot -loops 3; fi; ls'

# Source variables
alias exp'=set -o allexport; source .env; set +o allexport'

function ysf() {
    yarn workspace @trialspark/$1 start-frontend
}
export LDFLAGS="-I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib"

# FROM spark_setup.sh
export PATH="/usr/local/sbin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export PATH="/usr/local/opt/ruby/bin:$PATH"
# # Get postgres executables on PATH. pg_config must be on path in order to install psycopg2
# export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
export PATH="/usr/local/opt/postgresql@13/bin:$PATH"
export LDFLAGS="-I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export VIRTUALENVWRAPPER_PYTHON=~/.pyenv/shims/python

export CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include"
export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib"

export OP_AUTH_ITEM_NAME_AWS="AWS"

### Included by formctl-setup
## formctl auth docker && poetry-token && npm-token
source '/Users/cohen/.config/formation-bio/zsh/zshrc'
# export DOTNET_ROOT=/opt/homebrew/opt/dotnet/libexec
# export PATH=/opt/homebrew/bin:$PATH
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$DOTNET_ROOT:$PATH"
# export MSBuildSDKsPath="$HOME/.dotnet/sdk/6.0.428/Sdks"

. "$HOME/.local/share/../bin/env"
# export VIMINIT='source ~/vim/vimrc'

# where your config lives
export VIMCFG="$HOME/dotfiles"

# Tell Vim to (a) use that runtime dir and (b) source that vimrc
export VIMINIT='
let $MYVIMRC = $VIMCFG . "/vimrc" |
execute "set runtimepath^=" . fnameescape($VIMCFG . "/vim") |
execute "set packpath^="   . fnameescape($VIMCFG . "/vim") |
execute "source " . fnameescape($MYVIMRC)
'
