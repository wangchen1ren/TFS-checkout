#!/bin/sh

dir=`dirname $0`
dir=`cd $dir; pwd`

collection=$1
project=$2
user=$3

echo $collection, $project $user

workdir="$dir/$project"
mkdir -p $workdir

tf workspace -new $project -collection:$collection -login:$user

tf workfold -map -collection:$collection -workspace:$project -login:$user $/$project $workdir

cd $workdir
tf get -recursive -login:$user
cd $dir

tf workfold -unmap -collection:$collection -workspace:$project -login:$user $workdir

tf workspace -delete $project -collection:$collection -login:$user
