import getopt
import getpass
import logging
import os
import platform
import socket
import subprocess
import sys
import time

from installer.console import Console


IPREGEX = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
# module global variable
_cfgfile = None
# using the default value of server's ip, database's password etc. during installation
_default = False
# uninstall without confirmation prompt if _force is true
_force = False
_installtype = None
_setupdir = None
_dbuser = 'root'
_dbpassword = 'onceas'

_logname = None

_CENTOS7 = True

try:
    _novnc = socket.gethostbyname(socket.gethostname())
except:
    # This happens if cannot find mapping of hostname to IP address in /etc/hosts
    #  using '' to ask the webconfigmod.sh to gain the eth0 IP address.
    _novnc = ''


def init_logging():
    logname = 'mysql-install-%s.log' % time.strftime("%Y-%m-%d-%H%M%S")
    logdir = '/var/log/'
    global _logname

    try:
        if not os.path.exists(logdir):
            os.mkdir(logdir)

        logfile = os.path.join(logdir, logname)
        _logname = logfile
        logging.basicConfig(filename=logfile,
                            level=logging.DEBUG,
                            format='%(asctime)s.%(msecs)d %(module)s.%(funcName)-12s %(levelname)-8s %(message)s',
                            datefmt='%Z %b %d %H:%M:%S')
    except:
        # logging on /tmp/logfile
        logfile = os.path.join('/tmp', logname)
        logging.basicConfig(filename= logfile,
                            level=logging.DEBUG,
                            format='%(asctime)s.%(msecs)d %(name)-12s %(levelname)-8s %(message)s')
    #console(stderr) logging
    console = logging.StreamHandler()
    console.setLevel(logging.INFO)
    formatter = logging.Formatter('%(message)s')
    console.setFormatter(formatter)
    logging.getLogger().addHandler(console)
    # redirect stdout to log file
    sys.stderr = open(logfile, 'w')


def process_opts():
    arguments = sys.argv[1:]
    #logging.debug("Parsing command line operations ...")
    #logging.debug("   [arguments]: %s" % arguments)
    opts, leftargs = getopt.getopt(arguments, "dfc:i:", ["default", "force=", "config=", "installtype="])

    global _installtype
    global _cfgfile
    global _default
    global _force

    for opt, val in opts:
        if opt in ("-c", "--config"):
            _cfgfile = os.path.abspath(val)
        if opt in ("-i", "--installtype"):
            if val.lower() == "install":
                _installtype = "install"
            elif val.lower() == "uninstall":
                _installtype = "uninstall"
        if opt in ("-d", "--default"):
            _default = True
        if opt in ("-f", "--force"):
            _force = True


def get_setupdir():
    return os.path.dirname(os.path.abspath(sys.argv[0]))


def run_cmd(cmd, shell=False, cwd=None):
    """
    Run linux command.
    :param cmd: list for non-shell, and string for shell
    :return: tuple of return code, stdout data and stderr data of the command.
    """
    if shell:
        if not isinstance(cmd, str):
            raise Exception("Only accepts string when shell is True!")
    else:
        if not isinstance(cmd, list):
            raise Exception("Only accepts list when shell is False!")
        cmd = [str(x) for x in cmd]

    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, close_fds=True, shell=shell, cwd=cwd)
    (stdoutdata, stderrdata) = proc.communicate()
    return proc.returncode, stdoutdata, stderrdata


def check_prerequisite():
    # verify run by root
    #uid = os.getuid()
    logging.debug("* Checking if run as root ... ")
    user = getpass.getuser()
    if user != "root":
        logging.info("You are trying to run this installer as user '%s', please run it as root." % user)
        return False
    logging.debug("* passed.")

    # only centos 6 or centos7
    logging.debug("* Checking if OS distribution and version is supported ...")
    distname, version, id = platform.linux_distribution()
    if distname not in ['CentOS', 'CentOS Linux']:
        logging.info("Only CentOS is supported, your SO distribution: %s." % distname)
        return False
    elif version not in ['7.1.1411', '7.2.1511', '7.3.1611']: #['6.8', '6.7', '6.6', '6.5', '7.1.1411', '7.2.1511', '7.3.1611']:
        logging.info("Only CentOS7[7.1-7.3] is supported, your CentOS version is '%s'."
                     % version)
        return False

    logging.debug("* passed.")

    # no mysql installed
    logging.debug("* Checking if mysql is installed ...")
    cmd = 'mysql -V'
    returncode, stdoutdata, stderrdata = run_cmd(cmd, shell=True)
    if returncode == 0:
        logging.info("Found installed mysql:[ %s ], please REMOVE mysql first." % stderrdata.strip())
        return False
    logging.debug("* passed")

    return True


def install_db(installerdir):
    """
    Install and configure mysql.
    :param installerdir:
    :return:
    """
    logging.info("Step 1 of 2: Installing MySQL ...")
    logging.info("Please waiting ...")
    rpmpath = os.path.join(installerdir, 'resources/db/centos7-deps/', '*.rpm')
    cmd = ['rpm', '-Uh', '--force', rpmpath]
    returncode, outdata, errdata = run_cmd(cmd)
    if returncode != 0:
    #    logging.info("Install MySQL failed, the install command is: %s" % cmd)
        logging.debug("Error message: %s", errdata)
    #    exit(1)
    logging.info("MySQL installed successfully.")

    logging.info("Step 2 of 2: Configuring MySQL ...")
    logging.info("Please waiting ...")
    config_db(installerdir)
    logging.info("MySQL configured successfully.")


def config_db(installerdir):
    """
    Perform the following actions:
        1) initialize mysql database such as "data dir"
        2) resetting the root's password
        3) modifying the privileges
        4) create and grant privileges for zabbix:zabbix
        5) importing schemas used by 'zabbix'
    :return:
    """
    global _dbpassword
    global _CENTOS7
    mysql_initialize_insecure()

    mysql_safe_start_skip_grant_table(installerdir)

    change_root_passwd_in_safe_start()

    # restart mysqld in normal mode(without skip-grant-tables)
    #cmd = ['service', 'mysqld', 'stop']
    #returncode = subprocess.call(cmd)
    stop_db()
    if _CENTOS7:
        unset_skip_grant_table()

    start_db()
    # restart mysqld in normal mode(without skip-grant-tables)
    #logging.info("Staring MySQL server, please waiting ...")
    #cmd = ['service', 'mysqld', 'start']
    #returncode = subprocess.call(cmd)

    # grant root access privileges both from localhost and remote host
    mysql_grant_privileges(user='root', password=_dbpassword)

    # grant zabbix access privileges by root user
    mysql_grant_zabbix(user='root', password=_dbpassword)

    # utf-8 encoding
    mysql_import_schemas(installerdir)

    enable_db_service()


def unset_skip_grant_table():
    cmd = 'systemctl unset-environment MYSQLD_OPTS'
    run_cmd(cmd, shell=True)


def change_root_passwd_in_safe_start():
    global _dbpassword
    # modify root password
    # sql must be a single string i.e. enclosed with quote
    # e.g. a valid shell command: mysql -uroot -p' ' -e "show variables like 'charset%'"
    sql = '"UPDATE mysql.user SET authentication_string=PASSWORD(\'%s\'), password_expired=\'N\' WHERE User=\'root\' and Host=\'localhost\';"' % _dbpassword
    cmd = 'mysql -uroot -p" "  -e ' + sql
    logsql = '"UPDATE mysql.user SET authentication_string=PASSWORD(\'******\'), password_expired=\'N\' WHERE User=\'root\' and Host=\'localhost\';"'
    logcmd = 'mysql -uroot -p" "  -e ' + logsql
    logging.debug("Modifying root password's command: %s" % logcmd)
    returncode, outdata, errdata = run_cmd(cmd, shell=True)
    if returncode != 0:
        logging.info("Reseting root's password in mysqld failed. Exiting...")
        logging.debug("command: %s, output: %s, error: %s" % (cmd, outdata, errdata))
        exit(1)
    logging.info("Reseting root's password successfully.")


def mysql_safe_start_skip_grant_table(installerdir):
    # start mysqld in skip-grant-table mode in order to change root's password
    logging.info("Starting mysqld-safe in skip-grant-table mode ...")
    script = os.path.join(installerdir, 'resources/scripts/skip_grant_tables.sh')
    logging.debug(script)
    cmd = ['sh', script]
    returncode = subprocess.call(cmd)
    if returncode != 0:
        logging.info("command: %s, returncode: %s" % (cmd, returncode))
        exit(1)
    logging.debug("Mysqd-saft started.")
    # waiting mysql_safed started
    time.sleep(5)


def mysql_initialize_insecure():
    # initialize db data dir in non-secure mode in which root's password is empty
    logging.info("Initializing msyql mode ...")
    cmd = ['mysqld', '--initialize-insecure', '--explicit_defaults_for_timestamp', '--user=mysql']
    returncode, outdata, errdata = run_cmd(cmd)
    if returncode != 0:
        logging.info("Initialzing mysql server failed. Exiting ...")
        logging.debug("command: %s, output: %s, error: %s" % (cmd, outdata, errdata))
        exit(1)
    logging.info("Initialized mysql successfully.")


def mysql_grant_zabbix(user='root', password='onceas'):
    sqlpassword = "-p'%s' " % password
    sql = '"grant all privileges on %s.* to \'%s\'@\'localhost\' identified by \'%s\' with grant option;"' % ('zabbix', 'zabbix', 'zabbix')
    logsql = "grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by '******' with grant option;"
    cmd = 'mysql -u' + user + ' ' + sqlpassword + " -e " + sql
    #logging.info("execting mysql statement: %s" % cmd)
    logcmd = "mysql -u %s -p****** -e %s" % (user, logsql)
    returncode, outdata, errdata = run_cmd(cmd, shell=True)
    if returncode != 0:
        logging.info("Create zabbix and grant its privileges[access from local host] failed. Exiting ...")
        logging.debug("command: %s, output: %s, error: %s" % (logcmd, outdata, errdata))
        exit(1)

    # access from any host
    sql = '"grant all privileges on %s.* to \'%s\'@\'%%\' identified by \'%s\' with grant option;"' % (
    'zabbix', 'zabbix', 'zabbix')
    logsql = "grant all privileges on zabbix.* to 'zabbix'@'%' identified by '******' with grant option;"
    cmd = 'mysql -u' + user + ' ' + sqlpassword + " -e " + sql
    # logging.info("execting mysql statement: %s" % cmd)
    logcmd = "mysql -u %s -p****** -e %s" % (user, logsql)
    returncode, outdata, errdata = run_cmd(cmd, shell=True)
    if returncode != 0:
        logging.info("Create zabbix and grant its privileges[access from remote host] failed. Exiting ...")
        logging.debug("command: %s, output: %s, error: %s" % (logcmd, outdata, errdata))
        exit(1)

    sql = '"FLUSH PRIVILEGES;"'
    cmd = 'mysql -u' + user + ' ' + sqlpassword + " -e " + sql
    returncode, outdata, errdata = run_cmd(cmd, shell=True)
    if returncode != 0:
        logging.info("Create zabbix and grant its privileges failed. Exiting ...")
        logging.debug("command: %s, output: %s, error: %s" % (logcmd, outdata, errdata))
        exit(1)


def mysql_grant_privileges(user='root', password='onceas'):
    # grants privileges to user [root]
    logging.info("Configuring privileges for user %s ..." % user)
    sqlpassword = "-p'%s' " % password
    sql = '"grant all privileges on *.* to \'%s\'@\'%%\' identified by \'%s\' with grant option;"' % (user, password)
    cmd = 'mysql -u' + user + ' ' + sqlpassword + " -e " + sql
    run_cmd(cmd, shell=True)
    sql = '"grant all privileges on *.* to \'%s\'@\'localhost\' identified by \'%s\' with grant option;"' % (user, password)
    cmd = 'mysql -u' + user + ' ' + sqlpassword + " -e " + sql
    run_cmd(cmd, shell=True)
    sql = '"FLUSH PRIVILEGES;"'
    cmd = 'mysql -u' + user + ' ' + sqlpassword + " -e " + sql
    run_cmd(cmd, shell=True)


def mysql_import_schemas(installerdir):
    global _dbpassword
    sqlpassword = "-p'%s' " % _dbpassword
    logging.info("Start importing schemas ...")
    for name in ['resources/zabbix/zabbix-mysql.sql']:
        schema = os.path.join(installerdir, name)
        import_schema(schema, sqlpassword)
    logging.info("Import schemas completed successfully.")


def import_schema(schema, sqlpassword):
    schemaname = os.path.basename(schema)
    logging.debug("Importing schema: <%s> " % schema)
    sql = '"source %s;"' % schema
    cmd = "mysql -uroot " + sqlpassword + " -e " + sql
    returncode, outdata, errdata = run_cmd(cmd, shell=True)
    if returncode != 0:
        logging.debug("Import <%s> schema failed." % schemaname)
        logging.debug("cmd: %s, output: %s, error: %s" % (cmd, outdata, errdata))
    else:
        logging.debug("'<%s>' schema imported successfully." % schemaname)


def start_db():
    logging.info("Starting MySQL server, please waiting ...")

    # logging.info("Staring MySQL server, please waiting ...")
    # cmd = ['service', 'mysqld', 'start']
    # returncode = subprocess.call(cmd)
    cmd = ['service', 'mysqld', 'start']
    returncode = subprocess.call(cmd)
    if returncode == 0:
        logging.info("MySQL server started.")
    else:
        logging.info("MySQL server start failed, exiting ...")
        exit(1)


def stop_db():
    logging.info("Stopping mysql service ...")
    cmd = ['service', 'mysqld', 'stop']
    run_cmd(cmd)
    logging.info("Mysql service stopped.")


def remove_db():
    stop_db()

    cmd = "rpm -aq | grep -i mysql-community"
    returncode, outdata, errdata = run_cmd(cmd, shell=True)
    if returncode != 0:
        logging.info("Cannot find mysql rpm match (%s), nothing about mysql to be removed ..." % "mysql-community")
        return
    rpm = " ".join(outdata.splitlines())
    cmd = "rpm -e --nodeps %s" % rpm
    returncode, outdata, errdata = run_cmd(cmd, shell=True)
    if returncode != 0:
        logging.info("Uninstall mysql rpm [%s] failed." % rpm)
        exit(1)
    logging.info("Remove mysql rpm successfully.")

    # delete "/var/lib/mysql" dir, "/etc/my.cnf"
    cmd = "rm -rf /var/lib/mysql /etc/my.cnf"
    returncode, outdata, errdata = run_cmd(cmd, shell=True)
    if returncode != 0:
        logging.info("Deleting file/dir[%s, %s] failed." % ("/var/lib/mysql", "/etc/my.cnf"))
        exit(1)
    logging.info("Deleting mysql files/dirs successfully.")
    logging.info("Remove mysql successfully.")


def enable_db_service():
    logging.info("Enable mysql service ...")
    cmd = ['chkconfig', 'mysqld', 'on']
    run_cmd(cmd)
    logging.info("Mysql service enabled")


def cleanup():
    pass


def ask_installtype(console):
    """
    Interactive mode, get the installtype value.
    :return:
    """
    choices = ["Install", "Uninstall", "Abort"]
    install_type = console.ask_choice(choices, "Please select an install type")
    return install_type.lower()


def ask_configparams(console):
    global _dbpassword

    password = console.ask_password("Please enter the database password for root user")
    # avoid empty passwd
    if not password:
        password = 'onceas'
    _dbpassword = password
    logging.info("")


def install(setupdir, defaultconfigparam, console):
    try:
        #logging.info("")
        #logging.info("Starting INSTALL MySQL")
        #logging.info("")
        #logging.info("* Checking installation prerequisites ...")
        #if not check_prerequisite():
        #    logging.debug("* Checking installation prerequisites failed")
            #raise Exception("* Checking installation prerequisite failed")
        #    exit(1)
        #logging.info("* Installation prerequisites check PASSED.")
        #logging.info("")

        if not defaultconfigparam:
            ask_configparams(console)
        else:
            logging.debug("Using default configuration parameters(server, dbuser, dbpassword etc.) during installation.")

        install_db(setupdir)
        logging.info("")
        logging.info("Installation done.")
    except Exception, e:
        logging.info("Installation failed: %s" % e)


def uninstall():
    logging.info("Starting UNINSTALL MySQL...")
    remove_db()
    cleanup()
    logging.info("UNINSTALLED successfully.")
    logging.info("")


def _confirm_uninstall(console):
    logging.info("DANGER OPERATION!!!")
    logging.info("Uninstallation will delete all database data, make sure you have a backup!")
    return console.ask_yes_no("Are you sure to continue?")


def echo_header():
    global _logname
    logging.info("")
    logging.info("MySQL Installer for zabbix server on CentOS")
    logging.info("")
    logging.info("Installer log file:")
    logging.info(_logname)
    logging.info("")


def main():
    global _setupdir
    init_logging()
    _setupdir = get_setupdir()
    console = Console()
    global _installtype
    process_opts()
    echo_header()

    # interactive
    if _cfgfile is None and _installtype is None:
        _installtype = ask_installtype(console)
        logging.info("")

    if _installtype == 'abort':
        logging.info("   Bye.")
        exit(0)
    if _installtype == "install":
        install(_setupdir, _default, console)
    elif _installtype == "uninstall":
        if _force or _confirm_uninstall(console):
            logging.info("")
            uninstall()
        else:
            logging.info("Aborting ...")


if __name__ == "__main__":
    main()
