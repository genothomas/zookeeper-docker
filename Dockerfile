FROM openjdk:8-jre-alpine
ARG ZK_VER=3.5.8
ENV ZK_HOME=/opt/zookeeper-latest
RUN cd /tmp && apk add --no-cache bash tzdata \
    && wget -q https://downloads.apache.org/zookeeper/zookeeper-${ZK_VER}/apache-zookeeper-${ZK_VER}-bin.tar.gz \
    && wget -q https://downloads.apache.org/zookeeper/zookeeper-${ZK_VER}/apache-zookeeper-${ZK_VER}-bin.tar.gz.sha512 \
    && sha512sum -c apache-zookeeper-${ZK_VER}-bin.tar.gz.sha512 \
    && tar -xzf apache-zookeeper-${ZK_VER}-bin.tar.gz -C /opt \
    && ln -s /opt/apache-zookeeper-* $ZK_HOME \
    && mkdir -p $ZK_HOME/data \
    && mv $ZK_HOME/conf/zoo_sample.cfg $ZK_HOME/conf/zoo.cfg \
    && sed -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg \
    && sed -i -r "s|#autopurge|autopurge|g" $ZK_HOME/conf/zoo.cfg \
    && rm /tmp/* \
    && rm -rf /var/cache/apk/*
WORKDIR $ZK_HOME
EXPOSE 2181 2888 3888
CMD ["bin/zkServer.sh", "start-foreground"]
