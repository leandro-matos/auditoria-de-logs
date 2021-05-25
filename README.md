
# Auditoria de Logs

### Localização padrão de Logs no Linux
Debian, RedHat: **/var/log/***
- [x] **lastlog**
- [x] **dmesg**
- [x] **messages** (Padrão RedHat)
- [x] **syslog** (Padrão CentOS)
- [x] **lastb**
- [x] **last**
- [x] **/etc/rsyslog.conf**
- [x] _echo "cron.* /var/log/cron.log" > /etc/rsyslog.d/cron.conf && systemctl restart rsyslog_ (Servidor Ubuntu)


### Gerenciar Rotação de logs
- [x] **/etc/logrotate.d/**
- [x] Criação do arquivo de rotate para o cron
- [x] **logrotate -f /etc/logrotate.conf**
- [x] **ls -latr /var/log/cron**
- [x] **cat /etc/crontab**
- [x] **ls /etc/cron.daily/**
- [x] **/var/log/secure**


### Instalação e configuração do Auditd
- [x] **sudo apt install aditd -y**
- [x] **/var/log/audit/audit.log**


### Criação de regra para execução de Syscalls
* Interface entre uma aplicação e o Kernel do Linux
- [x] **auditctl -a exit,always -F arch=b64 -S clock_settime -F key=changehour && auditctl -l**
- [x] **tail /var/log/audit.log**
- [x] **ausyscall --dump**
- [x] **auditctl -l >> /etc/audit/rules.d/audit.rules && systemctl restart auditd**


### Analisar eventos com Ausearch e Aureport
- [x] **ausearch -k changehour**
- [x] **ausearch -x /usr/bin/crontab**
- [x] **aureport --summary**
- [x] **aureport -m**


### Auditoria em tempo real
* PAM são módulos para auditoria específica nos sistemas Linux
- [x] **ls -l /etc/pam.d/**
- [x] **echo "session required             pam_tty_audit.so disable=* enable=root log_passwd" >> /etc/pam.d/common-password**
- [x] **echo '-a always,exit -F arch=b64 -F euid=0 -S execve' >> /etc/audit/rules.d/audit.rules**
- [x] **echo '-a always,exit -F arch=b32 -F euid=0 -S execve' >> /etc/audit/rules.d/audit.rules**
- [x] **tail -f /var/log/audit.log**
- [x] **apt install audispd-plugins -y**
- [x] **ls -l /etc/audit/plugins.d/**
- [x] **tail -f /var/log/messages**


### Gerenciar centralização de logs
* Habiilitar as configurações da porta 514 dentro do rsyslog.conf
- [x] **echo "template  (name="LogRemoto"  type="string" string="/srv/log/%HOSTNAME%/%PROGRAMNAME%.log")" > /etc/rsyslog.d/template.conf**
- [x] **echo "*.* ?LogRemoto" >> /etc/rsyslog.d/template.conf**
- [x] **mkdir /srv/log && chown syslog:syslog -R /srv/log**
* Dentro dos servidores Client's habilitar a coleta remota
- [x] **echo '*.* @@graylog' >> /etc/rsyslog.conf && systemctl restart rsyslog**


### Logs remotos com criptografia TLS
* Graylog
- [x] **apt install rsyslog-gnutls gnutls-bin -y**
- [x] **mkdir /etc/rsyslog-keys**
- [x] **certtool --generate-privkey --outfile ca-key.pem && chmod 400 ca-key.pem**
- [x] **certtool --generate-self-signed --load-privkey ca-key.pem --outfile ca.pem**
- [x] **certtool --generate-privkey --outfile webserver-key.pem --bits 2048**
- [x] **certtool --generate-request --load-privkey webserver-key.pem --outfile webserver-request.pem**
- [x] **certtool --generate-certificate --load-request webserver-request.pem --outfile webserver-cert.pem --load-ca-certificate ca.pem --load-ca-privkey ca-key.pem**
- [x] **scp ca.pem webserver* usuario@webserver:/tmp**

* WebServer
- [x] **yum install rsyslog-gnutils -y**
- [x] **mkdir /etc/rsyslog-keys**
- [x] **mv /tmp/* /etc/rsyslog-keys/**


### Armazenando logs no MySQL
- [x] **DEBIAN_FRONTEND=noninteractive apt install mysql-server mysql-client mysql-common rsyslog-mysql -y**
- [x] **mysql -u root -e 'CREATE DATABASE Syslog;'**
- [x] **mysql -u root -D Syslog < /usr/share/dbconfig-common/data//rsyslog-mysql/install/mysql**
- [x] **mysql -u root -D Syslog -e "CREATE USER rsyslog@localhost IDENTIFIED BY 'rsyslog';"**
- [x] **mysql -u root -D Syslog -e 'GRANT ALL ON Syslog.* TO rsyslog@localhost;'**
- [x] **vim /etc/rsyslog.d/mysql.conf** _Incluir login e senha da base_
- [x] **systemctl restart rsyslog**
- [x] **mysql -u root -D Syslog -e 'SELECT ID, fromHost, Message FROM SystemEvents;'**


### Backup e Restore de logs
- [x] **mysqldump Syslog > backup-banco-syslog.sql**
- [x] **mysqldump Syslog SystemEvents > backup-tabela-syslog.sql**

- [x] **mysql -u root -D Syslog -e 'DROP TABLE SystemEvents;'**
- [x] **mysql -u root -D Syslog < backup-tabela-syslog.sql**

- [x] **cp /opt/bkp-banco.sh /usr/local/bin/ && chmod u+x /usr/local/bin/bkp-banco.sh && mkdir /opt/backup"
- [x] **cp /usr/local/bin/bkp-banco.sh /etc/cron.daily/bkp-banco**
- [x] **run-parts /etc/cron.daily/** _Força a execução do cron no exato momento_


### Instalação e configuração do Graylog
- [x] **apt install -y apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen**
- [x] **vim /etc/environment** , **JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64/bin/"**
- [X] __Instalação do MongoDB conforme a doc Oficial__
- [x] __Instalação do ElasticSearch conforme a doc Oficial__
- [x] __Instalação do Graylog conforme a Doc Oficial__
- [x] **pwgen -N 1 -s 96**
- [x] **echo -n leandro | sha256sum**
- [x] **vim /etc/graylog/server/server.conf**

### Coletando logs dos hosts pelo Rsyslog, Containers
- [x] __Configuração dos hosts apontando para o Syslog via SyslogUDP__

