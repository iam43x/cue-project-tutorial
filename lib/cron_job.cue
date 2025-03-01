package lib

import "k8s.io/api/batch/v1"

#CronJob: v1.#CronJob & {
	apiVersion: "batch/v1"
	kind:       "CronJob"
	metadata: name: #ResourceName
}
