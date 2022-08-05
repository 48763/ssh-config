#!/bin/bash

set_args() {
    echo set_args

    check_arg "${1}" "${2}"
    shift 3

    while true;
    do
        case ${1} in

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
            set_args "Usage: ${0} add [-a| --address ip_address] [-f| --folder folder_name] \
            \n		  [-i| --identity identity_file] [-t| --test-connect] \
            \n		  [-u| --user login_name] [options]" \
            4 ${@}

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

