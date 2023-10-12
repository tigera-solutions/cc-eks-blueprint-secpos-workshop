#!/usr/bin/env bash

# get Calico version
CALICO_VERSION=$(kubectl get clusterinformation default -ojsonpath='{.spec.cnxVersion}')

# report names
INVENTORY_REPORT_NAME='daily-inventory'
NETWORK_ACCESS_REPORT_NAME='daily-network-access'
POLICY_AUDIT_REPORT_NAME='daily-policy-audit'
CIS_BENCHMARK_NAME='daily-cis-benchmark'

# on MacOS
START_TIME=$(date -v -1H -u +'%Y-%m-%dT%H:%M:%SZ')
END_TIME=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sed -e "s?<CALICO_VERSION>?$CALICO_VERSION?g" \
  -e "s?<INVENTORY_REPORT_NAME>?$INVENTORY_REPORT_NAME?g" \
  -e "s?<NETWORK_ACCESS_REPORT_NAME>?$NETWORK_ACCESS_REPORT_NAME?g" \
  -e "s?<POLICY_AUDIT_REPORT_NAME>?$POLICY_AUDIT_REPORT_NAME?g" \
  -e "s?<CIS_BENCHMARK_NAME>?$CIS_BENCHMARK_NAME?g" \
  -e "s?<TIGERA_COMPLIANCE_REPORT_START_TIME>?$START_TIME?g" \
  -e "s?<TIGERA_COMPLIANCE_REPORT_END_TIME>?$END_TIME?g" \
  $SCRIPT_DIR/../compliance-reporting/compliance-reporter-pod.yaml | kubectl apply -f -