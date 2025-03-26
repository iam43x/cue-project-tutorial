package k8s

Deployment: "guestbook": {
	metadata: _metadata
	spec: template: {
		metadata: _metadata
		spec: containers: [{
			name:  "app"
			image: _image
			ports: [{
				name:          _portName
				containerPort: _port
			}]
		}]
	}
}
