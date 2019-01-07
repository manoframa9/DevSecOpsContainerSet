pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args "-v /app/maven/.m2:/root/.m2 --privileged=true -v \$PWD:/src  --net devopsnet"
        }
    }

    stages {
        stage('Build') { 
            steps {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/master']],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [[$class: 'CleanCheckout']],
                        userRemoteConfigs: [[credentialsId: '', url: ' https://github.com/gabrielf/maven-samples.git']]
                    ])
                sh """
                pwd 
                ls -la
                mvn -B -DskipTests clean install package org.owasp:dependency-check-maven:check -Dformat=XML
                mvn org.cyclonedx:cyclonedx-maven-plugin:makeAggregateBom
                mvn sonar:sonar -Dsonar.host.url=http://sonarqube.mycrop.com:9000 -Dsonar.projectName=MyExample -Dsonar.projectKey=MyPOC 
                """
                dependencyTrackPublisher artifact: "target/dependency-check-report.xml", artifactType: 'scanResult', projectId: 'ecde71ec-c909-4659-ad58-36d9536a5616', synchronous: false
                dependencyTrackPublisher artifact: "target/bom.xml", artifactType: 'bom', projectId: 'ecde71ec-c909-4659-ad58-36d9536a5616', synchronous: false
                dependencyCheckPublisher canComputeNew: false, canRunOnFailed: true, defaultEncoding: '', healthy: '', pattern: '**/dependency-check-report.xml', unHealthy: ''
            }
        }
    }
}