package lib

import "istio.io/client-go/pkg/apis/networking/v1alpha3"

#DestinationRule: v1alpha3.#DestinationRule & {
	kind:       "DestinationRule"
	apiVersion: "networking.istio.io/v1alpha3"
	metadata: {
		name:   =~"-dr$" | =~"-destination-rule$" | #ResourceName
		labels: #Labels
	}
	spec: {
		exportTo: #ExportTo
		host:     #FQDN
		subsets: [...{
			name: #ServiceEntryName
		}]
		trafficPolicy: portLevelSettings: [...{
			port: number: #Port
		}]
	}
}
