FROM openjdk:8-jdk-slim

ENV KAFKA_VERSION 1.1.0
ENV SCALA_VERSION 2.12

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -y install curl netcat

RUN curl -O http://www-us.apache.org/dist/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xzf kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    mv kafka_"$SCALA_VERSION"-"$KAFKA_VERSION" /kafka

RUN mkdir /tmp/zookeeper

WORKDIR /kafka

COPY ./create-topic.sh ./
COPY ./cmd.sh ./

RUN chmod +x ./*.sh

EXPOSE 9092 2888 3888 2181

ENTRYPOINT ["./cmd.sh"]

CMD ["zookeeper"]
