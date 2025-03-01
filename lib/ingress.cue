package lib

import "k8s.io/api/networking/v1"

#Ingress: v1.#Ingress & {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: name: #ResourceName
}
