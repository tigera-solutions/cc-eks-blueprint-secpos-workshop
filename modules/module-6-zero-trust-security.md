# Module 6 - Zero-trust security for pod traffic

Tiers are a hierarchical construct used to group policies and enforce higher precedence policies that other teams cannot circumvent, providing the basis for **Identity-aware microsegmentation**.

All Calico and Kubernetes security policies reside in tiers. You can start “thinking in tiers” by grouping your teams and the types of policies within each group.

In our scenario, we have a lot of namescoped application-specific policies for traffic which are fine-grained controls. Some of the policies can be segmented into higher tiers for wider cluster-wide policy implementation by a security team while the application team still has access to their own tier. However, the security team can still ultimately use RBAC to control the scope of read-only/read-write permissions of the application team and the scope of the cluster access and namespaces.

In our scenario we will consider the Star application to be used by one tenant while the Hipstershop application is being used by another. We want to restrict the traffic within tenants as a cluster-wide policy in a higher ```security``` tier.

## Security tier policies overview

The ```security``` tier will be used to implement high-level guardrails for the cluster.

- A ```block-alienvault-ipthreatfeed``` security policy will be enforced for all cluster workloads. The policy will deny ingress/egress connectivity from/to malicious IPs in the ```alienvault.ipthreatfeeds``` threatfeed.
- The ```cluster-dns-allow-all``` security policy will have rules to permit ingress DNS traffic to the ```kube-dns``` endpoints on TCP and UDP port 53 from all endpoints in the cluster. The security policy will also have egress rules to permit all endpoints in the cluster to send DNS traffic to the ```kube-dns``` endpoints on the same ports.
- A DNS/domain set of trusted repos called ```trusted-repos``` is created and accompanying egress ```GlobalNetworkPolicy``` named ```external-domain-access``` is also created to explicitly allow outbound internet access for the workload pods to only the allowed FQDNs.
- Finally, ```security-default-pass``` policy will be used to pass any traffic that is not explicitly allowed or denied in this tier to the subsequent tier for policy processing.

## App tier policies overview

The ```app``` tier is used by Online Boutique to achieve fine-grained microsegmentation of east-west pod traffic of the various microservices that make up this application.

- The following diagram of the application shows exactly the flows that need to be allowed on ingress and egress while the rest of the traffic should be denied. Examine the file under ```policy/04-hipstershop-app.yaml``` to correlate the policies to this diagram. Apply the file, and examine the policies in the policy board. 

  ```bash
  kubectl create -f policy/04-hipstershop-app.yaml
  ```

- Finally, ```app-default-pass``` policy will be used to pass any traffic that is not explicitly allowed or denied in this tier to the subsequent tier for policy processing.
  
## namespace-isolation tier policies review

- The final tier before traffic hits the default tier is the ```namespace-isolation``` tier that already contains our policies for the ```Star``` application from the previous module.

## Default tier policies overview

The default tier is used to implement global default deny policy.

- ```default-deny``` denies any traffic that is not explicitly allowed in security, platform, and app tiers.

## Building the policies

1. Apply the tiers YAML
  
    ```bash
    kubectl apply -f policy/00-tiers.yaml
    ```

2. Apply the ```default-deny``` policy as a ```Staged``` policy first in the ```default``` tier for all the necessary namespaces:

    ```bash
    kubectl apply -f policy/01-default-deny.yaml
    ```

3. Apply the ```security``` tier policies

    ```bash
    kubectl apply -f policy/02-security.yaml
    ```

4. Apply the ```app``` tier policies for Online Boutique

   ```bash
   kubectl apply -f policy/04-hipstershop-app.yaml
   ```

5. Finally enforce the default deny policy from the Calico Cloud GUI.

6. Examine the results in the service graph and run traffic tests to verify.  

[:arrow_right: Module 7 - Compliance Reporting](module-7-compliance-reporting.md)   <br>

[:arrow_left: Module 5 - Secure pod traffic using Calico Policy Recommendations](module-5-secure-pod-traffic.md)

[:leftwards_arrow_with_hook: Back to Main](../README.md)
