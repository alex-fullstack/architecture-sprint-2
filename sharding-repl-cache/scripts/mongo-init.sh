#!/bin/bash
source ./sharding-repl-cache/.env

docker compose -f ./sharding-repl-cache/compose.yaml exec -T shard1-1 mongosh --port ${MONGO_SHARD11_PORT} <<EOF

rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1-1:${MONGO_SHARD11_PORT}" },
      { _id : 1, host : "shard1-2:${MONGO_SHARD12_PORT}" },
      { _id : 2, host : "shard1-3:${MONGO_SHARD13_PORT}" }
    ]
  }
)
EOF

docker compose -f ./sharding-repl-cache/compose.yaml exec -T shard2-1 mongosh --port ${MONGO_SHARD21_PORT} <<EOF

rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 0, host : "shard2-1:${MONGO_SHARD21_PORT}" },
      { _id : 1, host : "shard2-2:${MONGO_SHARD22_PORT}" },
      { _id : 2, host : "shard2-3:${MONGO_SHARD23_PORT}" }
    ]
  }
)
EOF
