package lib

import "istio.io/client-go/pkg/apis/networking/v1alpha3"

#Sidecar: v1alpha3.#Sidecar & {
	apiVersion: "networking.istio.io/v1beta1"
	kind:       "Sidecar"
	metadata: {
		name:   #ResourceName
		labels: #Labels
	}
}
