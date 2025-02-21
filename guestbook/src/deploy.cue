package k8s

Deployment: "guestbook": {
	metadata: _metadata
	spec: template: spec: containers: [{
		name:  "app"
		image: "asd:latest"
		ports: [{
      name: "http-8080"
      containerPort: 8080
		}]
	}]
}
