#!/bin/bash

# Apache Virtual Host Creation Tool
#
# Version 1.0
# Copyright (c) 2021 Tom Higuchi (https://tom-gs.com/)
# Released under the MIT license
# https://opensource.org/licenses/mit-license.php

set -eu

readonly VERSION="1.0"
APACHE_CTL="apachectl"

# Some variables are detected automatically their values.
APACHE_SERVER_ADMIN="root@localhost"
APACHE_USER=$(${APACHE_CTL} -S | grep 'User: ' | awk 'BEGIN{FS="\""}{print $2}')
APACHE_GROUP=$(${APACHE_CTL} -S | grep 'Group: ' | awk 'BEGIN{FS="\""}{print $2}')
APACHE_VHOST_PORT="80"
APACHE_VHOST_NAME=""
APACHE_LOG_DIR="/var/log/httpd"
APACHE_ACCESS_LOG_NAME="access_log"
APACHE_ERROR_LOG_NAME="error_log"
APACHE_VHOST_CONF_DIR=$(${APACHE_CTL} -S | grep 'ServerRoot: ' | awk 'BEGIN{FS="\""}{print $2}')"/conf.d"
APACHE_VHOST_CONF_PREFIX="vhost_"
APACHE_VHOST_ROOT_DIR="/var/www/vhosts"
APACHE_VHOST_DOC_ROOT_NAME="html"

APACHE_USE_SSL=false
APACHE_VHOST_SSL_PORT="443"
APACHE_VHOST_SSL_CERT_FILE=""
APACHE_VHOST_SSL_CERT_KEY_FILE=""

current_date=$(date)

help() {
    cat << EOS
Apache Virtual Host Creation Tool
    Version ${VERSION}

USAGE: $0 {vhost_name} [options]
    --admin            Email address of server admin. Default value is '${APACHE_SERVER_ADMIN}'.
    -u, --user         Owner name. Default value is '${APACHE_USER}', automatically detected from configuration of Apache.
    -g, --group        Owner group. Default value is '${APACHE_USER}', automatically detected from configuration of Apache.
    -p, --port         Listening port of virtual host. Default value is '${APACHE_VHOST_PORT}'.
    --log_dir          Path to log directory. Default value is '${APACHE_LOG_DIR}'.
    --access-log-name  Name of access log file. Default value is '${APACHE_ACCESS_LOG_NAME}'.
    --error-log-name   Name of error log file. Default value is '${APACHE_ERROR_LOG_NAME}'.
    --root-dir         Path to virtual host root directory. Default value is '${APACHE_VHOST_ROOT_DIR}'.
    --doc-root-name    Name of document root directory. Default value is '${APACHE_VHOST_DOC_ROOT_NAME}'.
    --use-ssl          No value. Default value is false. When this argument is given, --ssl-cert and --ssl-cert-key arguments are required.
    --ssl-port         Listening port of SSL virtual host. Default value is '${APACHE_VHOST_SSL_PORT}'.
    --ssl-cert         Path to SSL certificate file.
    --ssl-cert-key     Path to SSL certificate key file.
EOS
}

get_next_vhost_no() {
    number=$(
        find ${APACHE_VHOST_CONF_DIR}/ -type f -name ${APACHE_VHOST_CONF_PREFIX}'*.conf' \
            | awk --assign=prefix=${APACHE_VHOST_CONF_PREFIX} 'BEGIN{FS=prefix}{print $(NF)}' \
                | awk 'BEGIN{FS="-"}{print $1}' \
                    | sort -r \
                        | head -n 1
    )
    
    # Cast to integer
    number=$(expr ${number} + 0)

    # Increment
    if [ "${number}" -gt 0 ];
    then
        number=$(expr ${number} + 1)
    fi

    # Zerofill
    if [ "${number}" -lt 10 ];
    then
        number="0${number}"
    fi

    # Do not concider greater number 99.

    echo ${number}
}

OPTS=$(getopt -o hug: --long admin,user,group,log-dir,access-log-name,error-log-name,root-dir,doc-root-name,use-ssl,ssl-cert,ssl-cert-key,help: -n 'parse-options' -- "$@")

if [ $? != 0 ] ;
then
    echo "Failed parsing options." >&2
    exit 1
fi

while true;
do
    case "${1}" in
        -h | --help ) help; exit 0 ;;
        -u | --user )       APACHE_USER="${2}";                    shift; shift ;;
        -g | --group )      APACHE_GROUP="${2}";                   shift; shift ;;
        -p | --port )       APACHE_VHOST_PORT="${2}";              shift; shift ;;
        --admin )           APACHE_SERVER_ADMIN="${2}";            shift; shift ;;
        --use-ssl )         APACHE_USE_SSL=true;                   shift ;;
        --ssl-port )        APACHE_VHOST_SSL_PORT="${2}";          shift; shift ;;
        --ssl-cert )        APACHE_VHOST_SSL_CERT_FILE="${2}";     shift; shift ;;
        --ssl-cert-key )    APACHE_VHOST_SSL_CERT_KEY_FILE="${2}"; shift; shift ;;
        --log-dir )         APACHE_LOG_DIR="${2}";                 shift; shift ;;
        --access-log-name ) APACHE_ACCESS_LOG_NAME="${2}";         shift; shift ;;
        --error-log-name )  APACHE_ERROR_LOG_NAME="${2}";          shift; shift ;;
        --root-dir )        APACHE_VHOST_ROOT_DIR="${2}";          shift; shift ;;
        --doc-root-name )   APACHE_VHOST_DOC_ROOT_NAME="${2}";     shift; shift ;;
        -- ) shift; break ;;
        * ) APACHE_VHOST_NAME=${1}; shift; break ;;
    esac
done

# Testing variables
#echo '01: ' $APACHE_USER
#echo '02: ' $APACHE_GROUP
#echo '03: ' $APACHE_VHOST_NAME
#echo '04: ' $APACHE_LOG_DIR
#echo '05: ' $APACHE_ACCESS_LOG_NAME
#echo '06: ' $APACHE_ERROR_LOG_NAME
#echo '07: ' $APACHE_VHOST_CONF_DIR
#echo '08: ' $APACHE_VHOST_ROOT_DIR
#echo '09: ' $APACHE_VHOST_DOC_ROOT_NAME
#echo '10: ' $APACHE_USE_SSL
#vhost_conf=${APACHE_VHOST_CONF_DIR}/${APACHE_VHOST_CONF_PREFIX}$(get_next_vhost_no)-${APACHE_VHOST_NAME}.conf
#vhost_dir=${APACHE_VHOST_ROOT_DIR}/${APACHE_VHOST_NAME}
#vhost_doc_root=${vhost_dir}/${APACHE_VHOST_DOC_ROOT_NAME}
#apache_log_dir=${vhost_dir}/httpd
#echo '11: ' $vhost_conf
#echo '12: ' $vhost_dir
#echo '13: ' $vhost_doc_root
#echo '14: ' $apache_log_dir
#exit

if [ "" = "${APACHE_VHOST_NAME}" ];
then
    echo 'Virtual host name is not defined.'
    help
    exit 1
fi

# Create virtual host config directory if not exists.
if [ ! -e ${APACHE_VHOST_CONF_DIR} ];
then
    mkdir -p ${APACHE_VHOST_CONF_DIR}
fi

# Create virtual host root directory if not exists.
if [ ! -e ${APACHE_VHOST_ROOT_DIR} ];
then
    mkdir -p ${APACHE_VHOST_ROOT_DIR}
fi

# Check if config file already exists or not.
vhost_conf=${APACHE_VHOST_CONF_DIR}/${APACHE_VHOST_CONF_PREFIX}$(get_next_vhost_no)-${APACHE_VHOST_NAME}.conf
same_vhost_count=$(${APACHE_CTL}  -t -D DUMP_VHOSTS | grep "${APACHE_VHOST_NAME}" | wc -l)
if [ ${same_vhost_count} != 0 ];
then
    echo "Virtual host conf for '${APACHE_VHOST_NAME}' already exists."
    help
    exit 1
fi

# Check SSL arguments requirement
if [ "${APACHE_USE_SSL}" = "true" ];
then
    if [ "${APACHE_VHOST_SSL_CERT_FILE}" = "" ] || [ "${APACHE_VHOST_SSL_CERT_KEY_FILE}" = "" ];
    then
        echo "--use-ssl requires arguments --ssl-cert and --ssl-cert-key."
        exit 1
    fi
fi

# Check if virtual host directory already exists or not.
vhost_dir=${APACHE_VHOST_ROOT_DIR}/${APACHE_VHOST_NAME}
if [ -e ${vhost_dir} ];
then
    echo "Virtual host directory '${vhost_dir}' already exists."
    exit 1
else
    mkdir -p ${vhost_dir}
    chown -R ${APACHE_USER}:${APACHE_GROUP} ${vhost_dir}
fi

# Create apache log directory for virtual host if not exists.
#apache_log_dir=${APACHE_LOG_DIR}
#if [ ! -e ${apache_log_dir} ];
#then
#    mkdir -p ${apache_log_dir}
#    chmod -R 777 ${apache_log_dir}
#fi
apache_log_dir=${vhost_dir}/httpd
if [ ! -e ${apache_log_dir} ];
then
    mkdir -p ${apache_log_dir}
    chmod -R 777 ${apache_log_dir}
    chown -R ${APACHE_USER}:${APACHE_GROUP} ${vhost_dir}
fi

# Create virtual host document root if not exists.
vhost_doc_root=${vhost_dir}/${APACHE_VHOST_DOC_ROOT_NAME}
if [ -e ${vhost_doc_root} ];
then
    echo "Virtual host document root directory '${vhost_doc_root}' already exists."
    exit 1
else
    mkdir -p ${vhost_doc_root}
    echo "Here is ${APACHE_VHOST_NAME}." > ${vhost_doc_root}/index.html
    chown -R ${APACHE_USER}:${APACHE_GROUP} ${vhost_dir}
fi

# Generates virtual host config.
cat << EOS > ${vhost_conf}
# Virtual host ${APACHE_VHOST_NAME} created at ${current_date}
<VirtualHost *:${APACHE_VHOST_PORT}>
    ServerAdmin ${APACHE_SERVER_ADMIN}
    DocumentRoot ${vhost_doc_root}
    ServerName ${APACHE_VHOST_NAME}
    CustomLog "|/usr/sbin/rotatelogs ${apache_log_dir}/${APACHE_ACCESS_LOG_NAME}.%m%d 86400 540" combined
    ErrorLog "|/usr/sbin/rotatelogs ${apache_log_dir}/${APACHE_ERROR_LOG_NAME}.%m%d 86400 540"
</VirtualHost>

EOS

if [ "${APACHE_USE_SSL}" = "true" ];
then
    # Generates virtual host config.
    cat << EOS >> ${vhost_conf}
# SSL Virtual host ${APACHE_VHOST_NAME} created at ${current_date}
<VirtualHost *:${APACHE_VHOST_SSL_PORT}>
    ServerAdmin ${APACHE_SERVER_ADMIN}
    DocumentRoot ${vhost_doc_root}
    ServerName ${APACHE_VHOST_NAME}
    CustomLog "|/usr/sbin/rotatelogs ${apache_log_dir}/${APACHE_ACCESS_LOG_NAME}.%m%d 86400 540" combined
    ErrorLog "|/usr/sbin/rotatelogs ${apache_log_dir}/${APACHE_ERROR_LOG_NAME}.%m%d 86400 540"

    SSLEngine on
    SSLCertificateFile ${APACHE_VHOST_SSL_CERT_FILE}
    SSLCertificateKeyFile ${APACHE_VHOST_SSL_CERT_KEY_FILE}
</VirtualHost>
EOS
fi

# apachectl section
echo 'Commencing apache configtest'
${APACHE_CTL} configtest

echo 'Enter another apache command if you want.'
read apache_com

if [ "" = "${apache_com} " ];
then
    echo 'No apache command was entered.'
else
    ${APACHE_CTL} ${apache_com}
fi

# vim: expandtab tabstop=4 softtabstop=4 shiftwidth=4 smarttab :
