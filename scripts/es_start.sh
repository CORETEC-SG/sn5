#!/bin/bash

check_env_variable() {
    if [ -z "${!1}" ]; then
        echo "Error: Environment variable '$1' is not set."
        exit 1
    fi
}

check_env_variable "RUNPOD_TCP_PORT_70001" $RUNPOD_TCP_PORT_70001
check_env_variable "RUNPOD_TCP_PORT_70002" $RUNPOD_TCP_PORT_70002

cd $HOME/elasticsearch/elasticsearch-8.14.2/
# ./bin/elasticsearch -E http.port=$RUNPOD_TCP_PORT_70001 -E transport.port=$RUNPOD_TCP_PORT_70002
./bin/elasticsearch 

echo "ELASTICSEARCH STARTED!"
