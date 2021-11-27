# server-tools
Tools for server development

## Apache Virtual Host Creation Tool

Path: `apache_tools/apache_create_vhost.sh`

Create configuration file, directories and sample files for virtual host of Apache HTTP Server.

```
USAGE: apache_tools/apache_create_vhost.sh {vhost_name} [options]
    --admin            Email address of server admin. Default value is 'root@localhost'.
    -u, --user         Owner name. Default value is automatically detected from configuration of Apache.
    -g, --group        Owner group. Default value is automatically detected from configuration of Apache.
    -p, --port         Listening port of virtual host. Default value is '80'.
    --log_dir          Path to log directory. Default value is '/var/log/httpd'.
    --access-log-name  Name of access log file. Default value is 'access_log'.
    --error-log-name   Name of error log file. Default value is 'error_log'.
    --root-dir         Path to virtual host root directory. Default value is '/var/www/vhosts'.
    --doc-root-name    Name of document root directory. Default value is 'html'.
    --use-ssl          No value. Default value is false. When this argument is given, --ssl-cert and --ssl-cert-key arguments are required.
    --ssl-port         Listening port of SSL virtual host. Default value is '443'.
    --ssl-cert         Path to SSL certificate file.
    --ssl-cert-key     Path to SSL certificate key file.
```
