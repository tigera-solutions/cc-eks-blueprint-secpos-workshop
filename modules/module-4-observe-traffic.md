# Module 4 - Observe traffic flows in Calico Cloud

## Install sample application stacks

1. From the cloned directory, execute:

    ```bash
    kubectl apply -f manifests
    ```
  
    (Optional) Also install the metrics-server on EKS to get an idea as to the resource consumption on the cluster

    ```bash
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    ```

    Connect to Calico Cloud GUI. From the menu select `Service Graph > Default`. Explore the options.
  
## Check traffic flows

1. Try sending some traffic between the pods

   a. From the ```management-ui``` pod in ```management-ui``` namespace to the ```customer``` pod in the ```yaobank``` namespace  

    ```bash
    kubectl exec -it -n management-ui deploy/management-ui -- sh -c 'curl -m3 -sI http://frontend.hipstershop 2>/dev/null | grep -i http'
    ```

   The expected result should be ```HTTP/1.0 200 OK``` indicating that the request succeeded between the namespaces

   b. From the service graph and the application, we can also see that there is traffic correctly flowing within each microservice application pods.

2. Each application also has a webserver with a ```LoadBalancer``` service to access from the internet to check that the application is functioning normally.

   a. Validate and access the ```management-ui``` svc of the Stars application via the ```Loadbalancer``` service in a browser

    ```bash
    kubectl get svc -n management-ui
    ```

      The output gives the external-IP of the AWS LB that can be used to access the svc

    ```bash
    NAME            TYPE           CLUSTER-IP       EXTERNAL-IP                                                                  PORT(S)        AGE
    management-ui   LoadBalancer   10.100.154.186   a2b94c3b1192d490f8c4b1b9caf30589-1684915063.ca-central-1.elb.amazonaws.com   80:31996/TCP   4h48m
    ```

    In a browser, the following should be seen:
    ![stars_gui](https://github.com/tigera-solutions/cc-eks-observability-workshop/assets/117195889/7774d604-361c-4fe9-928f-18b45a4bb948)

    

   b. Validate and access the  ```frontend-external``` svc of the Online Boutique application via its ```Loadbalancer``` service in a browser

    ```bash
    kubectl get svc frontend-external -n hipstershop
    ```

      The output gives the external-IP of the AWS LB that can be used to access the svc

    ```bash
    NAME                TYPE           CLUSTER-IP       EXTERNAL-IP                                                                        PORT(S)        AGE
    frontend-external   LoadBalancer   10.100.252.111   a5d213eb74e304fffa6f60ff08a18d28-35a3854f09c3dc8c.elb.ca-central-1.amazonaws.com   80:31805/TCP   89m
    ```

    In a browser, the following should be seen:

    



[:arrow_right: Module 5 - Secure pod traffic using Calico Policy Recommender](module-5-secure-pod-traffic.md)   <br>

[:arrow_left: Module 3 - Deploy an EKS cluster](module-3-connect-calicocloud.md)

[:leftwards_arrow_with_hook: Back to Main](../README.md)  
