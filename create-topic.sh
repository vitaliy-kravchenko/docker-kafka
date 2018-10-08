#!/bin/bash

if [[ -n $KAFKA_CREATE_TOPICS ]]; then
  for i in $(seq 1 10); do
    nc -z $HOSTNAME 9092
    if [ $? -eq 0 ]; then
      break
    elif [ $i -eq 10 ]; then
      exit 1
    fi
    sleep 2
  done
  IFS=','; for topicToCreate in $KAFKA_CREATE_TOPICS; do
    echo "creating topics: $topicToCreate"
    IFS=':' read -a topicConfig <<< "$topicToCreate"
    if [ ${topicConfig[3]} ]; then
      JMX_PORT='' /kafka/bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_SERVER --replication-factor ${topicConfig[2]} --partitions ${topicConfig[1]} --topic "${topicConfig[0]}" --config cleanup.policy="${topicConfig[3]}" --if-not-exists
    else
      JMX_PORT='' /kafka/bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_SERVER --replication-factor ${topicConfig[2]} --partitions ${topicConfig[1]} --topic "${topicConfig[0]}" --if-not-exists
    fi
  done
fi
