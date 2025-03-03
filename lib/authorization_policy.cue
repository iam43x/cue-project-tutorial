package lib

import "istio.io/client-go/pkg/apis/security/v1"

#AuthorizationPolicy: v1.#AuthorizationPolicy & {
	apiVersion: "security.istio.io/v1"
	kind:       "AuthorizationPolicy"
	metadata: {
		name:   #ResourceName
		labels: #Labels
	}
}
