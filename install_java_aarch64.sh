#!/bin/bash
cd /var/local
mkdir ./jdk && tar -zxvf java.tar.gz -C ./jdk --strip-components 1
mkdir /usr/java && mv jdk /usr/java
export JAVA_HOME=/usr/java/jdk
export JRE_HOME=/usr/java/jdk/jre
export CLASSPATH=.:/usr/java/jdk/lib:/usr/java/jdk/jre/lib:$CLASSPATH
export JAVA_PATH=/usr/java/jdk/bin:/usr/java/jdk/jre/bin
export PATH=$PATH:/usr/java/jdk/bin:/usr/java/jdk/jre/bin
rm -rf java.tar.gz