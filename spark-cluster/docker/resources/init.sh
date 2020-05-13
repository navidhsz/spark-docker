#!/usr/bin/env bash

function startCluster ()
{
  su - spark -c "hadoop-daemon.sh start namenode"
  su - spark -c "hadoop-daemon.sh start datanode"
  su - spark -c "yarn-daemon.sh start resourcemanager"
  su - spark -c "yarn-daemon.sh start nodemanager"
  su - spark -c "mr-jobhistory-daemon.sh start historyserver"
  su - spark /opt/cluster/spark/sbin/start-all.sh
  sleep 2
  su - spark -c "hive --service metastore" &
  sleep 2
  if [ "${HIVE_DEBUGLOG}" = true ]; then
    su - spark -c "hive --service hiveserver2 --hiveconf hive.root.logger=DEBUG" &
  else
    su - spark -c "hive --service hiveserver2 --hiveconf hive.root.logger=INFO" &
  fi
  sleep 2
  su - spark -c  "/opt/cluster/spark/sbin/start-history-server.sh" &
  sleep 5

}

################################  Entry point #####################################
touch /var/log/cluster.log
service sshd start
startCluster

echo '######################## SPARK CLUSTER READY ########################'
echo '######################## SPARK CLUSTER READY ########################' >> /var/log/cluster.log
while true; do sleep 5000; done