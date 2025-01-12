package lib

import "istio.io/client-go/pkg/apis/networking/v1alpha3"

#VirtualService: v1alpha3.#VirtualService & {
	kind:       "VirtualService"
	apiVersion: "networking.istio.io/v1alpha3"
	metadata: {
		name:   =~"-vs$" | #ResourceName
		labels: #Labels
	}
	spec: {
		exportTo: #ExportTo
		hosts: [...#FQDN]
		gateways: [...#GatewayName]
		tls: [...{
			match: [...{
				port?: #Port
				gateways?: [...#GatewayName]
				sniHosts?: [...#FQDN]
			}]
			route: [...{
				destination: {
					host: #FQDN
					port: number: #Port
				}
			}]
		}]
	}
}
