#!/bin/bash

curl -u elastic:$ELASTICSEARCH_PASSWORD -k -X PUT "https://localhost:9200/_snapshot/my_backup" -H "Content-Type: application/json" -d '{
  "type": "fs",
  "settings": {
    "location": "/home/appuser/esbackup",
    "compress": true
  }
}'

curl -u elastic:$ELASTICSEARCH_PASSWORD -k -X POST "https://localhost:9200/_snapshot/my_backup/snapshot_1/_restore" -H "Content-Type: application/json" -d '{
  "indices": "eth_denver",
  "include_global_state": false,
  "rename_pattern": "index_(.+)",
  "rename_replacement": "restored_index_$1"
}'

echo "ELASTICSEARCH RESTORE DONE!"