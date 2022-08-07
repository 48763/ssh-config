# ssh-config

透過以下指令，設置本地端的 `.ssh/config`。

```
$ ./main         
Usage: ./main [OPTION] 

	add		Add host ssh config in folder.
	aws		AWS.
	delete		Delete host ssh config in folder.
	help		Print command options.
	list		List host of folder.
	update		Update host ssh config.
	test		Test function.
```

- [手動](#手動)
- [AWS](#aws)


## 手動

### 添加

```
$ ./main add

Usage: ./main add [-a| --ip-address ip_address] [-f| --folder folder_name]             
		  [-g| --gen-key] [-h| --host host_name]             
		  [-i| --identity identity_file] [-p| --port port_number]             
		  [-r| --remote-append] [-t| --test-connect]             
		  [-u| --user login_name] [options]
```



## AWS

```
$ ./main aws 
Usage: ./main aws [OPTION] 

	gen		Generate aws host ssh config to folder.
	delete		Delete aws host ssh config in folder.
	help		Print command options.
```