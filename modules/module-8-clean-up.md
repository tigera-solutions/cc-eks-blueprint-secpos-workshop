# Module 8 - Clean up

Delete the app manifests and ```LoadBalancer``` services.

   ```bash
   kubectl delete -f app-manifests
   ```

Delete the EKS cluster with ```eksctl delete```.

   ```bash
   eksctl delete cluster --name $CLUSTERNAME --region $REGION
   ```

CloudFormation/eksctl logs will show the teardown of the nodegroup and the cluster, for example:

   ```bash
   2023-03-22 19:16:50 [ℹ]  deleting EKS cluster "cc-eks-secpos-workshop"
   2023-03-22 19:16:51 [ℹ]  will drain 0 unmanaged nodegroup(s) in cluster "cc-eks-secpos-workshop"
   2023-03-22 19:16:51 [ℹ]  starting parallel draining, max in-flight of 1
   2023-03-22 19:16:51 [ℹ]  cordon node "ip-192-168-36-138.ec2.internal"
   2023-03-22 19:16:51 [ℹ]  cordon node "ip-192-168-7-113.ec2.internal"
   2023-03-22 19:17:04 [!]  deleting Pods not managed by ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet: default/multitool, hipstershop/multitool
   2023-03-22 19:17:05 [!]  deleting Pods not managed by ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet: default/multitool, hipstershop/multitool
   2023-03-22 19:17:05 [!]  deleting Pods not managed by ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet: default/multitool, hipstershop/multitool
   2023-03-22 19:17:16 [✔]  drained all nodes: [ip-192-168-36-138.ec2.internal ip-192-168-7-113.ec2.internal]
   2023-03-22 19:17:16 [ℹ]  deleted 0 Fargate profile(s)
   2023-03-22 19:17:17 [✔]  kubeconfig has been updated
   2023-03-22 19:17:17 [ℹ]  cleaning up AWS load balancers created by Kubernetes objects of Kind Service or Ingress
   2023-03-22 19:17:44 [ℹ]
   2 sequential tasks: { delete nodegroup "cc-eks-secpos-workshop-ng-1", delete cluster control plane "cc-eks-secpos-workshop" [async]
   }
   2023-03-22 19:17:44 [ℹ]  will delete stack "eksctl-cc-eks-secpos-workshop-nodegroup-cc-eks-secpos-workshop-ng-1"
   2023-03-22 19:17:44 [ℹ]  waiting for stack "eksctl-cc-eks-secpos-workshop-nodegroup-cc-eks-secpos-workshop-ng-1" to get deleted
   2023-03-22 19:17:44 [ℹ]  waiting for CloudFormation stack "eksctl-cc-eks-secpos-workshop-nodegroup-cc-eks-secpos-workshop-ng-1"
   2023-03-22 19:18:14 [ℹ]  waiting for CloudFormation stack "eksctl-cc-eks-secpos-workshop-nodegroup-cc-eks-secpos-workshop-ng-1"
   2023-03-22 19:18:56 [ℹ]  waiting for CloudFormation stack "eksctl-cc-eks-secpos-workshop-nodegroup-cc-eks-secpos-workshop-ng-1"
   2023-03-22 19:20:30 [ℹ]  waiting for CloudFormation stack "eksctl-cc-eks-secpos-workshop-nodegroup-cc-eks-secpos-workshop-ng-1"
   2023-03-22 19:20:30 [ℹ]  will delete stack "eksctl-cc-eks-secpos-workshop-cluster"
   2023-03-22 19:20:30 [✔]  all cluster resources were deleted
   ```


[:arrow_left: Module 7 - Compliance Reporting in Calico Cloud](module-7-compliance-reporting.md)

[:leftwards_arrow_with_hook: Back to Main](../README.md)


Thank you for your time :pray:<br>