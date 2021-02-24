# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme and plugin settings
DEFAULT_USER="wmatex"
BATTERY_GAUGE_FILLED_SYMBOL=""
BATTERY_GAUGE_EMPTY_SYMBOL=" "


#POWERLEVEL9K_MODE='awesome-fontconfig'

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="gentoo"
#ZSH_THEME="gallois"
#ZSH_THEME="wmatex"
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel9k/powerlevel9k"
#ZSH_THEME="gnzh"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git mercurial git-prompt vi-mode battery)
plugins=(git vi-mode systemd symfony gitfast zsh-autosuggestions zsh-syntax-highlighting composer bgnotify colored-man-pages colorize drush web-search)

ZSH_DISABLE_COMPFIX="true"

source $ZSH/oh-my-zsh.sh

# Powerline
#source /usr/share/zsh/site-contrib/powerline.zsh

# User configuration

zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

bindkey '^ ' autosuggest-accept

#export PATH="/home/wmatex/bin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
#export LANG="en_US.utf8"

unsetopt flowcontrol

set -o notify

# Multiple rename
autoload -U zmv

# Aliases
alias reboot="systemctl reboot"
alias poweroff="systemctl poweroff"
#alias hibernate="systemctl hibernate"
alias build-kernel="make -j5 && make install && make modules_install && grub-mkconfig > /boot/grub/grub.cfg"
alias update="emerge -DNuv --deep --with-bdeps=y --keep-going=y @world @system"
#alias use="vim /etc/portage/package.use/general"
alias psync="print Last portage sync: $(cat /usr/portage/metadata/timestamp)"
alias gt="git status -sb"
#alias music="ncmpcpp"
alias mmv='noglob zmv -W'
#alias udu='udiskie-umount -2'
alias matc='/opt/Matlab/R2014b/bin/matlab -nodesktop -nosplash'
#alias tmux='tmux -2'
alias gv='gwenview'
alias ytmp3='youtube-dl -x --audio-quality 0 --audio-format mp3'
alias drush='lando drush'

# Group directories in listing
alias ls='ls --color=tty --group-directories-first'

alias te='trans cs:en'
alias tc='trans en:cs'

# Try to use NeoVim instead of Vim for a while
alias vim='nvim'
alias gulp='node_modules/gulp/bin/gulp.js'

# Suffix aliases
alias -s {pdf}="okular"
alias -s {avi,mp4,mkv}="mpv"
alias -s {cc,h,c}="vim"
alias -s {gif,png,jpg,jpeg}="sxiv -a"

# Global aliases
alias -g L=" | less"
alias -g G=" | grep"

function precmd() (
  echo -ne '\a'
)

#ZSH_TMUX_AUTOSTART="true"


if [[ $EUID = 0 ]]; then
  psync
else
  fortune -a | cowsay -n
fi

# Always work in tmux session
#tmux attach -t hack || tmux new -s hack
