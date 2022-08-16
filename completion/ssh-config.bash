__start_ssh_config() {
	
	complete -W "aws common gcp help" ssh-config
}

complete -o default -F __start_ssh_config ssh-config
