cd $HOME/elasticsearch/elasticsearch-8.14.2/bin/
# Reset the password for the elastic user and capture the output
output=$(echo "y" | ./elasticsearch-reset-password -u elastic 2>&1)
ELASTIC_PASSWORD=$(echo "$output" | grep -oP 'New value: \K(\S+)')

# Wait for the variable to be set
while [ -z "$ELASTIC_PASSWORD" ]; do
  sleep 1
  output=$(echo "y" | ./elasticsearch-reset-password -u elastic 2>&1)
  ELASTIC_PASSWORD=$(echo "$output" | grep -oP 'New value: \K(\S+)')
done

export ELASTICSEARCH_PASSWORD=$ELASTIC_PASSWORD

echo "export ELASTICSEARCH_PASSWORD=\"$ELASTIC_PASSWORD\"" >> $HOME/.bashrc
