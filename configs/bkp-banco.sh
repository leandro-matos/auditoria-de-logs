#!/bin/bash
mysqldump --user="rsyslog" --password="rsyslog" "$@" "Syslog" > "/opt/backup/syslog-$(date '+%d-%m-%Y')".sql 2> /dev/null