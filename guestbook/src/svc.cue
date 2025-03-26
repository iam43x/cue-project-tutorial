package k8s

Service: "guestbook-svc": {
	metadata: _metadata
	spec: {
		ports: [
			{
				name: _portName
				port: _port
			},
		]
	}
}
