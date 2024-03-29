#!/bin/bash
mkdir -p /usr/share/maven /usr/share/maven/ref

for i in {1..100};do
    timeout 60 curl -fsSL -o /tmp/apache-maven.tar.gz $1/apache-maven-$2-bin.tar.gz && break || sleep 60
done

echo "$3  /tmp/apache-maven.tar.gz" | sha512sum -c -
tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1
rm -f /tmp/apache-maven.tar.gz
ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
