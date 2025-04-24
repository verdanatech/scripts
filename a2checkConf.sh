#!/bin/bash
# -------------------------------------------------------------------------
# @Programa 
# 	@name: a2checkConf.sh
#	@versao: 0.0.1
#	@Data 24 de Abril de 2025
#	@versao: 0.0.1
#	@Data 24 de Julho de 2019
#	@Copyright: Verdanatech Soluções em TI, 2019, https://www.verdanatech.com
# --------------------------------------------------------------------------
# LICENSE
#
# a2checkConf.sh is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# a2checkConf.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------


# Executa o comando apachectl -t descartando a saída padrão
apachectl -t > /dev/null 2>&1

#
# STATUS REPORT
#
# 0 - OK
# <> 0 - FAIL

# Captura o status de saída do comando
echo  $?
