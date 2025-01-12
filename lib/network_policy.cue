package lib

import "k8s.io/api/networking/v1"

#NetworkPolicy: v1.#NetworkPolicy & {
  apiVersion: "networking.k8s.io/v1"
  kind: "NetworkPolicy"
  metadata: name: #ResourceName
}