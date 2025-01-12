package lib

import "k8s.io/api/core/v1"

#Secret: v1.#Secret & {
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:   #ResourceName
		labels: #Labels
	}
}
