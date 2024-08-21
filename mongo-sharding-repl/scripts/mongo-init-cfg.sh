#!/bin/bash
source .env

docker compose exec -T configSrv mongosh --port ${MONGO_CFG_SERVER_PORT} <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:${MONGO_CFG_SERVER_PORT}" }
    ]
  }
)
EOF
