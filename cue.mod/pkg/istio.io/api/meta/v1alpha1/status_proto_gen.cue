// $title: Istio Status
// $description: Common status field for all istio collections.
// $location: https://istio.io/docs/reference/config/meta/v1beta1/istio-status.html
package v1alpha1

import (
	"istio.io/api/analysis/v1alpha1"
	"time"
)

#IstioStatus: {
	// Current service state of the resource.
	// More info: https://istio.io/docs/reference/config/config-status/
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	conditions?: [...#IstioCondition] @protobuf(1,IstioCondition)

	// Includes any errors or warnings detected by Istio's analyzers.
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	validationMessages?: [...v1alpha1.#AnalysisMessageBase] @protobuf(2,analysis.v1alpha1.AnalysisMessageBase,name=validation_messages)

	// Resource Generation to which the Reconciled Condition refers.
	// When this value is not equal to the object's metadata generation, reconciled condition  calculation for the current
	// generation is still in progress.  See https://istio.io/latest/docs/reference/config/config-status/ for more info.
	// +optional
	observedGeneration?: int64 @protobuf(3,int64,name=observed_generation)
}

#IstioCondition: {
	// Type is the type of the condition.
	type?: string @protobuf(1,string)

	// Status is the status of the condition.
	// Can be True, False, Unknown.
	status?: string @protobuf(2,string)

	// Last time we probed the condition.
	// +optional
	lastProbeTime?: time.Time @protobuf(3,google.protobuf.Timestamp,name=last_probe_time)

	// Last time the condition transitioned from one status to another.
	// +optional
	lastTransitionTime?: time.Time @protobuf(4,google.protobuf.Timestamp,name=last_transition_time)

	// Unique, one-word, CamelCase reason for the condition's last transition.
	// +optional
	reason?: string @protobuf(5,string)

	// Human-readable message indicating details about last transition.
	// +optional
	message?: string @protobuf(6,string)
}
