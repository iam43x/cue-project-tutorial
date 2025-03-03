package lib

import "github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1"

#AppProject: v1alpha1.#AppProject & {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "AppProject"
	metadata: {
		name:   #ResourceName
		labels: #Labels
	}
}
