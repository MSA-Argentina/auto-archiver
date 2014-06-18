#!/bin/sh
# ==========================================================
# Backup script
# ==========================================================

# Load config
. /opt/backup/config.ini

backup() {

    if [ -z "$DEVNAME" ]
    then
        echo Environment Var \$DEVNAME not found. >> $LOGFILE
        echo Maybe you are running this script outside of UDEV >> $LOGFILE
    else
        MOUNTPOINT=`mount | grep $DEVNAME | awk  '{ print $3 }'`
        # Backup Process
        OLDIFS=$IFS
        IFS=" "
        if [ ! -f $BACKUP_CONFIG ] 
        then    
            echo "\$BACKUP_CONFIG not found." >> $LOGFILE
        else
            while read SRC DST
            do
                echo Begins synchronization of $SRC >> $LOGFILE
                rsync -aEvz --delete $SRC $MOUNTPOINT$DST --progress 2>&1 >> $LOGFILE
                echo synchronization of $SRC OK >> $LOGFILE
                echo >> $LOGFILE
            done < $BACKUP_CONFIG
            IFS=$OLDIFS
        fi
    fi
    echo "Exit..." >> $LOGFILE
}


# Lock execution
if [ ! -e "$LOCKFILE" ]
then
    echo $$ >"$LOCKFILE"
    echo "Starting backup process" >> $LOGFILE
    backup
else
    PID=$(cat "$LOCKFILE")
    if kill -0 "$PID" >&/dev/null
    then
        echo "Rsync - Backup still running" >> $LOGFILE
        exit 0
    else
        echo $$ >"$LOCKFILE"
        echo "Warning: previous backup appears not to have finished correctly" >> $LOGFILE
        backup
    fi
fi

rm -f "$LOCKFILE"

