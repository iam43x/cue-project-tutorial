package lib

import (
  "istio.io/client-go/pkg/apis/networking/v1alpha3"
  "strings"
)

#Gateway: v1alpha3.#Gateway & {
	apiVersion: "networking.istio.io/v1alpha3"
	kind:       "Gateway"
	metadata: {
		name:   #GatewayName
		labels: #Labels
	}
	spec: servers: [...{
		hosts: [...#FQDN]
		port: {
      name: "\(strings.ToLower(protocol))-\(number)"
      number:   #Port
      protocol: #Protocol
    }
	}]
}

#GatewayName: "mesh" | =~"-egressgateway$" | =~"-gw$" | #ResourceName
