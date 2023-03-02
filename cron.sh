#!/bin/bash
# -------------------------------------------------------------------------
# @Programa
# 	@name: cron.sh
#	@versao: 1.0.0
#	@Data 02 de Março de 2023
#	@Copyright: Verdanatech Soluções em TI, 2015 - 2023
# --------------------------------------------------------------------------
# LICENSE
#
# verdanadeskGLPiBKP.sh is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# verdanadeskGLPiBKP.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------

umask 0000

#
# Declaração de variáveis
#

PHP=/usr/bin/php

GLPI_DIR=/var/www/html/glpi

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
