#!/bin/bash

umask 0000

#
# Declaração de variáveis
#

PHP=/usr/bin/php

GLPI_DIR=/home/$i/public_html/verdanadesk

case $1 in

  CRON)

    $PHP $GLPI_DIR/front/cron.php
    
  ;;

  UNLOCK)

    $PHP $GLPI_DIR/bin/console glpi:task:unlock

  ;;

  LDAPSYNC)

    $PHP $GLPI_DIR/bin/console glpi:ldap:synchronize_users -u -n

  ;;

  LDAPIMPORT)

    $PHP $GLPI_DIR/bin/console glpi:ldap:synchronize_users -c -n
    
  ;;

  CACHE)

    $PHP $GLPI_DIR/bin/console glpi:system:clear_cache

  ;;

  TIMESTAMPS)

    $PHP $GLPI_DIR/bin/console  glpi:migration:timestamps -n

  ;;

esac
