#!/bin/bash
source args.sh
source file-ctl.sh

aws_get_json() {
    echo aws_get_json
    aws ec2 describe-instances \
        --region ${region} \
        --profile ${profile} 2> /dev/null
    
}

aws_append_local_cfg() {
    echo aws_append_local_cfg
}

aws_gen() {
    echo aws_gen

    json=$(aws_get_json)
    if [ $? -ne 0 ]; then 
        echo faile
        #exit 1
    fi

    echo -e "return ${json}"
    aws_append_local_cfg
}

aws_cmd() {

    case "${2}" in
        gen)
            aws_set_args "Usage: ${0} add \
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
