#!/usr/bin/env bash
if type mysqld_safe >/dev/null 2>&1; then
    mysqld_safe --skip-grant-tables  >/dev/null 2>&1 &
else
    systemctl set-environment MYSQLD_OPTS="--skip-grant-tables"
    systemctl start mysqld
fi
