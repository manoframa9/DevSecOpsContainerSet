# Deployment prep
sudo su
cd /
mkdir -f -m 774 app
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
sudo mkdir -f -m 774 /app/jenkins_home
sudo mkdir -f -m 774 /app/maven
sudo mkdir -f -m 774 /app/gradle
sudo mkdir -f -m 774 /app/npm
##================================== GitLab ===============================
####>> require At less 4 Cores 
####>> require At less 4 GB
# Prep for Jenkins server
sudo mkdir -f -m 774 /app/gitlab_home
###=========== >> generate certificate
sudo mkdir -m 774 /app/reverse-proxy
sudo openssl genrsa -des3 -out /app/reverse-proxy/default.key 1024
sudo openssl req -new -key /app/reverse-proxy/default.key -out /app/reverse-proxy/default.csr
sudo cp /app/reverse-proxy/default.key /app/reverse-proxy/default.key.org
sudo openssl rsa -in /app/reverse-proxy/default.key.org -out /app/reverse-proxy/default.key
sudo openssl x509 -req -days 3650 -in /app/reverse-proxy/default.csr -signkey /app/reverse-proxy/default.key -out /app/reverse-proxy/default.crt
cp /app/reverse-proxy/default.crt /app/reverse-proxy/mycrop.com.crt
cp /app/reverse-proxy/default.key /app/reverse-proxy/mycrop.com.key
###==========> SonarQube
sudo mkdir -f -m 777 /app/sonarqube_home
sudo mkdir -f -m 777 /app/sonarqube_home/conf
sudo mkdir -f -m 777 /app/sonarqube_home/logs
sudo mkdir -f -m 777 /app/sonarqube_home/extensions
###===========> SonarQube DB (Postgres)
sudo mkdir -f -m 774 /app/sonarqubedb_home
###===========> Dependency-Track
sudo mkdir -f -m 774 /app/dependencytrack_home
###===========> Alfresco DB (Postgres)
sudo mkdir -f -m 774 /app/alfrescodb_home
###===========> Alfresco A-MQ
sudo mkdir -f -m 774 /app/alfrescomq_home
###===========> Alfresco search services (Solr6)
sudo mkdir -f -m 777 /app/alfrescosolr6
###===========> Alfresco
sudo mkdir -f -m 774 /app/alfresco_data
###===========> Alfresco share
sudo mkdir -f -m 774 /app/alfrescoshare
sudo mkdir -f -m 774 /app/alfrescoshare/config