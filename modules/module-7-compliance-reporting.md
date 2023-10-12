# Module 7 - Compliance Reporting in Calico Cloud

With the policy portion of securing our application complete, we need a way to report that our application is in compliance going forward.

Using the reporting feature of Calico Cloud we can create a number of reports types to ensure security and compliance requirements.

Calico Cloud supports the following built-in report types:

- Inventory
- Network Access
- Policy-Audit
- CIS Benchmark

These reports can be customized and scoped to report against a certain set of endpoints, namespace or cluster-wide.

Compliance reports provide the following high-level information:

- **Protection**
  - Endpoints explicitly protected using ingress or egress policy
  - Endpoints with Envoy enabled
- **Policies and services**
  - Policies and services associated with endpoints
  - Policy audit logs
- **Traffic**
  - Allowed ingress/egress traffic to/from namespaces
  - Allowed ingress/egress traffic to/from the internet

## Example Reports

### Daily Report - Endpoint Inventory

The following report schedules daily inventory reports.

```yaml
kubectl apply -f -<<EOF
apiVersion: projectcalico.org/v3
kind: GlobalReport
metadata:
  name: daily-inventory
spec:
  reportType: inventory
  schedule: 8 6 * * *
EOF
```

[Inventory Endpoints Example](../compliance-reporting/inventory-endpoints.csv)<br>
[Inventory Summary Example](../compliance-reporting/inventory-summary.csv)

### Daily Report - Endpoint Network Access

The following report schedules daily network-access reports for all endpoints.

```yaml
kubectl apply -f -<<EOF
apiVersion: projectcalico.org/v3
kind: GlobalReport
metadata:
  name: daily-network-access
spec:
  reportType: network-access
  schedule: 0 1 * * *
EOF
```

[Network Access Endpoints Example](../compliance-reporting/network-access-endpoints.csv)<br>
[Network Access Summary Example](../compliance-reporting/network-access-summary.csv)


### Policy Audit

The following report schedules a policy audit of the cluster at the frequency of your choosing

```yaml
kubectl apply -f -<<EOF
apiVersion: projectcalico.org/v3
kind: GlobalReport
metadata:
  name: daily-policy-audit
spec:
  reportType: policy-audit
  schedule: 0 0 * * *
EOF
```

[Policy Audit Summary Example](../compliance-reporting/policy-audit-summary.csv)

### CIS Benchmark Report

The following report schedules a CIS benchmark report of the cluster at the frequency of your choosing and user-defined scoring thresholds.

```yaml
kubectl apply -f -<<EOF
apiVersion: projectcalico.org/v3
kind: GlobalReport
metadata:
  name: daily-cis-benchmark
spec:
  reportType: cis-benchmark
  schedule: 0 0 * * *
  cis:
    highThreshold: 100
    medThreshold: 50
    includeUnscoredTests: true
    numFailedTests: 5
    resultsFilters:
      - benchmarkSelection: { kubernetesVersion: "1.26" }
        exclude: ["1.1.4", "1.2.5"]
EOF
```

[CIS Benchmark All Tests Example](../compliance-reporting/cis-benchmark-all-tests.csv)<br>
[CIS Benchmark All Tests Total Summary Example](../compliance-reporting/cis-benchmark-total-summary.csv)


### Generate reports manually

- Change values as needed in the ```generate-reports.sh``` script
- Run the script from the base repo path ```bash scripts/generate-reports.sh```
- Check that the runtime reporter pods have spun up and completed the jobs under the ```tigera-compliance``` namespace.
- Check the Calico Cloud UI for the new reports to be populated.

## Reference Documentation

[Calico Cloud Manager UI Tour](https://docs.tigera.io/calico-cloud/tutorials/calico-cloud-features/tour)

[Calico Cloud Documentation for Compliance Reports](https://docs.tigera.io/calico-cloud/compliance/overview)  

[Cron Scheduler Tool](https://crontab.guru/)

[:arrow_right: Module 8 - Clean up](module-8-clean-up.md)   <br>

[:arrow_left: Module 6 - Zero-trust security for pod traffic](module-6-zero-trust-security.md)

[:leftwards_arrow_with_hook: Back to Main](../README.md)