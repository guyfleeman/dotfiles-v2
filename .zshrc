# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
USERNAME=`whoami`
export ZSH=/home/$USERNAME/.oh-my-zsh

source $HOME/.zsh_aliases

if hostname | grep "tmpo"; then
	DEFAULT_USER="wstuckey3-gtri"
else
	DEFAULT_USER="guyfleeman"
fi

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git vi-mode)

# disable nice visuals in kernel TTYs
if [ "$TERM" = "xterm-256color" ]; then
	ZSH_THEME="powerlevel9k/powerlevel9k"
	POWERLEVEL9K_MODE='nerdfont-complete'
	POWERLEVEL9K_CONTEXT_TEMPLATE="%n"
	POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
	POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
	POWERLEVEL9K_DIR_SHOW_WRITABLE=true
	POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
	POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time vi_mode background_jobs)
	
	POWERLEVEL9K_VI_NORMAL_MODE_STRING="N"
	POWERLEVEL9K_VI_INSERT_MODE_STRING="I"

	ZLE_RPROMPT_INDENT=-1
else
        ZSH_THEME="af-magic"
fi

export IRCNICK=guyfleeman
export USER=guyfleeman
export IRCNAME=guyfleeman
export IRCSERVER=irc.oftc.net

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

source $ZSH/oh-my-zsh.sh

# User configuration

# don't verify history expansion before execution
unsetopt histverify

# don't share history
unsetopt sharehistory

if [ -d "$HOME/.cargo/bin" ]; then
	export PATH=$HOME/.cargo/bin:$PATH
fi

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
