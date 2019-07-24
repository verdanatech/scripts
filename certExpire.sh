
#!/bin/bash
# -------------------------------------------------------------------------
# @Programa 
# 	@name: certExpire.sh
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

# Pegando data de expiração do certificado digital do site
expiraData=$(curl --insecure -v $1  2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' | grep "expire date" | awk '{print $4" "$5" "$6" "$7}')

# Convertendo data de expiração em timestamp
expiraData=$(date -d "$expiraData" "+%s")

# Valor da data de hoje
hoje=$(date +%s)

result=$(expr $expiraData - $hoje)

# resultado de dias para expirar
expr $result / 84600
