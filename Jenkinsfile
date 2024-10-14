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
    //Setting the aws credentials env variables 
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    APP_NAME = "java-demo-app"
   }
    stages {
        stage('build app') {
            steps {
                script {
                    buildJar()
                }
            }
        }

        stage('increment version'){
            steps{
                script{
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                    -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                    versions:commit'

                    //read the new version from the pom.xml
                    def matcher = readFile('pom.xml') =~ '<version>(.+?)</version>'
                    def version = matcher[0][1]
                    env.TAG = "$version-$BUILD_NUMBER"
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
                    sh 'envsubst < kubernetes/deployment.yaml | kubectl apply -f -'
                    sh 'envsubst < kubernetes/service.yaml | kubectl apply -f -'                    
                }

            }
        }
        
        stage('commit version update'){
            steps{
                script{
                    withCredentials([
                        usernamePassword(credentialsId:'github-login', passwordVariable: 'PASS', usernameVariable: 'USER')
                ]){
                    sh '''
                        git config user.email jenkins@example.com
                        git config user.name jenkins-automation
                        git status
                        git branch
                        git config --list
                    '''
                    
                    sh "git remote set-url origin https://${USER}:${PASS}@github.com/jkrisch//devops-bootcamp-demo-project-11.git"
                    
                    sh 'git add pom.xml'
                    sh 'git commit -m "ci: version bump"'
                    sh 'git push origin HEAD:increment-version'
                }
                }
            }
        }
    }
}
