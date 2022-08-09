#!/bin/bash
source args.sh
source file-ctl.sh

aws_get_json() {
    # VPC all or single
    aws ec2 describe-instances \
        ${address:+--filters Name=ip-address,Values=*} \
        --query "Reservations[*].Instances[*].{
            Name:Tags[?Key=='Name']|[0].Value,
            IP:${address:=PrivateIpAddress},
            key:KeyName,
            AZ:Placement.AvailabilityZone
            }" \
        --region ${region} \
        --profile ${profile} \
        --output json 2> /dev/null
}

get_json_value() {
    echo -e "${1}" | jq -r ".[${2}][0].${3}"
}

aws_set_region() {
    region=${region:=${AWS_REGION}}
}

aws_append_local_cfg() {

    aws_append_local_main_cfg
    aws_append_local_sub_cfg "${1}"
}

aws_append_local_main_cfg() {

    if ! file_exist "${SSH_CONFIG_DIR}/config"; then
        create_file ${SSH_CONFIG_DIR}/config
    fi

    if ! cfg_exist "include ${folder}/" "${SSH_CONFIG_DIR}/config"; then
        echo "include ${folder}/config" >>  ${SSH_CONFIG_DIR}/config
    fi
}

aws_append_local_sub_cfg() {
    echo aws_append_local_sub_cfg

    if ! file_exist "${SSH_CONFIG_DIR}/${folder}/config"; then

        if ! folder_exist "${SSH_CONFIG_DIR}/${folder}"; then
            create_folder "${SSH_CONFIG_DIR}/${folder}"
        fi

        create_file "${SSH_CONFIG_DIR}/${folder}/config"
    fi

    region=${region//-/_}
    :> ${SSH_CONFIG_DIR}/${folder}/config

    index=$(echo ${1} | jq length )
    while [ ${index:=0} -gt 0 ]
    do
        index=$(( ${index} - 1 ))

        cfg="Host ${!region}$(get_json_value "${1}" ${index} Name)\n"
        cfg="${cfg}    HostName $(get_json_value "${1}" ${index} IP)\n"
        # User Map
        cfg="${cfg}    User ${user:=${AWS_USER}}\n"
        cfg="${cfg}    IdentityFile ${AWS_KEY_DIR}/$(get_json_value "${1}" ${index} key)\n"

        echo -e "${cfg}" >> ${SSH_CONFIG_DIR}/${folder}/config
    done
}

aws_gen() {

    json=$(aws_get_json)
    if [ $? -ne 0 ]; then 
        echo "Aws command line execute fail."
        echo -e "${help}"
        exit 1
    fi

    if ! folder_exist "${SSH_CONFIG_DIR}"; then
        create_folder ${SSH_CONFIG_DIR}
    fi

    aws_append_local_cfg "${json}"
}

aws_cmd() {

    case "${2}" in
        gen)
            help="Usage: ${0} ${1} ${2} [-i| --identity identity_file] [-P| --public true|false] \
            \n		      [-p| --profile profile_name] [-r| --region region_name] \
            \n		      [-t| --test-connect] [-u| --user login_name] \
            "

            aws_set_args 1 ${@}
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
