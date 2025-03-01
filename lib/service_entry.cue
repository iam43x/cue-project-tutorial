package lib

import (
  "istio.io/client-go/pkg/apis/networking/v1alpha3"
  "strings"
)

#ServiceEntry: v1alpha3.#ServiceEntry & {
	apiVersion: "networking.istio.io/v1alpha3"
	kind:       "ServiceEntry"
	metadata: {
		name:   #ServiceEntryName
		labels: #Labels
	}
	spec: {
		exportTo: #ExportTo
		hosts: [...#FQDN]
		ports: [...{
      name: "\(strings.ToLower(protocol))-\(number)"
			number:   #Port
			protocol: #Protocol
		}]
	}
}

#ServiceEntryName: =~"-se$" | #ResourceName
