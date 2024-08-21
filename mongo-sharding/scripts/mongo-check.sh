#!/bin/bash
source .env

docker compose exec -T mongos_router mongosh --port ${MONGO_ROUTER_PORT} <<EOF

sh.addShard( "shard1/shard1:${MONGO_SHARD1_PORT}");
sh.addShard( "shard2/shard2:${MONGO_SHARD2_PORT}");

sh.enableSharding("${MONGO_DATABASE_NAME}");
sh.shardCollection("${MONGO_DATABASE_NAME}.${MONGO_COLLECTION_NAME}", { "name" : "hashed" } )

use ${MONGO_DATABASE_NAME}

for(var i = 0; i < 1000; i++) db.${MONGO_COLLECTION_NAME}.insert({age:i, name:"ly"+i})

EOF

docker compose exec -T mongos_router mongosh --port ${MONGO_ROUTER_PORT} --quiet <<EOF
use ${MONGO_DATABASE_NAME}
db.${MONGO_COLLECTION_NAME}.countDocuments()
EOF

docker compose exec -T shard1 mongosh --port ${MONGO_SHARD1_PORT} --quiet <<EOF
use ${MONGO_DATABASE_NAME}
db.${MONGO_COLLECTION_NAME}.countDocuments()
EOF

docker compose exec -T shard2 mongosh --port ${MONGO_SHARD2_PORT} --quiet <<EOF
use ${MONGO_DATABASE_NAME}
db.${MONGO_COLLECTION_NAME}.countDocuments()
EOF