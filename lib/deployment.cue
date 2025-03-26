package lib

import "k8s.io/api/apps/v1"

#Deployment: v1.#Deployment & {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:   #ResourceName
		labels: #Labels
	}
	spec: template: {
		metadata: labels: #Labels
		spec: containers: [...{
			ports: [...{
				name:          #PortName
				containerPort: #Port
				hostPort?:     #Port
				protocol:      #ProtocolIPv4
			}]
		}]
	}
}
