# Deployment

The service repository owns Kustomize overlays under `deploy/overlays/`. CI publishes:

```text
ghcr.io/stonetusker/tusker-demo-notification-service:<full-git-sha>
ghcr.io/stonetusker/tusker-demo-notification-service:main
```

The immutable SHA is promoted by a release pull request. The platform repository stores the Argo CD Application:

```text
Repository: https://github.com/stonetusker/tusker-demo-notification-service.git
Path:       deploy/overlays/development
Namespace:  demo-service-development
```
