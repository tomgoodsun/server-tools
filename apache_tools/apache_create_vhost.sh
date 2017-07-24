#!/bin/bash

APACHE_USER="apache"
APACHE_GROUP="apache"
APACHE_VHOST_PORT="80"
APACHE_VHOST_NAME=""
APACHE_LOG_DIR="/var/log/httpd"
APACHE_ACCESS_LOG_NAME="access_log"
APACHE_ERROR_LOG_NAME="error_log"
APACHE_VHOST_CONF_DIR="/etc/httpd/vhosts"
APACHE_VHOST_ROOT_DIR="/var/www/vhosts"
APACHE_VHOST_DOC_ROOT_NAME="html"

APACHE_CTL="apachectl"
current_date=$(date)

help() {
    cat << EOS
USAGE: $0 [options] {vhost_name}
    -u, --user         Owner name. Default is '${APACHE_USER}'.
    -g, --group        Owner group. Default is '${APACHE_USER}'.
    -p, --port         Listening port of virtual host. Default is '${APACHE_VHOST_PORT}'.
    --log_dir          Path to log directory. Default is '${APACHE_LOG_DIR}'.
    --access_log_name  Name of access log file. Default is '${APACHE_ACCESS_LOG_NAME}'.
    --error_log_name   Name of error log file. Default is '${APACHE_ERROR_LOG_NAME}'.
    --root_dir         Path to virtual host root directory. Default is '${APACHE_VHOST_ROOT_DIR}'.
    --doc_root_name    Name of document root directory. Default is '${APACHE_VHOST_DOC_ROOT_NAME}'.
EOS
}

OPTS=`getopt -o hug: --long help,user,group,log_dir,access_log_name,error_log_name,root_dir,doc_root_name,help: -n 'parse-options' -- "$@"`

if [ $? != 0 ] ;
then
    echo "Failed parsing options." >&2 ;
    exit 1 ;
fi

while true; do
    case "$1" in
        -h | --help )
            help
            exit 0
            ;;
        -u | --user )
            APACHE_USER="$2";
            shift
            shift
            ;;
        -g | --group )
            APACHE_GROUP="$2"
            shift
            shift
            ;;
        -p | --port )
            APACHE_VHOST_PORT="$2"
            shift
            shift
            ;;
        --log_dir )
            APACHE_LOG_DIR="$2"
            shift
            shift
            ;;
        --access_log_name )
            APACHE_ACCESS_LOG_NAME="$2"
            shift
            shift
            ;;
        --error_log_name )
            APACHE_ERROR_LOG_NAME="$2"
            shift
            shift
            ;;
        --root_dir )
            APACHE_VHOST_ROOT_DIR="$2"
            shift
            shift
            ;;
        --doc_root_name )
            APACHE_VHOST_DOC_ROOT_NAME="$2"
            shift
            shift
            ;;
        -- )
            shift
            break
            ;;
        * )
            APACHE_VHOST_NAME=${1}
            shift
            break
            ;;
    esac
done

#echo $APACHE_USER
#echo $APACHE_GROUP
#echo $APACHE_VHOST_NAME
#echo $APACHE_LOG_DIR
#echo $APACHE_ACCESS_LOG_NAME
#echo $APACHE_ERROR_LOG_NAME
#echo $APACHE_VHOST_CONF_DIR
#echo $APACHE_VHOST_ROOT_DIR
#echo $APACHE_VHOST_DOC_ROOT_NAME
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
vhost_conf=${APACHE_VHOST_CONF_DIR}/${APACHE_VHOST_NAME}.conf
if [ -e ${vhost_conf} ];
then
    echo "Virtual host conf '${vhost_conf}' already exists."
    help
    exit 1
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
    ServerAdmin test@localhost
    DocumentRoot ${vhost_doc_root}
    ServerName ${APACHE_VHOST_NAME}
    CustomLog "|/usr/sbin/rotatelogs ${apache_log_dir}/${APACHE_ACCESS_LOG_NAME}.%m%d 86400 540" combined
    ErrorLog "|/usr/sbin/rotatelogs ${apache_log_dir}/${APACHE_ERROR_LOG_NAME}.%m%d 86400 540"
</VirtualHost>
EOS

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

