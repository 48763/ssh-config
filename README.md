# ssh-config

透過 `ssh-config` 指令設置本地端的 *ssh* `config`。

- [安裝](#安裝)
- [手動](#手動)
- [AWS](#aws)

> 目前該專案的大部分功能尚未實現。所以有列出來的子項目，都是能夠使用。

## 安裝

### Mac

使用下面指令，`git clone` 該專案與安裝相依套件 - `jq`：

```bash
$ git clone https://github.com/48763/ssh-config.git
$ brew install jq
```

直接使用 `main` 就能使用：

```bash
$ cd ssh-config
$ ./main
Usage: ./main [OPTION] 

	add		Add host config at folder.
	aws		Use aws command line to generate or delete host config.
	delete		Delete host config at folder.
	help		Get help for commands.
	list		List hosts at folder.
	update		Update host config.
```

如果要指定 ssh 的配置生成目錄，請修改 `.ssh.conf` 中的 `SSH_CONFIG_DIR`：

```bash
$ vi .ssh.conf
$SSH_CONFIG_DIR=./ssh
```

## 手動

- [添加單一主機](#添加單一主機)

### 添加單一主機

`add` 可以透過多個變數，以生成對應的 `ssh/config`：

| 選項 | 說明 |
| - | - |
| -a, --ip-address | 設置遠端主機的 IP 位址 |
| -f, --folder | 指定配置存放的路徑，預設為 `default` |
| -g, --gen-key | 設置遠端登入使用的金鑰路徑 |
| -h, --host  | 設置遠端主機的 host |
| -i, --identity  | 設置遠端登入使用的金鑰路徑 |
| -p, --port  | 設置遠端主機的傳輸埠 |
| -r, --remote-append | 添加公鑰到遠端主機的 `authorized_keys`，使用後將會包含 `-t` |
| -t, --test-connect | 使用後，會測試 IP 可連線才會寫入配置 |
| -u, --user  | 設置遠端登入的用戶名稱 |

#### 範例

```
$ ./main add -h 48763 -a 127.0.0.1 -i ~/.ssh/id_rsa -u yuki -p 2222 -f test

Host 48763
    HostName 127.0.0.1
    Port 2222
    User yuki
    IdentityFile /Users/yuki/.ssh/id_rsa
```

## AWS

`main aws` 會透過 **AWS** 的指令獲取主機資訊，以產生遠端配置檔。

```bash
$ ./main aws 
Usage: ./main aws [OPTION] 

	gen		Generate aws host config with profile of aws.
	delete		Delete aws profile folder of host config.
	help		Print command options.
```

- [生成配置](#生成配置)


### 生成配置

`main aws gen` 的使用如下 

```bash
$ ./main aws gen [OPTIONS]
```

| 選項 | 說明 |
| - | - |
| -i, --identity | 設置遠端登入使用的金鑰路徑，預設為 aws `KeyName` |
| -P, --public | 使用後，僅會輸出有公有 IP 的主機 |
| -p, --profile | 指定 **AWS** 的命名設定檔，預設為 `default` |
| -r, --region | 指定 **AWS** 的區域，預設為 `us-east-2` |
| -t, --test-connect | 使用後，會測試 IP 可連線才會寫入配置 |
| -u, --user | 設置遠端登入的用戶名稱，預設為 `ubuntu` |


#### 使用範例

```
$ ./main aws gen -P -p tw -u yuki

Host tokyo-48763
    HostName 8.8.8.8
    User yuki
    IdentityFile ~/.ssh/aws/id_rsa
```