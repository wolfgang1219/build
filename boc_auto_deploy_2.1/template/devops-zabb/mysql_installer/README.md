MySQL 5.7 Installer 0.1 for zabbix server on CentOS6 or CentOS7

1.software version:
	 mysql-community-server-5.7.18-1.el6.x86_64.rpm
		( including almost all other dependencies)

2. installation prerequisites:
	1) CentOS6 [6.5 - 6.8]   minial is perfect!
	2) CentOS7 [7.1 - 7.3]   minial is perfect!
	3) no sql

3. installation source directory structure:
	1)main.py - entry point of program
	2)resources/
			centos6-deps/				- mysql 5.7 rpm and it's dependencies for CentOS6
			centos7-deps/				- mysql 5.7 rpm and it's dependencies for CentOS7
			scripts/					- shell scripts
			zabbix/				        - db schemas for zabbix

4. services startup with host:
    1)mysqld -  service myqld start|stop|status ...   ,on CentOS6.
             -  systemctl start|stop|status ... mysqld  ,on CentOS7 using systemd tool.

5. Usage:
	1) interactive mode:
		$python main.py
	2) no-interractive mode
		takes the default parameter configuration during installation
			$python main.py -i install -d
		
		uninstall forcely
			$python main.py -i uninstall -f
			
	NOTICE:!!!!UNINSTALL OPERRATION WILL DELETE ALL THE DATABASE FILES, PLEASE BACKUP FIRST!!!!
