package deps

import (
	_ "github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1"
	_ "istio.io/api/networking/v1alpha3"
	_ "istio.io/api/security/v1beta1"
	_ "k8s.io/api/apps/v1"
	_ "k8s.io/api/core/v1"
)

//*** need for go mod download and extract proto schemas */
