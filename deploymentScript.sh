# Deployment prep
sudo su
adduser devops
cd /
mkdir -m 775 app
cd /app
# Pull significant images
docker pull maven:3-alpine
docker pull gradle:4.10-jdk8-alpine
docker pull jenkinsci/blueocean:1.8.4
docker pull gitlab/gitlab-ce:11.4.7-ce.0
docker pull owasp/dependency-track:3.3.1
# Create docker network
docker network create devopsnet
##================================== Nginx reverse proxy ===============================
##
##================================== Jenkins ===============================
####>> require At less 2GB
sudo mkdir -m 775 /app/jenkins_home
sudo mkdir -m 775 /app/maven
sudo mkdir -m 775 /app/gradle
sudo mkdir -m 775 /app/npm
##================================== GitLab ===============================
####>> require At less 4 Cores 
####>> require At less 4 GB
# Prep for Jenkins server
sudo mkdir -m 775 /app/gitlab_home
###=========== >> generate certificate
sudo mkdir -m 775 /app/reverse-proxy
sudo mkdir -m 775 /app/reverse-proxy/cert
sudo mkdir -m 775 /app/reverse-proxy/ngconf
sudo openssl genrsa -des3 -out /app/reverse-proxy/cert/default.key 1024
sudo openssl req -new -key /app/reverse-proxy/cert/default.key -out /app/reverse-proxy/cert/default.csr
sudo cp /app/reverse-proxy/cert/default.key /app/reverse-proxy/cert/default.key.org
sudo openssl rsa -in /app/reverse-proxy/cert/default.key.org -out /app/reverse-proxy/cert/default.key
sudo openssl x509 -req -days 3650 -in /app/reverse-proxy/cert/default.csr -signkey /app/reverse-proxy/cert/default.key -out /app/reverse-proxy/cert/default.crt
cp /app/reverse-proxy/cert/default.crt /app/reverse-proxy/cert/itmx.co.th.crt
cp /app/reverse-proxy/cert/default.key /app/reverse-proxy/cert/itmx.co.th.key
###==========> SonarQube
sudo mkdir -m 777 /app/sonarqube_home
sudo mkdir -m 777 /app/sonarqube_home/conf
sudo mkdir -m 777 /app/sonarqube_home/logs
sudo mkdir -m 777 /app/sonarqube_home/extensions
###===========> SonarQube DB (Postgres)
sudo mkdir -m 775 /app/sonarqubedb_home
###===========> Dependency-Track
sudo mkdir -m 775 /app/dependencytrack_home
###===========> Alfresco DB (Postgres)
sudo mkdir -m 775 /app/alfrescodb_home
###===========> Alfresco A-MQ
sudo mkdir -m 775 /app/alfrescomq_home
###===========> Alfresco search services (Solr6)
sudo mkdir -m 777 /app/alfrescosolr6
###===========> Alfresco
sudo mkdir -m 775 /app/alfresco_data
###===========> Alfresco share
sudo mkdir -m 775 /app/alfrescoshare
sudo mkdir -m 775 /app/alfrescoshare/config
###===========> Jira
sudo mkdir -m 775 /app/jira_home/
sudo mkdir -m 775 /app/jira_home/caches
sudo mkdir -m 775 /app/jira_home/caches/indexes
###==========> 
cat >/app/reverse-proxy/ngconf/jira.itmx.co.th_location <<EOF
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-Server \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
EOF
###===========> Jira DB
sudo mkdir -m 775 /app/jiradb_home
sudo mkdir -m 775 /app/jiradb_home/postgresql_data