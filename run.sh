#!/bin/sh

dir=`dirname $0`
dir=`cd $dir; pwd`

tomcat="$HOME/workspace/apache-tomcat-7.0.42"
war_name="congou.war"

cd $dir/PDD.CLOUD/ngerp20131025/ngerp
ant war 
cd $dir
cp -rf $tomcat $dir/tomcat
mv $dir/PDD.CLOUD/ngerp20131025/ngerp/$war_name $dir/tomcat/webapps

$dir/tomcat/bin/startup.sh

$dir/tomcat/bin/shutdown.sh
