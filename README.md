# devops

Prerequisites:
1. Installed docker
    ==> if centos: https://docs.docker.com/install/linux/docker-ce/centos/
        other os you can go to above link an find guide for your os.
2. Installed docker-compose
    ==> https://docs.docker.com/compose/install/
3. Add a user(non-root) into docker group 
    ==> sudo usermod -aG docker $USER

The tool set are:
- Nginx-Reverse proxy (jwilder/nginx-proxy)
- Jenkins (BlueOcean)
- GitLab-CE
- SonarQube-CE
- Dependency-Track (OSS scan dashboard)
- Alfresco-CE suite (Project collaboration tool)
- Jira-Software (Issue tracking tool)

Usage:
1. Run deploymentScript.sh as below syntax
    deploymentScript.sh <server-ip>
2. Run dcup.sh as below
    ./dcup.sh [docker compose option eg. -d ]
3. Down the cluster by dcdown.sh
    ./dcdown.sh
