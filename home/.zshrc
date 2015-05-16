PATH="/usr/local/sbin:${PATH}"

# Sets vi mode for shell
set -o vi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Aliases
alias subl="/usr/bin/subl"
alias pro="cd ~/Documents/projects"
alias mongodb="mongod --config /usr/local/etc/mongod.conf"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(brew docker gem git git-extras gitfast macports mercurial meteor npm osx pip python rvm vagrant virtualenvwrapper)

source $ZSH/oh-my-zsh.sh

PATH="$HOME/bin/android-sdk/tools:$HOME/bin/android-sdk/platform-tools:$PATH"
export PATH

# Docker
(boot2docker shellinit) &> /dev/null

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# virtualenv
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

export CC=/usr/bin/gcc
export CXX=/usr/bin/g++

# Customize to your needs...
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:usr/local/git/bin:/usr/X11/bin:$PATH

# Install grunt plugins
function gi() {
    npm install --save-dev grunt-"$@"
}
function gci() {
    npm install --save-dev grunt-contrib-"$@"
}

# Install Gulp plugins and add them as `devDependencies` to `package.json`
# Usage: `gp uglify clean cache csso`
function gpi() {
        npm install --save-dev ${*/#/gulp-}
}

# Install bower packages
function bi() {
    bower install --save "$@"
}

# Makes a directory and changes to it
function md() {
    mkdir "$@"
    cd "$@"
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
        local port="${1:-8000}"
        open "http://localhost:${port}/"
        # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
        # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
        python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# A better git clone
# clones a repository, cds into it, and opens it in my editor.
#
# Based on https://github.com/stephenplusplus/dots/blob/master/.bash_profile#L68 by @stephenplusplus
#
# Note: subl is already setup as a shortcut to Sublime. Replace with your own editor if different
#
# - arg 1 - url|username|repo remote endpoint, username on github, or name of
#           repository.
# - arg 2 - (optional) name of repo
#
# usage:
#   $ clone things
#     .. git clone git@github.com:addyosmani/things.git things
#     .. cd things
#     .. subl .
#
#   $ clone yeoman generator
#     .. git clone git@github.com:yeoman/generator.git generator
#     .. cd generator
#     .. subl .
#
#   $ clone git@github.com:addyosmani/dotfiles.git
#     .. git clone git@github.com:addyosmani/dotfiles.git dotfiles
#     .. cd dots
#     .. subl .
function clone {
  # customize username to your own
  local username="raddevon"

  local url=$1;
  local repo=$2;

  if [[ ${url:0:4} == 'http' || ${url:0:3} == 'git' ]]
  then
    # just clone this thing.
    repo=$(echo $url | awk -F/ '{print $NF}' | sed -e 's/.git$//');
  elif [[ -z $repo ]]
  then
    # my own stuff.
    repo=$url;
    url="git@github.com:$username/$repo";
  else
    # not my own, but I know whose it is.
    url="git@github.com:$url/$repo.git";
  fi

  git clone $url $repo && cd $repo && atom .;
}

# Copy w/ progress
function cp_p () {
  rsync -WavP --human-readable --progress $1 $2
}

# prune a set of empty directories
function prunedir () {
   find $* -type d -empty -print0 | xargs -0r rmdir -p ;
}

# Launch installed browsers for a specific URL
# Usage: browsers "http://www.google.com"
function browsers(){
        chrome $1
        opera $1
        firefox $1
        safari $1
}

# Convenience functions for vim configuration
function vimp() {
    changed=false
    for plugin
    do
        if grep -q "$plugin" ~/.vimrc.bundles*
        then
            echo "$plugin already installed"
        else
            echo "Adding $plugin to bundles config"
            echo Bundle \"$plugin\" >> ~/.vimrc.bundles.local
            changed=true
        fi
    done
    if [ $changed = true ]
    then
        vim "+BundleInstall!" "+BundleClean" +qa
        echo "Plugin installation complete"
    else
        echo "No plugins installed"
    fi
}

function vims() {
    echo "$1" >> ~/.vimrc.local
    echo "Added to .vimrc.local"
}

# Allow mapping Ctrl-S in Vim
alias vim="stty stop '' -ixoff ; vim"
# `Frozing' tty, so after any command terminal settings will be restored
ttyctl -f

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
        colorflag="--color"
else # OS X `ls`
        colorflag="-G"
fi

# List all files colorized in long format
alias l="ls -l ${colorflag}"

# List all files colorized in long format, including dot files
alias la="ls -la ${colorflag}"

# List only directories
alias lsd='ls -l | grep "^d"'

# Always use color output for `ls`
if [[ "$OSTYPE" =~ ^darwin ]]; then
        alias ls="command ls -G"
else
        alias ls="command ls --color"
        export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
fi

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# NVM
[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh # This loads NVM

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Syntax highlight and copy to clipboard
function light() {
  if [ -z "$2" ]
    then src="pbpaste"
  else
    src="cat $2"
  fi
  $src | highlight -O rtf --syntax $1 --font Inconsolata --style moria --font-size 24 | pbcopy
}

# Adds Z for quick directory hopping
. `brew --prefix`/etc/profile.d/z.sh

# Meteor with settings alias
alias meteorset='meteor --settings settings.json'

# Type 'fuck' after messing up a command to try to find the correct command
alias fuck='$(thefuck $(fc -ln -1))'

# Sets tmux color mode
[ -z "$TMUX" ] && export TERM=xterm-256color

# homeshick for putting dotfiles under version control
source $HOME/.homesick/repos/homeshick/homeshick.sh

# Imports secret environment variables
source ~/.envsecrets
