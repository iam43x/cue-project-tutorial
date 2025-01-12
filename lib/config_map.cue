package lib

import "k8s.io/api/core/v1"

#ConfigMap: v1.#ConfigMap & {
	apiVersion: "core/v1"
	kind:       "ConfigMap"
	metadata: {
		name:   #ResourceName
		labels: #Labels
	}
}
