# Operations runbook

```bash
kubectl -n demo-service-development rollout status deployment/demo-service
kubectl -n demo-service-development port-forward service/demo-service 8081:80
```

Verify `/healthz`, `/readyz`, `/api/v1/status`, `/metrics` and the UI at `/`. Use the correlation ID returned by the API to find the same request in logs.

The application publishes these dashboard-facing metric families:

| Metric | Purpose |
| --- | --- |
| `application_info` | Running service, environment and immutable release SHA |
| `http_requests_total` | Request rate and server error ratio by route and status |
| `http_request_duration_seconds` | p50, p95 and p99 customer latency |
| `notification_requests_total` | Accepted notification activity by channel |
| `notification_store_records` | Current records retained by the bounded demo store |

The email, SMS and webhook counter series are initialized at zero. This makes an
unused but healthy channel visible as zero instead of looking like missing
telemetry in Grafana.
