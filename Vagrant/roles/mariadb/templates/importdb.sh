#!/bin/bash
#
DUMPFILE="/tmp/db/homepage.sql.bz2"

# check for dump file
if [ ! -f $DUMPFILE ]; then
	echo "$DUMPFILE not found, please insure dump file is present before database can be loaded/reloaded";
	exit 1
fi;

# check if its writeable
if [ ! -w $DUMPFILE ]; then
     echo "$DUMPFILE is not writeable, please insure the dump file can be written to";
     exit 2;
fi;

# check if db exists, if not create it
DB='vagrant';
DB_PRESENT=`mysql -e 'show databases'|grep ${DB}`;

if [ -z $DB_PRESENT ]; then
 echo "${DB} not present, creating";
 mysqladmin create ${DB} ; ERR=$?;
    if [ $ERR -ne 0 ] ; then
	echo "Error creating database: $ERR"
	exit 3;
    fi
fi

# import the db

bzcat ${DUMPFILE} | mysql ${DB}; $ERR=$?;

if [ $ERR -ne 0 ]; then
  echo "Error importing database: $ERR";
else
  rm ${DUMPFILE};
fi
