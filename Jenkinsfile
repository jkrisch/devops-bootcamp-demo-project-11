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
    //Setting the aws credentials env variables 
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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
                    echo 'deploying docker image to EKS cluster'
                    
                }

            }
        }
    }
}
