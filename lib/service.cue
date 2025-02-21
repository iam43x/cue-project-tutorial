package lib

import (
  "k8s.io/api/core/v1"
  "net"
)

#Service: v1.#Service & {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:   =~"-svc$" & #ResourceName
		labels: #Labels
	}
	spec: {
		type: #ServiceType
		ports: [...{
			name:        #PortName
			port:        #Port
			targetPort:  #Port
			nodePort?:    #Port
			protocol:    #ProtocolIPv4
			appProtocol?: #AppProtocol
		}]
		clusterIP?: net.IP | "None"
	}
}

#ServiceType: "ExternalName" | *"ClusterIP" | "NodePort" | "LoadBalancer"

#AppProtocol: "tcp" | "udp" | "http" | "https" | "grpc" | "grpc-web" | "http2" | "mongo" | "tls"