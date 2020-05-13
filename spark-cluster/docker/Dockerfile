FROM com.navidhsz.data/jdk8:latest

MAINTAINER "navid.hsz"

EXPOSE 21050
EXPOSE 50070
EXPOSE 50075
EXPOSE 18081
EXPOSE 18080
EXPOSE 10000
EXPOSE 50010

EXPOSE 8088
EXPOSE 9000
EXPOSE 9092
EXPOSE 8020
EXPOSE 4040
EXPOSE 8042
EXPOSE 2222

ENV LD_LIBRARY_PATH=/opt/cluster/native:/usr/lib/jvm/jre/lib/amd64/server
ENV HADOOP_HOME=/opt/cluster/hadoop
ENV HIVE_HOME=/opt/cluster/hive
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV SPARK_HOME=/opt/cluster/spark
ENV YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV SPARK_SCALA_VERSION=2.11

ENV HADOOP_YARN_HOME=${HADOOP_HOME}
ENV HADOOP_MAPRED_HOME=${HADOOP_HOME}
ENV HADOOP_COMMON_HOME=${HADOOP_HOME}

ENV SPARK_SCALA_VERSION=2.11
ENV PATH=${PATH}:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${HIVE_HOME}/bin

ENV HADOOP_VER=2.10.0
ENV SPARK_VER=2.4.5
ENV HIVE_VER=2.3.7

USER root

COPY resources/ssh/sshd_config /etc/ssh/

RUN groupadd hadoop; \
    adduser -G hadoop spark; \
    echo 'hadoop' | passwd spark --stdin; \
    usermod -aG wheel spark; \
    service sshd restart; \
    cd /opt; \

    mkdir -p /opt/janus/hive_scripts; \

    mkdir -p /opt/cluster/hadoop/logs; \
    mkdir -p /opt/cluster/hive/logs; \
    mkdir -p /opt/cluster/spark/logs; \
    mkdir -p /opt/cluster/native; \
    mkdir -p /opt/resources; \
    mkdir -p /var/run/hdfs-sockets; \
    chown -R spark:hadoop /var/run/hdfs-sockets; \

    curl -v -L -b -O "http://ftp.heanet.ie/mirrors/www.apache.org/dist/hadoop/common/hadoop-2.10.0/hadoop-2.10.0.tar.gz" > hadoop-${HADOOP_VER}.tar.gz; \
    curl -v -L -b -O "http://ftp.heanet.ie/mirrors/www.apache.org/dist/hive/hive-2.3.7/apache-hive-2.3.7-bin.tar.gz" > apache-hive-${HIVE_VER}-bin.tar.gz; \
    curl -v -L -b -O "http://ftp.heanet.ie/mirrors/www.apache.org/dist/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz" > spark-${SPARK_VER}-bin-hadoop2.7.tgz; \

    tar xvf hadoop-${HADOOP_VER}.tar.gz; \
    tar xvf apache-hive-${HIVE_VER}-bin.tar.gz; \
    tar xvf spark-${SPARK_VER}-bin-hadoop2.7.tgz; \

    rm hadoop-${HADOOP_VER}.tar.gz; \
    rm apache-hive-${HIVE_VER}-bin.tar.gz; \
    rm spark-${SPARK_VER}-bin-hadoop2.7.tgz; \


    mv hadoop-${HADOOP_VER}/* /opt/cluster/hadoop; \
    mv apache-hive-${HIVE_VER}-bin/* /opt/cluster/hive; \
    mv spark-${SPARK_VER}-bin-hadoop2.7/* /opt/cluster/spark; \

    cp /opt/cluster/spark/jars/spark-network-shuffle_2.11-${SPARK_VER}.jar /opt/cluster/hadoop/share/hadoop/yarn; \
    cp /opt/cluster/spark/yarn/spark-${SPARK_VER}-yarn-shuffle.jar /opt/cluster/hadoop/share/hadoop/yarn; \

    rm -rf hadoop-${HADOOP_VER}; \
    rm -rf apache-hive-${HIVE_VER}-bin; \
    rm -rf spark-${SPARK_VER}-bin-hadoop2.7; \

    rm -rf /opt/cluster/spark/lib/spark2/conf/*; \
    rm -rf /opt/cluster/spark/lib/spark2/work/*; \

    chown spark -R /opt/cluster; \
    mkdir -p /opt/hadoop_data/hdfs/namenode; \
    mkdir -p /opt/hadoop_data/hdfs/datanode; \
    mkdir -p /opt/hadoop_data/hdfs/tmp; \

    chown spark -R /opt/hadoop_data; \

    #install postgres driver
	curl -v -L -b -O https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar > postgresql-9.4.1212.jar; \
	mv postgresql-9.4.1212.jar /opt/cluster/hive/lib; \

	wget http://www.congiu.net/hive-json-serde/1.3.8/hdp23/json-serde-1.3.8-jar-with-dependencies.jar; \
    mv json-serde-1.3.8-jar-with-dependencies.jar /opt/cluster/hive/lib; \

    echo 'export HADOOP_HOME=/opt/cluster/hadoop' >> /etc/profile; \
    echo 'export HADOOP_INSTALL=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_YARN_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export YARN_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> /etc/profile; \
    echo 'export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> /etc/profile; \
    echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> /etc/profile; \
    echo 'export HIVE_HOME=/opt/cluster/hive' >> /etc/profile; \
    echo 'export HIVE_CONF_DIR=/opt/cluster/hive/conf' >> /etc/profile; \
    echo 'export SPARK_HOME=/opt/cluster/spark' >> /etc/profile; \
    echo 'export SPARK_SCALA_VERSION=2.11' >> /etc/profile; \
    echo 'export PATH=$PATH:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$HADOOP_HOME/bin:$HIVE_HOME/bin' >> /etc/profile; \
    echo 'export LD_LIBRARY_PATH=/opt/cluster/native/:/usr/lib/jvm/jre/lib/amd64/server' >> /etc/profile; \
    echo 'export HADOOP_COMMON_LIB_NATIVE_DIR="/opt/cluster/native"' >> /etc/profile; \
    echo 'export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true -Djava.library.path=/opt/cluster/native:/usr/lib/jvm/jre/lib/amd64/server"' >> /etc/profile; \
    echo 'export JAVA_HOME=/usr/lib/jvm/java' >> /etc/profile; \

    source /etc/profile

COPY resources/ /opt/resources/
COPY resources/etc/hadoop/* /opt/cluster/hadoop/etc/hadoop/
COPY resources/lib/native/* /opt/cluster/native/

RUN mv /opt/resources /home/spark/; \
    mkdir -p /etc/hadoop/conf; \
    ln -s /opt/cluster/hadoop/etc/hadoop/core-site.xml  /etc/hadoop/conf/core-site.xml; \
    ln -s /opt/cluster/hadoop/etc/hadoop/hdfs-site.xml  /etc/hadoop/conf/hdfs-site.xml; \
    chown -R spark:hadoop /home/spark/resources

USER spark

RUN ln -s /opt/cluster/native/libnativetask.so.1.0.0 /opt/cluster/native/libnativetask.so; \
    ln -s /opt/cluster/native/libsnappy.so.1.1.3 /opt/cluster/native/libsnappy.so.1; \
    ln -s /opt/cluster/native/libsnappy.so.1.1.3 /opt/cluster/native/libsnappy.so; \
    ssh-keygen -t rsa -P "" -f $HOME/.ssh/id_rsa; \
    cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys; \
    chmod 0600 ~/.ssh/authorized_keys; \
    #prepare hadoop
    hadoop namenode -format; \
    hadoop-daemon.sh start datanode; \
    hadoop-daemon.sh start namenode; \
    yarn-daemon.sh start resourcemanager; \
    yarn-daemon.sh start nodemanager; \
    mr-jobhistory-daemon.sh start historyserver; \
	hadoop fs -mkdir /tmp; \
	hadoop fs -mkdir -p /user/hive/warehouse; \
	hadoop fs -chmod g+w /tmp; \
    hadoop fs -chmod g+w /user/hive/warehouse; \
    hadoop fs -mkdir /user/spark; \
    hadoop fs -mkdir /user/spark/applicationHistory; \
    hadoop fs -chmod 1777 /user/spark/applicationHistory

USER root

RUN mkdir -p /var/run/spark; \
    mkdir -p /var/log/spark; \
    chown -R spark:hadoop /var/run/spark; \
    chown -R spark:hadoop /var/log/spark; \
    chown -R spark:hadoop /opt/cluster

USER spark

COPY resources/etc/spark/* /opt/cluster/spark/conf/
COPY resources/etc/spark/* /opt/cluster/spark/conf/


ENV SPARK_DIST_CLASSPATH="$HIVE_HOME/lib/*:$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"

USER root

COPY resources/etc/hive/conf/* /opt/cluster/hive/conf/

COPY resources/init.sh /opt/
COPY resources/supervisord.conf /etc/

RUN chmod +x /opt/init.sh

ENTRYPOINT ["/opt/init.sh"]
