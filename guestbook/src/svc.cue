package k8s

Service: "guestbook-svc": {
	metadata: _metadata
	spec: {
		ports: [
			{
				name: "http-80"
				port: 80
        targetPort: port
			},
		]
		selector: _selector
	}
}
