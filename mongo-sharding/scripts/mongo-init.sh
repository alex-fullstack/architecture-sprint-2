#!/bin/bash
source .env

docker compose exec -T shard1 mongosh --port ${MONGO_SHARD1_PORT} <<EOF

rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1:${MONGO_SHARD1_PORT}" }
    ]
  }
)
EOF

docker compose exec -T shard2 mongosh --port ${MONGO_SHARD2_PORT} <<EOF

rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 0, host : "shard2:${MONGO_SHARD2_PORT}" }
    ]
  }
)
EOF
