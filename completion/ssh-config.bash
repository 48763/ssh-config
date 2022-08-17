_ssh_config_ssh_config() {
    case "$cur" in 
        -*)
            COMPREPLY=( $(compgen -W "" ) )
        ;;
        *)
            COMPREPLY=( $(compgen -W "${commands[*]}" -- "$curl" ) )
        ;;
    esac
}

_ssh_config_aws() {
    case "$cur" in 
        -*)
            COMPREPLY=( $(compgen -W "" ) )
        ;;
        *)
            COMPREPLY=( $(compgen -W "gen delete help" -- "$curl" ) )
        ;;
    esac
}

_ssh_config_common() {
    case "$cur" in 
        -*)
            COMPREPLY=( $(compgen -W "" ) )
        ;;
        *)
            COMPREPLY=( $(compgen -W "add delete help list update" -- "$curl" ) )
        ;;
    esac
}

_ssh_config_gcp() {
    case "$cur" in 
        -*)
            COMPREPLY=( $(compgen -W "" ) )
        ;;
        *)
            COMPREPLY=( $(compgen -W "${commands[*]}" -- "$curl" ) )
        ;;
    esac
}

_ssh_config_help() {
    case "$cur" in 
        -*)
            COMPREPLY=( $(compgen -W "" ) )
        ;;
        *)
            COMPREPLY=( $(compgen -W "${commands[*]}" -- "$curl" ) )
        ;;
    esac
}

_start_ssh_config() {
    local commands=(
        aws
        common
        gcp
        help
    )

    local cur prev words cword
    _get_comp_words_by_ref -n : cur prev words cword
    #echo cur: $cur, prev: $prev, words: ${words[*]}, cword: $cword

    local command='ssh_config'
    local counter=1

    while [ $counter -lt $cword ]; do
        #echo $counter ${words[$counter]}
        case "${words[$counter]}" in
            $prev)
                command="${words[$counter]}"
                #echo command=${words[$counter]}
                break
        esac
        (( counter++ ))
    done

    local completions_func=_ssh_config_${command//-/_}
    #echo $completions_func
    declare -F $completions_func >/dev/null && $completions_func
    #complete -W "aws common gcp help" ssh-config

    return 0
}

complete -o default -F _start_ssh_config ssh-config
