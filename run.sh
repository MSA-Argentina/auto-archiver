#!/bin/bash
# ==========================================================
#
# This script add a backup job in a queue for execution.
# ==========================================================

# Load config
source /opt/backup/config.ini

echo Add $BACKUP_APP to queue job >> $LOGFILE
at -f $BACKUP_APP now + 1 min 
echo Jobs schedule: >> $LOGFILE
echo ------------------------------------------------- >> $LOGFILE
at -l >> $LOGFILE
echo ------------------------------------------------- >> $LOGFILE

