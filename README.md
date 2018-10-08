To create topics on every start you need to add KAFKA_CREATE_TOPICS variable to broker container:
```bash
KAFKA_CREATE_TOPICS="topic_one:1:3,topic_two:1:1:compact"
```
`topic_one` will have 1 partition and 3 replicas and `topic_two` will have 1 partition, 1 replica and `cleanup.policy` set to `compact`.
