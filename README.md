# Demo Projects - Kubernetes on AWS - EKS

## Deploy to EKS cluster from Jenkins Pipeline

1. first we have to install kubectl and aws-iam-authenticator (necessary for authentication with AWS and with EKS) on the jenkins controller node
2. As I run my jenkins controller within a container I adjust the Dockerfile so that kubectl is always available (even if we remove the container)
3. And lastely we need to configure credentials on our jenkins controller node which contain the aws secret and aws secret key
4. Install the eks cluster using the [install script](./install-eks-cluster.sh)
5. We also need to copy the local .kube/config file to the container respectively such as we have the proper connection information needed to connect to the eks cluster
For this we use the [iam config template](./iam-config.yaml) and fill in the respective information (which we get from our local kubec config file, which has been created be the eks cli tool)
And before that we need to access the container and create the .kube folder in the /var/jenkins_home directory.

``` bash
docker exec jenkins-controller sh -c "mkdir /var/jenkins_home/.kube"
docker cp kubeconfig jenkins_controller:/var/jenkins_home/.kube/config
```

6. Then we add the credentials for AWS on jenkins (to be able to connect to the eks cluster using the aws-iam-authenticator)
7. Afterwards we adjust our [Jenkinsfile](./Jenkinsfile) to be able to connect and deploy to our eks cluster.


![alt text](image.png)