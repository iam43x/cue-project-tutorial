package lib

import "k8s.io/api/core/v1"

#Service: v1.#Service & {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:   =~"-svc$" & #ResourceName
		labels: #Labels
	}
}
