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

## Datetime Tool for shell script

Just include script like:

```bash
source server-tools/datetime_tools/datetime_functions.sh
```

For more details, see https://qiita.com/tomgoodsun/items/2da36c6ee907a26ff756

## Simple PHP command line artgument and answering utility

Just include `php_simple_cli_libs/include.php` in your script.
See more details in the follwing sample scripts.

### function implementation

[`php_simple_cli_libs/test/function_sample.php`](php_simple_cli_libs/test/function_sample.php)

```
$ php test/function_sample.php -a --long --long-arg-with=value
Do you like apple? (yes / no): yes
Do you like banana? (yes / no): yes
Do you like coffee? (yes / no): yes
'a' is in command line args.
'long-arg-with' is in command line args and value is 'value'.
You like apple: yes
You like banana: yes
You like coffee: yes
```

### class implementation

[`php_simple_cli_libs/test/class_sample.php`](php_simple_cli_libs/test/class_sample.php)

```
$ php test/class_sample.php -a --long-arg --long-arg-with=value
Do you like apple? (yes / no): yes
Do you like banana? (yes / no): yes
Do you like coffee? (yes / no): yes
'a' is in command line args.
'long-arg' is in command line args.
'long-arg-with' is in command line args and value is 'value'.
You like apple: yes
You like banana: yes
You like coffee: yes
```


