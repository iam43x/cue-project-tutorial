package lib

import "istio.io/client-go/pkg/apis/networking/v1alpha3"

#EnvoyFilter: v1alpha3.#EnvoyFilter & {
	apiVersion: "networking.istio.io/v1alpha3"
	kind:       "EnvoyFilter"
	metadata: {
		name:   #ResourceName
		labels: #Labels
	}
}
