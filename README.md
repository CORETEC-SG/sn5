# Bittensor Subnet 5 OpenKaito Fast Deployment Guide.

1. The repository contains the dockerfile for the bittensor subnet 5 node.
2. The dockerfile will install the required elasticsearch and openkaito dependencies and run the bittensor node.
3. When the dockerfile is built, the /data/esbackup folder will be created and the elasticsearch data will be stored in this folder.
4. When the start.sh script is run, the elasticsearch data will be restored from the /data/esbackup folder.  
   The purpose to restore the data is to save the embedding time for the eth_denver dataset.
5. The program also included the multiple worker version of vector_index_eth_denver_dataset.py.
   Once if the dataset is changed in the future, it will be required to re-run the embedding again.
6. The repo also contains the github actions template to build the docker to either docker hub or GHCR.
7. It is required to create the runpod template for the docker image and update the template ID to RUNPOD_TEMPLATE_ID in the github variables.
   The runpod template will need to included the container image name (ghcr.io/<your repo name>/sn5_app:latest), expose tcp ports=70000,70001,70002, and the below environment variables.
   MINER_ID=default, WALLET_NAME=test, OPENAI_API_KEY=123456
10. To use the github workflow, the below environment variables are required to be set in the github repository secrets.
   environment secrets:
   a. DOCKER_USERNAME (For docker hub)
   b. DOCKER_TOKEN (For docker hub)
   c. GHCR_PAT (For GHCR Personal Access Token)
   d. RUNPOD_API_KEY (can be found in the runpod setting/API keys dashboard)
   environment variables:
   f. RUNPOD_TEMPLATE_ID (can be found in the runpod template dashboard)
9. Trigger the build_deploy_runpod_ghcr.yml on Github Actions to build the docker image and deploy it to the RUNPOD.
10. If the docker image is built and deployed successfully, the RUNPOD will be created and the bittensor node will be running.
11. Please make the repo/packages as public to access the docker image from the RUNPOD.  
    If the repo is private, the access crenetials need to be provided to the RUNPOD.
12. If multiple docker need to be created, just trgger the deploy_runpod_ghcr.yml on Github Actions for multiple times.
12. To check the embedding data set in the runpod, user can use below curl command.
   curl -u elastic:$ELASTICSEARCH_PASSWORD -k -XGET "https://localhost:9200/_cat/indices?v"