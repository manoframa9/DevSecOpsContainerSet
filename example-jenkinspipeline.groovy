pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args "-v /root/.m2:/root/.m2 --privileged=true -v \$PWD:/src  --net devopsnet"
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
                mvn -B -DskipTests clean package sonar:sonar -Dsonar.host.url=http://sonarqube.mycrop.com:9000 -Dsonar.projectName=ExampleSolar -Dsonar.projectKey=SolArPOC -Dsonar.login=9a996709f1798ab6918cc095f32a423dbe1fee94
                """
            }
        }
    }
}
