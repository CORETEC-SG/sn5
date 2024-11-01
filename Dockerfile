# Create the build image
FROM ubuntu:latest as build

# Update package lists and install necessary packages
RUN apt-get update && apt-get upgrade -y  && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    curl \
    wget \
    tar \
    vim \
    python3 \
    python3-venv \
    python3-pip \
    nodejs \
    npm \
    htop \
    nano \
    git && \
    rm -rf /var/lib/apt/list/*

# Install pm2 locally for the user
RUN npm install pm2 -g

# Set the home directory
ENV HOME=/home/appuser

# Create a non-root user 'appuser'
RUN useradd -m -d $HOME -s /bin/bash appuser

# Set the working directory
WORKDIR /home/appuser

# Switch to non-root user
USER appuser

# Copy scripts into the container
COPY --chown=appuser:appuser scripts $HOME/scripts

# Make scripts executable
RUN chmod +x $HOME/scripts/*.sh

# Install Elasticsearch
RUN mkdir -p $HOME/elasticsearch && \
    cd $HOME/elasticsearch && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.14.2-linux-x86_64.tar.gz && \
    tar -xzf elasticsearch-8.14.2-linux-x86_64.tar.gz && \
    rm elasticsearch-8.14.2-linux-x86_64.tar.gz && \
    sed -i '$ a\path.repo: /home/appuser/esbackup' $HOME/elasticsearch/elasticsearch-8.14.2/config/elasticsearch.yml

# Copy the pre-installed ventor file data to elasticsearch database
COPY data/esbackup_*.tar.gz $HOME/
RUN cat $HOME/esbackup_*.tar.gz > $HOME/esbackup.tar.gz && \
    tar -xzf $HOME/esbackup.tar.gz && \
    rm $HOME/esbackup*.tar.gz

# install SN5
RUN cd $HOME && \
    git clone https://github.com/OpenKaito/openkaito.git && \
    cd openkaito && \
    python3 -m venv venv && \
    . venv/bin/activate && \
    # python3 -m pip install -U pip wheel setuptools && \
    python3 -m pip install --no-cache-dir -r requirements.txt && \
    python3 -m pip install --no-cache-dir -e . && \
    cd ..

# Expose necessary ports (adjust as needed for your application)
EXPOSE 40000-41000

ENV ELASTICSEARCH_HOST="https://localhost:9200"
ENV ELASTICSEARCH_USERNAME="elastic"
ENV ELASTICSEARCH_PASSWORD=""

# Add npm binary directory to PATH
ENV PATH="$HOME/node_modules/.bin:${PATH}"

# Configure the elasgicsearch path in environment variables
ENV PATH="$HOME/elasticsearch/elasticsearch-8.14.2/bin:${PATH}"

# Start the application using the start script
CMD ["sh", "-c", "$HOME/scripts/start.sh"]
