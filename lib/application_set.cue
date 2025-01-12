package lib

import "github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1"

#ApplicationSet: v1alpha1.#ApplicationSet & {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "ApplicationSet"
	metadata: name: #ResourceName
}
