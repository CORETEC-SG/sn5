mkdir -p $HOME/elasticsearch
cd $HOME/elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.14.2-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.14.2-linux-x86_64.tar.gz.sha512
shasum -a 512 -c elasticsearch-8.14.2-linux-x86_64.tar.gz.sha512
tar -xzf elasticsearch-8.14.2-linux-x86_64.tar.gz

echo "ELASTICSEARCH DONE!"
