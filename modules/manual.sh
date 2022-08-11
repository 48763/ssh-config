#!/bin/bash
source modules/args.sh
source modules/file-ctl.sh

append_local_cfg() {

    append_local_main_cfg
    append_local_sub_cfg
}

append_local_main_cfg() {

    if ! file_exist "${SSH_CONFIG_DIR}/config"; then
        create_file ${SSH_CONFIG_DIR}/config
    fi

    if ! cfg_exist "include ${folder}" "${SSH_CONFIG_DIR}/config"; then
        echo "include ${folder}/config" >>  ${SSH_CONFIG_DIR}/config
    fi
}

append_local_sub_cfg() {

    if ! file_exist "${SSH_CONFIG_DIR}/${folder}/config"; then

        if ! folder_exist "${SSH_CONFIG_DIR}/${folder}"; then
            create_folder "${SSH_CONFIG_DIR}/${folder}"
        fi

        create_file "${SSH_CONFIG_DIR}/${folder}/config"
    fi

    cfg="Host ${host}\n    HostName ${ip_address}\n    Port ${port:=22}\n" \

    if [ "${user}" ]; then
        cfg="${cfg}    User ${user}\n"
    fi

    if [ "${identity_file}" ] || [ "${gen_key}" ] ; then
        cfg="${cfg}    IdentityFile ${identity_file:=${SSH_CONFIG_DIR}/${folder}/key/${host}}\n"
    fi

    # dry-run
    echo -e "${cfg}" >> ${SSH_CONFIG_DIR}/${folder}/config
}

append_remote_cfg() {
    echo "Append remote cfg"

    # append_remote_ssh_key
    # Use ssh connect host append cfg 
}

# Try it on the mac os.
append_remote_ssh_key() {

    set_ssh_pass
    setsid ssh-copy-id -i ${SSH_CONFIG_DIR}/${folder}/key/${host} ${user}@${ip_address} &> /dev/null
    unset_ssh_pass
}

add_host() {

    if [ "${test_connect}" ] && ! test_connect 22; then
        echo "Can't arrived host(${ip_address})."
        exit 1
    fi

    # Check permission.
    if ! folder_exist "${SSH_CONFIG_DIR}"; then
        create_folder ${SSH_CONFIG_DIR}
    fi

    # Check all config has exist the host name.
    if cfg_exist "Host ${host}" "${SSH_CONFIG_DIR}/${folder}/config"; then
        echo "Host already exist in config."
        exit 1
    fi

    if [ "${gen_key}" ]; then
        create_ssh_key
    fi

    if [ "${remote_append}" ]; then
        echo append_remote_cfg
    fi

    append_local_cfg
}

set_ssh_pass() {
    export DISPLAY=:0
    export SSH_ASKPASS="/tmp/ssh_askpass"

    read -ers -p "Please input your target host password: " PASSWD
    echo ""
    echo "echo ${PASSWD}" > ${SSH_ASKPASS}
    chmod +x ${SSH_ASKPASS}
}

unset_ssh_pass() {
    rm -f ${SSH_ASKPASS}
}

delete_host() {
    echo 0
}

list() {
    echo 0
}

cmd() {
    case "${1}" in
        add)
            help="Usage: ${0} ${1} [-a, --ip-address ip_address] [-f, --folder folder_name] \
            \n		  [-g, --gen-key] [-h, --host host_name] \
            \n		  [-i, --identity identity_file] [-p, --port port_number] \
            \n		  [-r, --remote-append] [-t, --test-connect] \
            \n		  [-u, --user login_name] [options] \
            "

            manual_set_args 1 ${@}
            add_host
        ;;

        delete)
            echo "${@}"
        ;;

        list)
            echo "${@}"
        ;;

        update)
            echo "${@}"
        ;;
    esac

}