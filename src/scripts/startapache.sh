#!/bin/bash
service httpd start > /var/log/startapache.out 2>&1
rm -rf /var/www/html/index.php
