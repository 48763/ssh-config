# Conditions file exist.
cfg_exist() {

    grep "${1}" "${2}" &>/dev/null

    if [ ${?} -eq 0 ]; then
        true
    else
        false
    fi
}

file_exist() {

    if [ -f ${1} ]; then
        true
    else
        false
    fi
}

folder_exist() {

    if [ -d ${1} ]; then 
        true
    else
        false
    fi
}

test_connect() {
    
    nc -z -w 1 ${ip_address} ${1} &> /dev/null
    if [ ${?} -eq 0 ]; then
        true
    else
        false
    fi
}

create_ssh_key() {

    if ! folder_exist "${SSH_CONFIG_DIR}/${folder}/key"; then
        create_folder ${SSH_CONFIG_DIR}/${folder}/key
    fi

    # Condition use OR
    if file_exist "${SSH_CONFIG_DIR}/${folder}/key/${host}.pub" \
        || file_exist "${SSH_CONFIG_DIR}/${folder}/key/${host}"; then

        echo "Key file has been duplicated."

    else
        # Type and bit.
        ssh-keygen -t rsa -b 4096 -f ${SSH_CONFIG_DIR}/${folder}/key/${host} -q -N ""	&> /dev/null
    fi
}

create_file() {
    touch ${1}
}

create_folder() {
    mkdir -p ${1}
}
