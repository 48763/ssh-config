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
        --profile ${profile:=default} \
        --output json 2> /dev/null
}

get_json_value() {
    echo -e "${1}" | jq -r ".[${2}][0].${3}"
}

aws_append_local_cfg() {
    #echo aws_append_local_cfg

    region=${region//-/_}

    index=$(echo ${1} | jq length )
    while [ ${index:=0} -gt 0 ]
    do
        index=$(( ${index} - 1 ))

        cfg="Host ${!region}$(get_json_value "${1}" ${index} Name)\n"
        cfg="${cfg}    HostName $(get_json_value "${1}" ${index} IP)\n"
        # User Map
        cfg="${cfg}    User ${user:=${AWS_USER}}\n"
        cfg="${cfg}    IdentityFile ${AWS_KEY_DIR}/$(get_json_value "${1}" ${index} key)\n"

        echo -e "${cfg}" # >>
    done
}

aws_set_region() {
    region=${region:=${AWS_REGION}}
}

aws_gen() {
    #echo aws_gen
    
    json=$(aws_get_json)
    if [ $? -ne 0 ]; then 
        echo faile
        #exit 1
    fi

    aws_append_local_cfg "${json}"
}

aws_cmd() {

    case "${2}" in
        gen)
            help="Usage: ${0} ${1} ${2} \
            \n		  [-i| --identity identity_file] \
            \n		  [-P| --public true|false] \
            \n		  [-p| --profile profile_name] \
            \n		  [-r| --region region_name] \
            \n		  [-t| --test-connect] \
            \n		  [-u| --user login_name] \
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
