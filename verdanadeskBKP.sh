#!/bin/bash
# -------------------------------------------------------------------------
# @Programa
# 	@name: verdanadeskGLPiBKP.sh
#	@versao: 1.0.2
#	@Data 21 de Setembro de 2021
#	@Copyright: Verdanatech Soluções em TI, 2015 - 2020
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

#
# Declaracao de variaveis do programa
# * altere as informacoes abaixo de
# acordo com as caracteristicas do seu sistema
#

# Diretorio de Backup
BKPDIR="/var/www/html/glpi/files/_dumps"

# Periodo de retencao do backup em dias
RETENCAO=7

# Usuario da Base de Dados
DATABASEUSER=root

# Senha do usuario da Base de Dados
DATABASEPASSWORD='NULL'

# Nome da Base de Dados
DATABASE=glpi

##############################
# Evite alterar a partir daqui #
 ##############################

# Data de execucao do DUMP
DATE=$(date +%Y%m%d_%H_%M)

#
# Inicio do Backup
#

mysqldump -u $DATABASEUSER $(if [ $DATABASEPASSWORD != NULL ] ; then echo "-p$DATABASEPASSWORD"; fi) $DATABASE > $BKPDIR/verdanadesk_$DATE.sql

#
# Validando se o DUMP foi bem sucedido
#

if [ $? -ne 0 ]
then
	# Caso o DUMP falhe, o script aborta a execucao
	echo "Erro ao executar Backup de $DATABASE"
	exit 1
else
	# Excluindo arquivos mais antigos que o periodo de retencao
	echo "Excluindo arquivos mais antigos!"
	find $BKPDIR/ -type f -mtime +$RETENCAO -exec rm -rf {} \;
fi
