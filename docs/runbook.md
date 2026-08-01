# Operations runbook

```bash
kubectl -n demo-service-development rollout status deployment/demo-service
kubectl -n demo-service-development port-forward service/demo-service 8081:80
```

Verify `/healthz`, `/readyz`, `/api/v1/status`, `/metrics` and the UI at `/`. Use the correlation ID returned by the API to find the same request in logs.
