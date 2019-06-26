=====================
bocloud cmp worker
=====================

## BOCLOUD WORKER 配置使用 ##
### 安装bocloud worker的rpm包 ###
    yum install -y bocloud_worker-4.0.0-gd3c4f14.2018071213.1.noarch.rpm

### 更新BOCLOUD WORKER配置 ###
    配置文件为：
    /opt/worker/bocloud_worker/bocloud_worker_config.yml
    /opt/worker/bocloud_worker/telegraf_config.yml。

- 制作ssh public key，命令参考
- [root@localhost ~]# ssh-keygen -t rsa
- Generating public/private rsa key pair.
- Enter file in which to save the key (/root/.ssh/id_rsa): 
- Enter passphrase (empty for no passphrase): 
- Enter same passphrase again: 
- Your identification has been saved in /root/.ssh/id_rsa.
- Your public key has been saved in /root/.ssh/id_rsa.pub.
- The key fingerprint is:
- 92:dc:31:0d:8c:3e:b2:2d:7c:cb:49:9e:af:96:4a:87 root@localhost.localdomain
- The key's randomart image is:
- +--[ RSA 2048]----+
- |       o.        |
- |      . .o       |
- |     .  o .      |
- |    ..oo o       |
- |   . ++.S        |
- |    +.+.         |
- |    E*.=         |
- |   . .O          |
- |    .o.o.        |
- +-----------------+
- [root@localhost ~]# 

### 启动BOCLOUD WORKER ###
`bocloud_worker 必须要用root用户启动`
- service bocloud_worker start

### 停止BOCLOUD WORKER ###
- service bocloud_worker stop

注：一定不能手动kill bocloud\_worker进程,这样不能正确关闭一些守护进程文件。

