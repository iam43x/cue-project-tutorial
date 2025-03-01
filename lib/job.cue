package lib

import "k8s.io/api/batch/v1"

#Job: v1.#Job & {
	apiVersion: "batch/v1"
	kind:       "Job"
	metadata: name: #ResourceName
}
