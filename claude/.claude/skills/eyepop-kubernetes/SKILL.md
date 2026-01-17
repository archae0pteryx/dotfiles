---
name: debugging-eyepop-kubernetes-services
description: Key information and methods for developing and debugging the EyePop microsystem in kubernetes.
---

- Most microservices are deployed through our charts repo via "kustomization overlays" pattern in `~/Code/eyepop/eyepop-charts/*` and contain the `overlays/<env>/kustomization.yaml`.
- ArgoCD is used for gitops and uses the "app of apps" pattern wherein the repo `~/Code/eyepop/eyepop-apps/*` is the helm chart with all of the `kind: Application`'s
- The OPs cluster is where argocd is deployed `kubectl --context ops -n argocd`
- ArgoCD image updater is also used for some apps and can be interacted with in `kubectl --context ops -n argocd`
- Use the monitoring stack for key system insights for a microservice. The following tools exist in both `--context production` and `--context staging`
  - `kubectl --context staging -n <monitoring-staging,grafana-alloy,loki,keda>` production deployments often have the `*-production` suffix in the namespace

- **IMPORTANT**: Most all of our argocd apps are manually synced. NEVER sync without asking.
- **IMPORTANT**: When working in `--context production` you ALWAYS ask before applying or patching resources


