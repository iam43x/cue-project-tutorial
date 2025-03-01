package lib

import (
	"net"
	"k8s.io/api/core/v1"
)

#Service: v1.#Service & {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:   =~"-svc$" & #ResourceName
		labels: #Labels
	}
	spec: {
		selector: #Selector
		type:     #ServiceType
		ports: [...{
			name:         #PortName
			port:         #Port
			targetPort:   #Port
			nodePort?:    #Port
			protocol:     #ProtocolIPv4
			appProtocol?: #AppProtocol
		}]
		clusterIP?: net.IP | "None"
	}
}

#ServiceType: "ExternalName" | *"ClusterIP" | "NodePort" | "LoadBalancer"

#AppProtocol: "tcp" | "udp" | "http" | "https" | "grpc" | "grpc-web" | "http2" | "mongo" | "tls"

#Selector: {
	Labels.Component
	Labels.Version
	[string]: string
}
