FROM openjdk:8-jre-slim
RUN apt update && apt install -y curl
ARG ZK_VER=3.5.8
ENV ZK_HOME /opt/zookeeper-latest
RUN curl --show-error --location --remote-name \
    https://downloads.apache.org/zookeeper/zookeeper-${ZK_VER}/apache-zookeeper-${ZK_VER}-bin.tar.gz
RUN curl --show-error --location --remote-name \
    https://downloads.apache.org/zookeeper/zookeeper-${ZK_VER}/apache-zookeeper-${ZK_VER}-bin.tar.gz.sha512
RUN sha512sum -c apache-zookeeper-${ZK_VER}-bin.tar.gz.sha512
RUN tar -xzf apache-zookeeper-${ZK_VER}-bin.tar.gz -C /opt
RUN ln -s /opt/apache-zookeeper-* /opt/zookeeper-latest && \
    mkdir -p $ZK_HOME/data && \
    mv $ZK_HOME/conf/zoo_sample.cfg $ZK_HOME/conf/zoo.cfg && \
    sed -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg && \
    sed -i -r "s|#autopurge|autopurge|g" $ZK_HOME/conf/zoo.cfg
WORKDIR $ZK_HOME
EXPOSE 2181 2888 3888
CMD ["bin/zkServer.sh", "start-foreground"]
