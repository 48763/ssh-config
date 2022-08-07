check_arg() {

    if [ ! "${ERR}" = "" ]; then
        echo -e "${ERR#*: }\n"
        # Optimize error message.
        exit 1
    fi

    if [ "$(( ${2} * 2 ))" -gt "${ARGC}" ]; then
        echo -e "Missing variable(s), requires ${2} variable(s).\n"
        echo -e "${1}"
        exit 1
    fi
}

manual_set_args() {
    
    check_arg "${1}" "${2}"
    shift 3

    while true;
    do
        case ${1} in

            -a|--ip-address)
                ip_address=${2}
                shift 2
            ;;

            -f|--folder)
                folder=${2}
                shift 2
            ;;

            -g|--gen-key)
                if [ ! "${identity_file}" ]; then
                    gen_key=true
                fi
                shift 1
            ;;

            -h|--host)
                host=${2}
                shift 2
            ;;

            -i|--identity)
                identity_file=${2}
                gen_key=
                shift 2
            ;;

            -p|--port)
                port=${2}
                shift 2
            ;;

            -r|--remote-append)
                test_connect=true
                remote_append=true
                shift 1
            ;;

            -t|--test-connect)
                test_connect=true
                shift 1
            ;;

            -u|--user)
                user=${2}
                shift 2
            ;;

            "")
                folder=${folder:=default}
                break
            ;;

            --help|*)
                OPT="help"
                break
            ;;
        esac

    done
}

aws_set_args() {
    echo set_args

    check_arg "${1}" "${2}"
    shift 4

    while true;
    do
        case ${1} in

            -i|--identity)
                identity_file=${2}
                shift 2
            ;;

            -P|--public)
                public=${2:-"true"}
                shift 1
            ;;

            -p|--profile)
                profile_name=${2}
                shift 2
            ;;

            -r|--region)
                region=${2}
                shift 2
            ;;
            
            -t|--test-connect)
                test_connect=true
                shift 1
            ;;
            
            -u|--user)
                user=${2}
                shift 2
            ;;

            "")
                profile=${profile:=default}
                break
            ;;

            --help|*)
                OPT="help"
                break
            ;;
        esac

    done
}