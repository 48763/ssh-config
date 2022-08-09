# ssh-config

透過 `ssh-config` 指令設置本地端的 *ssh* `config`。

- [手動](#手動)
- [AWS](#aws)

> 目前該專案的大部分功能，都尚未實現。所以有列出來的子項目，都是能夠使用。

## 手動



```
$ ./main         
Usage: ./main [OPTION] 

	add		Add host ssh config in folder.
	aws		Use aws command line to generate or delete ssh host config.
	delete		Delete host ssh config in folder.
	help		Print command options.
	list		List host of folder.
	update		Update host ssh config.
	test		Test function.
```

- [添加](#添加)

### 添加

`add` 可以透過多個變數，以生成對應的 `ssh/config`：

```
$ ./main add -h 48763 -a 127.0.0.1 -i ~/.ssh/id_rsa -u yuki -p 2222 -f test

Host 48763
    HostName 127.0.0.1
    Port 2222
    User yuki
    IdentityFile /Users/yuki/.ssh/id_rsa
```

## AWS



```
$ ./main aws 
Usage: ./main aws [OPTION] 

	gen		Generate aws host ssh config to profile folder.
	delete		Delete aws host ssh config profile folder.
	help		Print command options.
```

### 生成

`aws` 命令是透過 **AWS** 的指令 - `aws ec2 describe-instances` 獲取主機資訊，藉由該資訊生成 `ssh/config`：

```
$ ./main aws gen -P -p tw -u yuki

Host tokyo-48763
    HostName 8.8.8.8
    User yuki
    IdentityFile ~/.ssh/aws/id_rsa
```