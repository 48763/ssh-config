#!/bin/bash

set_args() {
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

check_arg() {
    echo check_arg

    if [ ! "${ERR}" = "" ]; then
        echo -e "${ERR#*: }\n"
        # Optimize error message.
        exit 1
    fi

    if [ "$(( ${2} * 2 ))" -gt "${ARGC}" ]; then
        echo -e "Missing variable(s).\n"
        echo -e "${1}"
    fi

}

aws_gen() {

    echo aws_gen
}

aws_cmd() {

    case "${2}" in
        # The parameterization needs to be modified.
        gen)
            set_args "Usage: ${0} add \
            \n		  [-i| --identity identity_file] \
            \n		  [-P| --public true|false] \
            \n		  [-p| --profile profile_name] \
            \n		  [-r| --region region_name] \
            \n		  [-t| --test-connect] \
            \n		  [-u| --user login_name] \
            "\
            1 ${@}

            aws_gen
        ;;

        delete)
            echo ${@}
        ;;

        help|*)
            echo -e "Usage: ${0} ${1} [OPTION] \n"
            echo "	gen		Generate aws host ssh config to folder."
            echo "	delete		Delete aws host ssh config in folder."
            echo "	help		Print command options."
        ;;
    esac
}

