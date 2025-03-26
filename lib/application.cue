package lib

import "github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1"

#Application: v1alpha1.#Application & {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		name:   #ResourceName
		labels: #Labels
	}
	spec: source: repoURL: =~"^ssh://.+.git$" | =~"^https://.+"
}
