#!/bin/bash
source .env

docker compose exec -T mongos_router mongosh --port ${MONGO_ROUTER_PORT} <<EOF

sh.addShard( "shard1/shard1-1:${MONGO_SHARD11_PORT},shard1-2:${MONGO_SHARD12_PORT},shard1-3:${MONGO_SHARD13_PORT}");
sh.addShard( "shard2/shard2-1:${MONGO_SHARD21_PORT},shard2-2:${MONGO_SHARD22_PORT},shard2-3:${MONGO_SHARD23_PORT}");

sh.enableSharding("${MONGO_DATABASE_NAME}");
sh.shardCollection("${MONGO_DATABASE_NAME}.${MONGO_COLLECTION_NAME}", { "name" : "hashed" } )

use ${MONGO_DATABASE_NAME}

for(var i = 0; i < 1000; i++) db.${MONGO_COLLECTION_NAME}.insert({age:i, name:"ly"+i})

EOF

docker compose exec -T mongos_router mongosh --port ${MONGO_ROUTER_PORT} --quiet <<EOF
use ${MONGO_DATABASE_NAME}
db.${MONGO_COLLECTION_NAME}.countDocuments()
EOF

docker compose exec -T shard1-1 mongosh --port ${MONGO_SHARD11_PORT} --quiet <<EOF
use ${MONGO_DATABASE_NAME}
db.${MONGO_COLLECTION_NAME}.countDocuments()
EOF

docker compose exec -T shard2-1 mongosh --port ${MONGO_SHARD21_PORT} --quiet <<EOF
use ${MONGO_DATABASE_NAME}
db.${MONGO_COLLECTION_NAME}.countDocuments()
EOF