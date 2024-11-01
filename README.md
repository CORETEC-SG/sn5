# Bittensor Subnet 5 OpenKaito Fast Deployment Guide

1. The repository contains the dockerfile and installation scripts for the bittensor subnet 5 node. 
2. The dockerfile will install the required elasticsearch and openkaito dependencies and run the bittensor node.
3. When the dockerfile is built, the /data/esbackup folder will be created and the elasticsearch data (both eth_denver and eth_cc7) will be stored in this folder.
3. When the start.sh script is run, the elasticsearch data will be restored from the /data/esbackup folder.  The purpose to restore the data is to save the embedding time for the ES dataset.
5. The program also included the multiple worker version of vector_index_eth_*.py.
   Once if the dataset is changed in the future, it will be required to re-run the embedding again.
6. The repo also contains the github actions template to build the docker to either docker hub or GHCR.
7. It is required to create the runpod template for deploy docker image to runpod (only need to create once) and update the template ID to RUNPOD_TEMPLATE_ID in the github action environment variables.
    The runpod template will need to include the belows items.
    #### Runpod Template Setting
        - container image name (ghcr.io/<your repo name>/sn5_app:latest), 
        - expose tcp ports=70000,70001,70002
        - MINER_ID=default, 
        - WALLET_NAME=test, 
        - OPENAI_API_KEY=123456
        - Other environment settings
10. To use the github workflow, the below environment variables (named as env) are required to be set in the github repository secrets.
    #### Github Actions Environment Secrets:
        - a. DOCKER_USERNAME (For docker hub)
        - b. DOCKER_TOKEN (For docker hub)
        - c. GHCR_PAT (For GHCR Personal Access Token)
        - d. RUNPOD_API_KEY (can be found in the runpod setting/API keys dashboard)
    #### Github Actions Environment Variables:
        - e. RUNPOD_TEMPLATE_ID (can be found in the runpod template dashboard)
9. Trigger the build_deploy_runpod_ghcr.yml on Github Actions to build the docker image and deploy it to the RUNPOD.  Use build_deploy_runpod.yml to push the docker on DOCKER HUB.
10. If the docker image is built and deployed successfully, the RUNPOD will be created and the bittensor node will be running.
11. Please make the Github repo/packages as public to access the docker image from the RUNPOD.  
    If the Github GHCR package is private, the access credentials need to be provided to the RUNPOD.
12. If multiple docker need to be created, just trigger the deploy_runpod_ghcr.yml on Github Actions for multiple times.
    Please be noted only one UID can be mapping with one Bittensor hotkey since the metagraph will bind the UID with AXON port.
14. To check the embedding data set in the runpod, user can use below curl command.
    - curl -u elastic:$ELASTICSEARCH_PASSWORD -k -XGET "https://localhost:9200/_cat/indices?v"
14. The current subnet 5 deprecate StructuredSearchSynapse and DiscordSearchSynapse and adjust the ratio of TextEmbeddingSynapse:SemanticSearchSynapse to be 80%:20%.
15. The runpod rental server CPU/Memory spec can be changed in below "cpu3c-2-4" in the runpod deploy yml file, cpu3c can be changed to cpu5, 2 means 2vpcs, 4 means 4GB memory.
    It is suggested to get higher CPU to reduce the latency.  The cost can be viewed in the runpod deploy pod main page.
    - curl -X POST https://api.runpod.io/graphql?api_key=${RUNPOD_API_KEY} \
           -H "content-type: application/json" \
           -d '{"query": " mutation { deployCpuPod( input: { cloudType: SECURE, containerDiskInGb: 10, dataCenterId: null, instanceId: \"cpu3c-2-4\", networkVolumeId: null, startJupyter: true, startSsh: true, templateId: \"${{env.RUNPOD_TEMPLATE_ID}}\", volumeKey: null, env: [{key: \"a\", value: \"1\"}, {key: \"b\", value: \"2\"}] }) { id, machineId }}"}'
    
