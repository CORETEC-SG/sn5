FROM ubuntu:latest

# Install software-properties-common to get add-apt-repository command
RUN apt-get update && apt-get install -y software-properties-common

# Add deadsnakes PPA for Python 3.12 (uncomment if you specifically need 3.12)
# RUN add-apt-repository ppa:deadsnakes/ppa

# Add Node.js repository
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    curl \
    wget \
    tar \
    python3 \
    python3-venv \
    python3-pip \
    nodejs \
    npm \
    htop \
    nano \
    git && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user 'appuser'
RUN useradd -m -d /home/appuser -s /bin/bash appuser

# Set the working directory
WORKDIR /home/appuser

# Copy scripts into the container
COPY --chown=appuser:appuser scripts /home/appuser/scripts

# Make scripts executable
RUN chmod +x /home/appuser/scripts/*.sh

# Expose necessary ports (adjust as needed for your application)
EXPOSE 40000-41000

ENV ELASTICSEARCH_HOST="https://localhost:9200"
ENV ELASTICSEARCH_USERNAME="elastic"
ENV ELASTICSEARCH_PASSWORD=""

# Switch to non-root user
USER appuser

# Install pm2 locally for the user
RUN npm install pm2

# Add npm binary directory to PATH
ENV PATH="/home/appuser/node_modules/.bin:${PATH}"

# Start the application using the start script
CMD ["sh", "-c", "/home/appuser/scripts/start.sh"]
