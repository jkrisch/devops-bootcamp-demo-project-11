#!/usr/bin/bash

export CLUSTERNAME=eks-cluster-jk

#Deploy eks cluster using eksctl with 3 nodes (using nodegroup)
eksctl create cluster --name $CLUSTERNAME \
--region eu-central-1  \
--version 1.29 \
--node-type t2.small \
--nodes 3 \
--kubeconfig=$HOME/.kube/config.$CLUSTERNAME.yaml \
--asg-access


#Deploy fargate profile using ekscontrol
eksctl create fargateprofile \
    --cluster $CLUSTERNAME \
    --name fargate-profile-eks-jk \
    --namespace my-java-app-ns \


export KUBECONFIG="$HOME/.kube/config.$CLUSTERNAME.yaml"
