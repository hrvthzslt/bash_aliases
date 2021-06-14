function dnames-fn {
	for ID in `docker ps | awk '{print $1}' | grep -v 'CONTAINER'`
	do
    	docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function dip-fn {
    echo "IP addresses of all named running containers"

    for DOC in `dnames-fn`
    do
        IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC"`
        OUT+=$DOC'\t'$IP'\n'
    done
    echo -e $OUT | column -t
    unset OUT
}

function dex-fn {
	docker exec -it $1 ${2:-bash}
}

function di-fn {
	docker inspect $1
}

function dl-fn {
	docker logs -f $1
}

function drun-fn {
	docker run -it $1 $2
}

function dcr-fn {
	docker-compose run --rm $@
}

function dsr-fn {
	docker stop $1;docker rm $1
}

function drmc-fn {
       docker rm $(docker ps --all -q -f status=exited)
}

function drmid-fn {
       imgs=$(docker images -q -f dangling=true)
       [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

# in order to do things like dex $(dlab label) sh
function dlab {
       docker ps --filter="label=$1" --format="{{.ID}}"
}

function dc-fn {
        docker-compose $*
}

function d-aws-cli-fn {
    docker run \
           -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
           -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
           -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
           amazon/aws-cli:latest $1 $2 $3
}

function kill-port {
       PS3='Please enter your choice: '
       options=$(lsof -PiTCP -sTCP:LISTEN | awk '{print $9}' | sed -n '1!p')
       RED='\033[0;31m'
       NC='\033[0m' # No Color
       select port in $options
       do
       echo "Selected character: $port"
       echo "Selected number: $REPLY"
       var2=$(echo $port | cut -f2 -d:)
       echo -e "killing ${RED}port $var2 ${NC}!"
       echo $(lsof -ti tcp:$var2 | xargs kill)
       exit 0
       done
}

alias daws=d-aws-cli-fn
alias dc=dc-fn
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dcr=dcr-fn
alias dex=dex-fn
alias dcl="docker-compose logs -f"
alias dclt="docker-compose logs -f --tail 300"
alias di=di-fn
alias dim="docker images"
alias dip=dip-fn
alias dl=dl-fn
alias dnames=dnames-fn
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drmc=drmc-fn
alias drmid=drmid-fn
alias drun=drun-fn
alias dsp="docker system prune --all"
alias dsr=dsr-fn

alias sail="bash vendor/bin/sail"

alias cz="npx cz"
alias czr="npx cz --retry"

alias n="npm"
alias nr="npm run"

alias gush="git push"
alias gushf="git push -f"
alias gull="git pull"
alias getch="git fetch --all"
alias gout="git checkout"
alias goutf="git checkout -f"
alias granch="git branch"
alias granchr="git branch --remote"
alias gelete="git branch -d"
alias gsub="git submodule"
alias gsubinit="git submodule update --init --recursive"

alias kport=kill-port
