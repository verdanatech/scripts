
#!/bin/bash
# -------------------------------------------------------------------------
# @Programa 
# 	@name: certExpire.sh
#	@versao: 0.0.2
#	@Data 23 de Abril de 2025
#	@versao: 0.0.1
#	@Data 24 de Julho de 2019
#	@Copyright: Verdanatech Soluções em TI, 2019, https://www.verdanatech.
# @Copyright: Halexsandro de Freitas Sales <halexsandro@gmail.com>
# --------------------------------------------------------------------------
# LICENSE
#
# certExpire.sh is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# certExpire.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------

# 
# Checa a data de expiração de um certificado digital e retorna sua data em dias.
# 
#
# Valores Retornados
# *Retorna um valor inteiro com a quantidade de dias faltantes para a expiração do certificado.
#
# IMPORTANTE: necessario ter o CURL instalado.

# --------------------------------------------------------------------------

if [ -z $1 ]
then
        # Falta da BASEURL
        echo "-1"
        exit 1;
fi

host="$1"

expiration_string=$(curl -s -v --insecure "$host" 2>&1 | grep "expire date" | awk '{print $4, $5, $6, $7}')

if [ -n "$expiration_string" ]
then

        expiration_date=$(date -d "$expiration_string" +%s)
        current_date=$(date +%s)
        seconds_to_expire=$((expiration_date - current_date))
        days_to_expire=$((seconds_to_expire / (60 * 60 * 24)))

        echo $days_to_expire

else

        # Erro ao baixar informação do certificado.
        echo -2
        exit 2;

fi
