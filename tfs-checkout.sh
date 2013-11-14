#!/bin/sh

dir=`dirname $0`
dir=`cd $dir; pwd`

# GET ARGS
while getopts c:p:d:u: opt; do
    case $opt in
        c) COLLECTION=$OPTARG;;
        d) DIR=$OPTARG;;
        u) USERPASS=$OPTARG;;
    esac
done

# SET TF PATH
TF_IN_PATH=`which tf 2>/dev/null`
if [ -f ${TF_IN_PATH} ]; then
    TF_DIR=`dirname "$TF_IN_PATH"`
fi
TF_HOME=${TF_HOME:-$TF_DIR}
TF_BIN="$TF_HOME/tf"
if [ ! -f $TF_BIN ]; then
    echo "ERROR: tf not found!"
    exit 4
fi

# USAGE
function usage() {
    echo "Usage: `basename $0` -c collection -d dir -u user,pass"
    exit 1
}

if [ "X$DIR" = 'X' ] || [ "X$COLLECTION" = 'X' ] || [ "X$USERPASS" = 'X' ] ; then
    usage
fi

# MAIN
name=`basename $DIR`
workspace="TMP_$name"
workdir="$dir/$name"
mkdir -p $workdir

$TF_BIN workspace -new $workspace -collection:$COLLECTION -login:$USERPASS

echo "$TF_BIN workfold -map -collection:$COLLECTION -workspace:$workspace -login:$USERPASS $DIR $workdir"
$TF_BIN workfold -map -collection:$COLLECTION -workspace:$workspace -login:$USERPASS $DIR $workdir

cd $workdir
$TF_BIN get -recursive -login:$USERPASS
cd $dir

$TF_BIN workfold -unmap -collection:$COLLECTION -workspace:$workspace -login:$USERPASS $workdir

$TF_BIN workspace -delete $workspace -collection:$COLLECTION -login:$USERPASS
