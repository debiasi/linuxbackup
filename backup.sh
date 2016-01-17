#!/bin/bash
######################################################################
# backup.sh
# Faz backup num arquivo tar gz do diretorio e arquivos indicados no 
# arquivo backup.conf
######################################################################
# v1 (2014-08-25)
# autor: Conrado De Biasi - debiasi@gmail.com
######################################################################
# Exemplo de uso via crontab:
#
# Executar via crontab todos os dias as 03 da manhã
# 00 03 * * * /scripts/backup.sh
#
# É gerado um log no /tmp com o nome backup.status
######################################################################
# TODO (o que pode melhorar)
# - checar disco
# - alarmar se não rodou
# - log
# - apagar backups antigos
# - ignorar determinados tipos de arquivos ou diretórios
# - Enviar por email
# - permitir comentários no arquivo conf
#######################################################################
#

# Variaveis configuraveis


BACKUPDIR="/BACKUP"; # Diretório destino do tar.gz com o backup
BACKUPCONF="/scripts/backup.conf"; # diretório do arquivo de conf

# Variaveis Fixas
HOST=`hostname`;
DATE=`/bin/date +'%Y%m%d%H%M%S'`;
NOW=`/bin/date`;

TAR="/bin/tar";
MKDIR="/bin/mkdir";

# HEADER

echo "";
echo "BACKUP - $NOW";
echo "";


# Checa se existe o backupdir. Se não existe criar
if [ ! -d $BACKUPDIR ]
then
    $MKDIR -p $BACKUPDIR
    if [ $? -eq 0 ]; 
    then 
	echo "[INFO] Diretorio $BACKUPDIR criado com sucesso!";
    else
	echo "[ERRO] Não configo criar o diretorio $BACKUPDIR";
	exit 1;
    fi
fi

# CHECAR SE EXISTE O ARQUIVO BACKUP.CONF, SE NAO EXISTIR SAIR
if [ ! -e $BACKUPCONF ]; then
    echo "[ERRO] Não existe o arquivo ${BACKUPCONF}.";
    exit 1;
fi

# FAZENDO BACKUP

echo "Criando backup ${BACKUPDIR}/${HOSTNAME}.${DATE}.tar.gz";

$TAR -zcf ${BACKUPDIR}/${HOSTNAME}.${DATE}.tar.gz -T $BACKUPCONF
    if [ $? -eq 0 ]; 
    then 
	NOW2=`/bin/date`;
	MSG="[INFO] Backup executado com sucesso - $HOSTNAME - $NOW2 !";
	echo $MSG;
	echo "";
	echo $MSG > /tmp/backup.status;
	exit 0;
    else
	NOW2=`/bin/date`;
	MSG="[ERRO] Falhou execução do backup ! - $HOSTNAME - $NOW2";
       	echo $MSG;
	echo "";
	echo $MSG > /tmp/backup.status;
	exit 1;
    fi


# EOF
######
