# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration


configure_nvims() {
	alias nl="NVIM_APPNAME=LazyNvim nvim"
	alias nk="NVIM_APPNAME=kickstart nvim"
	alias nc="NVIM_APPNAME=NvChad nvim"
	alias na="NVIM_APPNAME=AstroNvim nvim"

	function nvims() {
	  items=("default" "kickstart" "LazyNvim" "NvChad" "AstroNvim")
	  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
	  if [[ -z $config ]]; then
	    echo "Nothing selected"
	    return 0
	  elif [[ $config == "default" ]]; then
	    config=""
	  fi
	  NVIM_APPNAME=$config nvim $@
	}

	bindkey -s ^a "nvims\n"
}

configure_project_aliases() {
	alias br="~/code/alle-backend-rewards"
	alias fe="~/code/alle-frontend"
	alias brc="~/code/alle-backend-rewards-checkout"
	alias bst="~/code/alle-backend-service-transactions"
}

configure_db() {
	alias db_local="db local"
	alias db_dev="db dev"
	alias db_dev2="db dev2"
	alias db_stage="db stage"
	alias db_demo="db demo"

	function db() {
	  items=("local" "dev" "dev2" "stage" "demo")
	  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" DB Connection Selector  " --height=~50% --layout=reverse --border --exit-0)
	  if [[ -z $config ]]; then
	    echo "Nothing selected"
	    return 0
	  fi

	  echo $fg_bold[cyan]"Selected environment "$fg_bold[magenta]"${config}"$reset_color"."

	  if [[ "x${config}x" == "xlocalx" ]]; then
	  	ENVIRONMENT=local
	  	USER_NAME=postgres
	  	ENDPOINT=localhost
	  	TOKEN=postgres
	  	echo $fg[magenta]"Ensuring ${ENVIRONMENT} Docker DB is up before connecting to Postgres command-line client..." $reset_color
	  	cat << EOF
Try this line to connect to the DB in case it doesn't work the first time:
DOCKER_DEFAULT_PLATFORM=amd/x64 docker-compose up -d db && psql "host=\$ENDPOINT port=5432 dbname=postgres user=\$USER_NAME password=\$TOKEN"

EOF
	  	DOCKER_DEFAULT_PLATFORM=amd/x64 docker-compose up -d db && psql "host=$ENDPOINT port=5432 dbname=postgres user=$USER_NAME password=$TOKEN"
	  else
	    ENVIRONMENT="alle-${config}"
	    autoload colors; colors
        echo $fg_bold[yellow]"\n~~ Ensure you have a profile named ${ENVIRONMENT} in ~/.aws/config, and that you are connected to ${config} on AWS VPN. ~~\n"$reset_color

	    USER_NAME=iam_readonly_role
	    ENDPOINT=$(aws-vault exec $ENVIRONMENT -- aws rds describe-db-proxies --db-proxy-name alle-shared-iam-auth --region us-west-2 --query 'DBProxies[0].Endpoint' --output text)
	    echo $fg[magenta]"Requesting AWS DB token via endpoint ${ENDPOINT}..."$reset_color
	    TOKEN=$(aws-vault exec $ENVIRONMENT -- aws rds generate-db-auth-token --hostname $ENDPOINT --port 5432 --region us-west-2 --username $USER_NAME)
	    echo "\nObtained access token:\n${TOKEN}"
	    echo "\n"$fg[magenta]"Connecting to ${ENVIRONMENT} Postgres command-line client..."$reset_color
	    psql "host=$ENDPOINT port=5432 sslmode=verify-full sslrootcert=/tmp/AmazonRootCA1.pem dbname=loyalty user=$USER_NAME password=$TOKEN"
	  fi
	}

	bindkey -s ^b "db\n"
}

configure_nvims
configure_project_aliases
configure_db
export PATH=/opt/homebrew/bin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:/usr/local/bin:~/.pyenv/bin:$PATH

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm
export PATH="/Users/wadhwlr/Library/Application Support/fnm:$PATH"
eval "`fnm env`"

# Set/refresh alle-backend-rewards NPM_TOKEN from 1Password
# Checks if 1Password CLI is installed and logged into ADL account
get_npm_token_abr() {
	# Verify 1Password CLI is installed
	if [ "x$(command -v op)" = "x" ]; then
		cat << EOF

The 1Password CLI is not available. Download and install at https://developer.1password.com/docs/cli/get-started#install\n

EOF
		return
	fi

	# Check if the 1Password CLI has previously logged in to the ADL account
	if [[ "$(op account list | grep team_adl | wc -l | tr -d " ")" == "0" ]]; then
		cat << EOF

The 1Password CLI is not logged in to the ADL account. Login using one of the following methods:
1) eval \$(op signin)
2) op account add (instructions at https://developer.1password.com/docs/cli/sign-in-manually)
3) Use the desktop 1Password app (instructions at https://developer.1password.com/docs/cli/get-started/#sign-in)

EOF
		return
	fi

	# Log in to 1Password ADL account if needed
	if  [[ $(op whoami 2>&1) == \[ERROR\]* ]]; then
		echo "\nSigning into 1Password..."
		eval $(op signin)
	fi

	echo "\nFetching latest NPM token..."
	export NPM_TOKEN=$(op item list --categories "api credential" --tags npm_token,latest --format json | op item get --fields label=credential)
	echo "\nTo make the latest NPM token available in new shell sessions, add the following line to your login shell script (normally ~/.bashrc, ~/.zshrc, or ~/.profile):\n"
	echo "export NPM_TOKEN=\"${NPM_TOKEN}\"\n"
}

export NPM_TOKEN="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"

# set PYTHON for Docker builds with Node 14.x
export PYTHON=/usr/bin/python3
alias python="python3"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# set puppeteer flags for Docker builds on M1 Macs
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

# install Python using pyenv https://adl-technology.atlassian.net/wiki/spaces/CONSMR/pages/3006922859/Alle+Backend+Rewards+Yarn+Install
setup_pyenv() {
	command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
}