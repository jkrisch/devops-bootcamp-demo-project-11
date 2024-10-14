#!/user/bin/env groovy
library identifier: 'my-shared-lib@main', retriever: modernSCM(
    [
        $class: 'GitSCMSource',
        remote: 'https://github.com/jkrisch/devops-bootcamp-project-8-shared-library.git'
        //in case the repo is private:
        //credentialsId:<<name-of-credentials-in-jenkins-store>>
    ]
)
pipeline {
    agent any

   tools {
        maven 'maven-3.9'
    }
    
   environment{
    IMAGE_NAME = "jaykay84/demo-app"
    IMAGE_TAG = "1.0.0."
   }
    stages {
        stage('build app') {
            steps {
                script {
                    buildJar()
                }
            }
        }
        
        stage('build image'){
            steps{
                script{
                    withCredentials([
                        usernamePassword(credentialsId:'docker-login', passwordVariable: 'PASS', usernameVariable: 'USER')
                        ]){
                            dockerLogin(USER, PASS)

                            buildImage("jaykay84", "demo-app", "${env.TAG}")

                            dockerPush("jaykay84", "demo-app", "${env.TAG}")
                        }
                }
            }
        }

        stage('deploy') {
            steps {
                script {
                    echo 'deploying nginx container'
                    withKubernetesConfig([
                        credentialsId: 'do-k8s-config', serverUrl: 'https://23e43024-01f5-42c1-9d87-3d887613b150.k8s.ondigitalocean.com'
                    ]){
                        sh 'kubectl create deployment nginx-deployment --image=nginx'
                    }
                    
                }

            }
        }
    }
}
