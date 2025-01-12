package lib

import "k8s.io/api/autoscaling/v2"

#HorizontalPodAutoscaler: v2.#HorizontalPodAutoscaler & {
  apiVersion: "autoscaling/v2"
  kind: "HorizontalPodAutoscaler"
  metadata: name: #ResourceName
}