//
//Copyright The Kubernetes Authors.
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
//

// This file was autogenerated by go-to-protobuf. Do not edit it manually!
package v1

import (
	"k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	v1_1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
)

// ControllerRevision implements an immutable snapshot of state data. Clients
// are responsible for serializing and deserializing the objects that contain
// their internal state.
// Once a ControllerRevision has been successfully created, it can not be updated.
// The API Server will fail validation of all requests that attempt to mutate
// the Data field. ControllerRevisions may, however, be deleted. Note that, due to its use by both
// the DaemonSet and StatefulSet controllers for update and rollback, this object is beta. However,
// it may be subject to name and representation changes in future releases, and clients should not
// depend on its stability. It is primarily for internal use by controllers.
#ControllerRevision: {
	v1.#TypeMeta
	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: v1.#ObjectMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)

	// Data is the serialized representation of the state.
	data?: runtime.#RawExtension @protobuf(2,.k8s.io.apimachinery.pkg.runtime.RawExtension)

	// Revision indicates the revision of the state represented by Data.
	revision?: int64 @protobuf(3,int64)
}

// ControllerRevisionList is a resource containing a list of ControllerRevision objects.
#ControllerRevisionList: {
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: v1.#ListMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ListMeta)

	// Items is the list of ControllerRevisions
	items?: [...#ControllerRevision] @protobuf(2,ControllerRevision)
}

// DaemonSet represents the configuration of a daemon set.
#DaemonSet: {
	v1.#TypeMeta
	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: v1.#ObjectMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)

	// The desired behavior of this daemon set.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	spec?: #DaemonSetSpec @protobuf(2,DaemonSetSpec)

	// The current status of this daemon set. This data may be
	// out of date by some window of time.
	// Populated by the system.
	// Read-only.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	status?: #DaemonSetStatus @protobuf(3,DaemonSetStatus)
}

// DaemonSetCondition describes the state of a DaemonSet at a certain point.
#DaemonSetCondition: {
	// Type of DaemonSet condition.
	type?: string @protobuf(1,string)

	// Status of the condition, one of True, False, Unknown.
	status?: string @protobuf(2,string)

	// Last time the condition transitioned from one status to another.
	// +optional
	lastTransitionTime?: v1.#Time @protobuf(3,.k8s.io.apimachinery.pkg.apis.meta.v1.Time)

	// The reason for the condition's last transition.
	// +optional
	reason?: string @protobuf(4,string)

	// A human readable message indicating details about the transition.
	// +optional
	message?: string @protobuf(5,string)
}

// DaemonSetList is a collection of daemon sets.
#DaemonSetList: {
	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: v1.#ListMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ListMeta)

	// A list of daemon sets.
	items?: [...#DaemonSet] @protobuf(2,DaemonSet)
}

// DaemonSetSpec is the specification of a daemon set.
#DaemonSetSpec: {
	// A label query over pods that are managed by the daemon set.
	// Must match in order to be controlled.
	// It must match the pod template's labels.
	// More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors
	selector?: v1.#LabelSelector @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.LabelSelector)

	// An object that describes the pod that will be created.
	// The DaemonSet will create exactly one copy of this pod on every node
	// that matches the template's node selector (or on every node if no node
	// selector is specified).
	// The only allowed template.spec.restartPolicy value is "Always".
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller#pod-template
	template?: v1_1.#PodTemplateSpec @protobuf(2,.k8s.io.api.core.v1.PodTemplateSpec)

	// An update strategy to replace existing DaemonSet pods with new pods.
	// +optional
	updateStrategy?: #DaemonSetUpdateStrategy @protobuf(3,DaemonSetUpdateStrategy)

	// The minimum number of seconds for which a newly created DaemonSet pod should
	// be ready without any of its container crashing, for it to be considered
	// available. Defaults to 0 (pod will be considered available as soon as it
	// is ready).
	// +optional
	minReadySeconds?: int32 @protobuf(4,int32)

	// The number of old history to retain to allow rollback.
	// This is a pointer to distinguish between explicit zero and not specified.
	// Defaults to 10.
	// +optional
	revisionHistoryLimit?: int32 @protobuf(6,int32)
}

// DaemonSetStatus represents the current status of a daemon set.
#DaemonSetStatus: {
	// The number of nodes that are running at least 1
	// daemon pod and are supposed to run the daemon pod.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
	currentNumberScheduled?: int32 @protobuf(1,int32)

	// The number of nodes that are running the daemon pod, but are
	// not supposed to run the daemon pod.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
	numberMisscheduled?: int32 @protobuf(2,int32)

	// The total number of nodes that should be running the daemon
	// pod (including nodes correctly running the daemon pod).
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
	desiredNumberScheduled?: int32 @protobuf(3,int32)

	// numberReady is the number of nodes that should be running the daemon pod and have one
	// or more of the daemon pod running with a Ready Condition.
	numberReady?: int32 @protobuf(4,int32)

	// The most recent generation observed by the daemon set controller.
	// +optional
	observedGeneration?: int64 @protobuf(5,int64)

	// The total number of nodes that are running updated daemon pod
	// +optional
	updatedNumberScheduled?: int32 @protobuf(6,int32)

	// The number of nodes that should be running the
	// daemon pod and have one or more of the daemon pod running and
	// available (ready for at least spec.minReadySeconds)
	// +optional
	numberAvailable?: int32 @protobuf(7,int32)

	// The number of nodes that should be running the
	// daemon pod and have none of the daemon pod running and available
	// (ready for at least spec.minReadySeconds)
	// +optional
	numberUnavailable?: int32 @protobuf(8,int32)

	// Count of hash collisions for the DaemonSet. The DaemonSet controller
	// uses this field as a collision avoidance mechanism when it needs to
	// create the name for the newest ControllerRevision.
	// +optional
	collisionCount?: int32 @protobuf(9,int32)

	// Represents the latest available observations of a DaemonSet's current state.
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	// +listType=map
	// +listMapKey=type
	conditions?: [...#DaemonSetCondition] @protobuf(10,DaemonSetCondition)
}

// DaemonSetUpdateStrategy is a struct used to control the update strategy for a DaemonSet.
#DaemonSetUpdateStrategy: {
	// Type of daemon set update. Can be "RollingUpdate" or "OnDelete". Default is RollingUpdate.
	// +optional
	type?: string @protobuf(1,string)

	// Rolling update config params. Present only if type = "RollingUpdate".
	// ---
	// TODO: Update this to follow our convention for oneOf, whatever we decide it
	// to be. Same as Deployment `strategy.rollingUpdate`.
	// See https://github.com/kubernetes/kubernetes/issues/35345
	// +optional
	rollingUpdate?: #RollingUpdateDaemonSet @protobuf(2,RollingUpdateDaemonSet)
}

// Deployment enables declarative updates for Pods and ReplicaSets.
#Deployment: {
	v1.#TypeMeta
	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: v1.#ObjectMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)

	// Specification of the desired behavior of the Deployment.
	// +optional
	spec?: #DeploymentSpec @protobuf(2,DeploymentSpec)

	// Most recently observed status of the Deployment.
	// +optional
	status?: #DeploymentStatus @protobuf(3,DeploymentStatus)
}

// DeploymentCondition describes the state of a deployment at a certain point.
#DeploymentCondition: {
	// Type of deployment condition.
	type?: string @protobuf(1,string)

	// Status of the condition, one of True, False, Unknown.
	status?: string @protobuf(2,string)

	// The last time this condition was updated.
	lastUpdateTime?: v1.#Time @protobuf(6,.k8s.io.apimachinery.pkg.apis.meta.v1.Time)

	// Last time the condition transitioned from one status to another.
	lastTransitionTime?: v1.#Time @protobuf(7,.k8s.io.apimachinery.pkg.apis.meta.v1.Time)

	// The reason for the condition's last transition.
	reason?: string @protobuf(4,string)

	// A human readable message indicating details about the transition.
	message?: string @protobuf(5,string)
}

// DeploymentList is a list of Deployments.
#DeploymentList: {
	// Standard list metadata.
	// +optional
	metadata?: v1.#ListMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ListMeta)

	// Items is the list of Deployments.
	items?: [...#Deployment] @protobuf(2,Deployment)
}

// DeploymentSpec is the specification of the desired behavior of the Deployment.
#DeploymentSpec: {
	// Number of desired pods. This is a pointer to distinguish between explicit
	// zero and not specified. Defaults to 1.
	// +optional
	replicas?: int32 @protobuf(1,int32)

	// Label selector for pods. Existing ReplicaSets whose pods are
	// selected by this will be the ones affected by this deployment.
	// It must match the pod template's labels.
	selector?: v1.#LabelSelector @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.LabelSelector)

	// Template describes the pods that will be created.
	// The only allowed template.spec.restartPolicy value is "Always".
	template?: v1_1.#PodTemplateSpec @protobuf(3,.k8s.io.api.core.v1.PodTemplateSpec)

	// The deployment strategy to use to replace existing pods with new ones.
	// +optional
	// +patchStrategy=retainKeys
	strategy?: #DeploymentStrategy @protobuf(4,DeploymentStrategy)

	// Minimum number of seconds for which a newly created pod should be ready
	// without any of its container crashing, for it to be considered available.
	// Defaults to 0 (pod will be considered available as soon as it is ready)
	// +optional
	minReadySeconds?: int32 @protobuf(5,int32)

	// The number of old ReplicaSets to retain to allow rollback.
	// This is a pointer to distinguish between explicit zero and not specified.
	// Defaults to 10.
	// +optional
	revisionHistoryLimit?: int32 @protobuf(6,int32)

	// Indicates that the deployment is paused.
	// +optional
	paused?: bool @protobuf(7,bool)

	// The maximum time in seconds for a deployment to make progress before it
	// is considered to be failed. The deployment controller will continue to
	// process failed deployments and a condition with a ProgressDeadlineExceeded
	// reason will be surfaced in the deployment status. Note that progress will
	// not be estimated during the time a deployment is paused. Defaults to 600s.
	progressDeadlineSeconds?: int32 @protobuf(9,int32)
}

// DeploymentStatus is the most recently observed status of the Deployment.
#DeploymentStatus: {
	// The generation observed by the deployment controller.
	// +optional
	observedGeneration?: int64 @protobuf(1,int64)

	// Total number of non-terminated pods targeted by this deployment (their labels match the selector).
	// +optional
	replicas?: int32 @protobuf(2,int32)

	// Total number of non-terminated pods targeted by this deployment that have the desired template spec.
	// +optional
	updatedReplicas?: int32 @protobuf(3,int32)

	// readyReplicas is the number of pods targeted by this Deployment with a Ready Condition.
	// +optional
	readyReplicas?: int32 @protobuf(7,int32)

	// Total number of available pods (ready for at least minReadySeconds) targeted by this deployment.
	// +optional
	availableReplicas?: int32 @protobuf(4,int32)

	// Total number of unavailable pods targeted by this deployment. This is the total number of
	// pods that are still required for the deployment to have 100% available capacity. They may
	// either be pods that are running but not yet available or pods that still have not been created.
	// +optional
	unavailableReplicas?: int32 @protobuf(5,int32)

	// Represents the latest available observations of a deployment's current state.
	// +patchMergeKey=type
	// +patchStrategy=merge
	// +listType=map
	// +listMapKey=type
	conditions?: [...#DeploymentCondition] @protobuf(6,DeploymentCondition)

	// Count of hash collisions for the Deployment. The Deployment controller uses this
	// field as a collision avoidance mechanism when it needs to create the name for the
	// newest ReplicaSet.
	// +optional
	collisionCount?: int32 @protobuf(8,int32)
}

// DeploymentStrategy describes how to replace existing pods with new ones.
#DeploymentStrategy: {
	// Type of deployment. Can be "Recreate" or "RollingUpdate". Default is RollingUpdate.
	// +optional
	type?: string @protobuf(1,string)

	// Rolling update config params. Present only if DeploymentStrategyType =
	// RollingUpdate.
	// ---
	// TODO: Update this to follow our convention for oneOf, whatever we decide it
	// to be.
	// +optional
	rollingUpdate?: #RollingUpdateDeployment @protobuf(2,RollingUpdateDeployment)
}

// ReplicaSet ensures that a specified number of pod replicas are running at any given time.
#ReplicaSet: {
	v1.#TypeMeta
	// If the Labels of a ReplicaSet are empty, they are defaulted to
	// be the same as the Pod(s) that the ReplicaSet manages.
	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: v1.#ObjectMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)

	// Spec defines the specification of the desired behavior of the ReplicaSet.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	spec?: #ReplicaSetSpec @protobuf(2,ReplicaSetSpec)

	// Status is the most recently observed status of the ReplicaSet.
	// This data may be out of date by some window of time.
	// Populated by the system.
	// Read-only.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	status?: #ReplicaSetStatus @protobuf(3,ReplicaSetStatus)
}

// ReplicaSetCondition describes the state of a replica set at a certain point.
#ReplicaSetCondition: {
	// Type of replica set condition.
	type?: string @protobuf(1,string)

	// Status of the condition, one of True, False, Unknown.
	status?: string @protobuf(2,string)

	// The last time the condition transitioned from one status to another.
	// +optional
	lastTransitionTime?: v1.#Time @protobuf(3,.k8s.io.apimachinery.pkg.apis.meta.v1.Time)

	// The reason for the condition's last transition.
	// +optional
	reason?: string @protobuf(4,string)

	// A human readable message indicating details about the transition.
	// +optional
	message?: string @protobuf(5,string)
}

// ReplicaSetList is a collection of ReplicaSets.
#ReplicaSetList: {
	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	// +optional
	metadata?: v1.#ListMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ListMeta)

	// List of ReplicaSets.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller
	items?: [...#ReplicaSet] @protobuf(2,ReplicaSet)
}

// ReplicaSetSpec is the specification of a ReplicaSet.
#ReplicaSetSpec: {
	// Replicas is the number of desired replicas.
	// This is a pointer to distinguish between explicit zero and unspecified.
	// Defaults to 1.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/#what-is-a-replicationcontroller
	// +optional
	replicas?: int32 @protobuf(1,int32)

	// Minimum number of seconds for which a newly created pod should be ready
	// without any of its container crashing, for it to be considered available.
	// Defaults to 0 (pod will be considered available as soon as it is ready)
	// +optional
	minReadySeconds?: int32 @protobuf(4,int32)

	// Selector is a label query over pods that should match the replica count.
	// Label keys and values that must match in order to be controlled by this replica set.
	// It must match the pod template's labels.
	// More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors
	selector?: v1.#LabelSelector @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.LabelSelector)

	// Template is the object that describes the pod that will be created if
	// insufficient replicas are detected.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller#pod-template
	// +optional
	template?: v1_1.#PodTemplateSpec @protobuf(3,.k8s.io.api.core.v1.PodTemplateSpec)
}

// ReplicaSetStatus represents the current status of a ReplicaSet.
#ReplicaSetStatus: {
	// Replicas is the most recently observed number of replicas.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/#what-is-a-replicationcontroller
	replicas?: int32 @protobuf(1,int32)

	// The number of pods that have labels matching the labels of the pod template of the replicaset.
	// +optional
	fullyLabeledReplicas?: int32 @protobuf(2,int32)

	// readyReplicas is the number of pods targeted by this ReplicaSet with a Ready Condition.
	// +optional
	readyReplicas?: int32 @protobuf(4,int32)

	// The number of available replicas (ready for at least minReadySeconds) for this replica set.
	// +optional
	availableReplicas?: int32 @protobuf(5,int32)

	// ObservedGeneration reflects the generation of the most recently observed ReplicaSet.
	// +optional
	observedGeneration?: int64 @protobuf(3,int64)

	// Represents the latest available observations of a replica set's current state.
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	// +listType=map
	// +listMapKey=type
	conditions?: [...#ReplicaSetCondition] @protobuf(6,ReplicaSetCondition)
}

// Spec to control the desired behavior of daemon set rolling update.
#RollingUpdateDaemonSet: {
	// The maximum number of DaemonSet pods that can be unavailable during the
	// update. Value can be an absolute number (ex: 5) or a percentage of total
	// number of DaemonSet pods at the start of the update (ex: 10%). Absolute
	// number is calculated from percentage by rounding up.
	// This cannot be 0 if MaxSurge is 0
	// Default value is 1.
	// Example: when this is set to 30%, at most 30% of the total number of nodes
	// that should be running the daemon pod (i.e. status.desiredNumberScheduled)
	// can have their pods stopped for an update at any given time. The update
	// starts by stopping at most 30% of those DaemonSet pods and then brings
	// up new DaemonSet pods in their place. Once the new pods are available,
	// it then proceeds onto other DaemonSet pods, thus ensuring that at least
	// 70% of original number of DaemonSet pods are available at all times during
	// the update.
	// +optional
	maxUnavailable?: intstr.#IntOrString @protobuf(1,.k8s.io.apimachinery.pkg.util.intstr.IntOrString)

	// The maximum number of nodes with an existing available DaemonSet pod that
	// can have an updated DaemonSet pod during during an update.
	// Value can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%).
	// This can not be 0 if MaxUnavailable is 0.
	// Absolute number is calculated from percentage by rounding up to a minimum of 1.
	// Default value is 0.
	// Example: when this is set to 30%, at most 30% of the total number of nodes
	// that should be running the daemon pod (i.e. status.desiredNumberScheduled)
	// can have their a new pod created before the old pod is marked as deleted.
	// The update starts by launching new pods on 30% of nodes. Once an updated
	// pod is available (Ready for at least minReadySeconds) the old DaemonSet pod
	// on that node is marked deleted. If the old pod becomes unavailable for any
	// reason (Ready transitions to false, is evicted, or is drained) an updated
	// pod is immediatedly created on that node without considering surge limits.
	// Allowing surge implies the possibility that the resources consumed by the
	// daemonset on any given node can double if the readiness check fails, and
	// so resource intensive daemonsets should take into account that they may
	// cause evictions during disruption.
	// +optional
	maxSurge?: intstr.#IntOrString @protobuf(2,.k8s.io.apimachinery.pkg.util.intstr.IntOrString)
}

// Spec to control the desired behavior of rolling update.
#RollingUpdateDeployment: {
	// The maximum number of pods that can be unavailable during the update.
	// Value can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%).
	// Absolute number is calculated from percentage by rounding down.
	// This can not be 0 if MaxSurge is 0.
	// Defaults to 25%.
	// Example: when this is set to 30%, the old ReplicaSet can be scaled down to 70% of desired pods
	// immediately when the rolling update starts. Once new pods are ready, old ReplicaSet
	// can be scaled down further, followed by scaling up the new ReplicaSet, ensuring
	// that the total number of pods available at all times during the update is at
	// least 70% of desired pods.
	// +optional
	maxUnavailable?: intstr.#IntOrString @protobuf(1,.k8s.io.apimachinery.pkg.util.intstr.IntOrString)

	// The maximum number of pods that can be scheduled above the desired number of
	// pods.
	// Value can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%).
	// This can not be 0 if MaxUnavailable is 0.
	// Absolute number is calculated from percentage by rounding up.
	// Defaults to 25%.
	// Example: when this is set to 30%, the new ReplicaSet can be scaled up immediately when
	// the rolling update starts, such that the total number of old and new pods do not exceed
	// 130% of desired pods. Once old pods have been killed,
	// new ReplicaSet can be scaled up further, ensuring that total number of pods running
	// at any time during the update is at most 130% of desired pods.
	// +optional
	maxSurge?: intstr.#IntOrString @protobuf(2,.k8s.io.apimachinery.pkg.util.intstr.IntOrString)
}

// RollingUpdateStatefulSetStrategy is used to communicate parameter for RollingUpdateStatefulSetStrategyType.
#RollingUpdateStatefulSetStrategy: {
	// Partition indicates the ordinal at which the StatefulSet should be partitioned
	// for updates. During a rolling update, all pods from ordinal Replicas-1 to
	// Partition are updated. All pods from ordinal Partition-1 to 0 remain untouched.
	// This is helpful in being able to do a canary based deployment. The default value is 0.
	// +optional
	partition?: int32 @protobuf(1,int32)

	// The maximum number of pods that can be unavailable during the update.
	// Value can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%).
	// Absolute number is calculated from percentage by rounding up. This can not be 0.
	// Defaults to 1. This field is alpha-level and is only honored by servers that enable the
	// MaxUnavailableStatefulSet feature. The field applies to all pods in the range 0 to
	// Replicas-1. That means if there is any unavailable pod in the range 0 to Replicas-1, it
	// will be counted towards MaxUnavailable.
	// +optional
	maxUnavailable?: intstr.#IntOrString @protobuf(2,.k8s.io.apimachinery.pkg.util.intstr.IntOrString)
}

// StatefulSet represents a set of pods with consistent identities.
// Identities are defined as:
//   - Network: A single stable DNS and hostname.
//   - Storage: As many VolumeClaims as requested.
//
// The StatefulSet guarantees that a given network identity will always
// map to the same storage identity.
#StatefulSet: {
	v1.#TypeMeta
	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: v1.#ObjectMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)

	// Spec defines the desired identities of pods in this set.
	// +optional
	spec?: #StatefulSetSpec @protobuf(2,StatefulSetSpec)

	// Status is the current status of Pods in this StatefulSet. This data
	// may be out of date by some window of time.
	// +optional
	status?: #StatefulSetStatus @protobuf(3,StatefulSetStatus)
}

// StatefulSetCondition describes the state of a statefulset at a certain point.
#StatefulSetCondition: {
	// Type of statefulset condition.
	type?: string @protobuf(1,string)

	// Status of the condition, one of True, False, Unknown.
	status?: string @protobuf(2,string)

	// Last time the condition transitioned from one status to another.
	// +optional
	lastTransitionTime?: v1.#Time @protobuf(3,.k8s.io.apimachinery.pkg.apis.meta.v1.Time)

	// The reason for the condition's last transition.
	// +optional
	reason?: string @protobuf(4,string)

	// A human readable message indicating details about the transition.
	// +optional
	message?: string @protobuf(5,string)
}

// StatefulSetList is a collection of StatefulSets.
#StatefulSetList: {
	// Standard list's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: v1.#ListMeta @protobuf(1,.k8s.io.apimachinery.pkg.apis.meta.v1.ListMeta)

	// Items is the list of stateful sets.
	items?: [...#StatefulSet] @protobuf(2,StatefulSet)
}

// StatefulSetOrdinals describes the policy used for replica ordinal assignment
// in this StatefulSet.
#StatefulSetOrdinals: {
	// start is the number representing the first replica's index. It may be used
	// to number replicas from an alternate index (eg: 1-indexed) over the default
	// 0-indexed names, or to orchestrate progressive movement of replicas from
	// one StatefulSet to another.
	// If set, replica indices will be in the range:
	//   [.spec.ordinals.start, .spec.ordinals.start + .spec.replicas).
	// If unset, defaults to 0. Replica indices will be in the range:
	//   [0, .spec.replicas).
	// +optional
	start?: int32 @protobuf(1,int32)
}

// StatefulSetPersistentVolumeClaimRetentionPolicy describes the policy used for PVCs
// created from the StatefulSet VolumeClaimTemplates.
#StatefulSetPersistentVolumeClaimRetentionPolicy: {
	// WhenDeleted specifies what happens to PVCs created from StatefulSet
	// VolumeClaimTemplates when the StatefulSet is deleted. The default policy
	// of `Retain` causes PVCs to not be affected by StatefulSet deletion. The
	// `Delete` policy causes those PVCs to be deleted.
	whenDeleted?: string @protobuf(1,string)

	// WhenScaled specifies what happens to PVCs created from StatefulSet
	// VolumeClaimTemplates when the StatefulSet is scaled down. The default
	// policy of `Retain` causes PVCs to not be affected by a scaledown. The
	// `Delete` policy causes the associated PVCs for any excess pods above
	// the replica count to be deleted.
	whenScaled?: string @protobuf(2,string)
}

// A StatefulSetSpec is the specification of a StatefulSet.
#StatefulSetSpec: {
	// replicas is the desired number of replicas of the given Template.
	// These are replicas in the sense that they are instantiations of the
	// same Template, but individual replicas also have a consistent identity.
	// If unspecified, defaults to 1.
	// TODO: Consider a rename of this field.
	// +optional
	replicas?: int32 @protobuf(1,int32)

	// selector is a label query over pods that should match the replica count.
	// It must match the pod template's labels.
	// More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors
	selector?: v1.#LabelSelector @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.LabelSelector)

	// template is the object that describes the pod that will be created if
	// insufficient replicas are detected. Each pod stamped out by the StatefulSet
	// will fulfill this Template, but have a unique identity from the rest
	// of the StatefulSet. Each pod will be named with the format
	// <statefulsetname>-<podindex>. For example, a pod in a StatefulSet named
	// "web" with index number "3" would be named "web-3".
	// The only allowed template.spec.restartPolicy value is "Always".
	template?: v1_1.#PodTemplateSpec @protobuf(3,.k8s.io.api.core.v1.PodTemplateSpec)

	// volumeClaimTemplates is a list of claims that pods are allowed to reference.
	// The StatefulSet controller is responsible for mapping network identities to
	// claims in a way that maintains the identity of a pod. Every claim in
	// this list must have at least one matching (by name) volumeMount in one
	// container in the template. A claim in this list takes precedence over
	// any volumes in the template, with the same name.
	// TODO: Define the behavior if a claim already exists with the same name.
	// +optional
	// +listType=atomic
	volumeClaimTemplates?: [...v1_1.#PersistentVolumeClaim] @protobuf(4,.k8s.io.api.core.v1.PersistentVolumeClaim)

	// serviceName is the name of the service that governs this StatefulSet.
	// This service must exist before the StatefulSet, and is responsible for
	// the network identity of the set. Pods get DNS/hostnames that follow the
	// pattern: pod-specific-string.serviceName.default.svc.cluster.local
	// where "pod-specific-string" is managed by the StatefulSet controller.
	serviceName?: string @protobuf(5,string)

	// podManagementPolicy controls how pods are created during initial scale up,
	// when replacing pods on nodes, or when scaling down. The default policy is
	// `OrderedReady`, where pods are created in increasing order (pod-0, then
	// pod-1, etc) and the controller will wait until each pod is ready before
	// continuing. When scaling down, the pods are removed in the opposite order.
	// The alternative policy is `Parallel` which will create pods in parallel
	// to match the desired scale without waiting, and on scale down will delete
	// all pods at once.
	// +optional
	podManagementPolicy?: string @protobuf(6,string)

	// updateStrategy indicates the StatefulSetUpdateStrategy that will be
	// employed to update Pods in the StatefulSet when a revision is made to
	// Template.
	updateStrategy?: #StatefulSetUpdateStrategy @protobuf(7,StatefulSetUpdateStrategy)

	// revisionHistoryLimit is the maximum number of revisions that will
	// be maintained in the StatefulSet's revision history. The revision history
	// consists of all revisions not represented by a currently applied
	// StatefulSetSpec version. The default value is 10.
	revisionHistoryLimit?: int32 @protobuf(8,int32)

	// Minimum number of seconds for which a newly created pod should be ready
	// without any of its container crashing for it to be considered available.
	// Defaults to 0 (pod will be considered available as soon as it is ready)
	// +optional
	minReadySeconds?: int32 @protobuf(9,int32)

	// persistentVolumeClaimRetentionPolicy describes the lifecycle of persistent
	// volume claims created from volumeClaimTemplates. By default, all persistent
	// volume claims are created as needed and retained until manually deleted. This
	// policy allows the lifecycle to be altered, for example by deleting persistent
	// volume claims when their stateful set is deleted, or when their pod is scaled
	// down. This requires the StatefulSetAutoDeletePVC feature gate to be enabled,
	// which is beta.
	// +optional
	persistentVolumeClaimRetentionPolicy?: #StatefulSetPersistentVolumeClaimRetentionPolicy @protobuf(10,StatefulSetPersistentVolumeClaimRetentionPolicy)

	// ordinals controls the numbering of replica indices in a StatefulSet. The
	// default ordinals behavior assigns a "0" index to the first replica and
	// increments the index by one for each additional replica requested.
	// +optional
	ordinals?: #StatefulSetOrdinals @protobuf(11,StatefulSetOrdinals)
}

// StatefulSetStatus represents the current state of a StatefulSet.
#StatefulSetStatus: {
	// observedGeneration is the most recent generation observed for this StatefulSet. It corresponds to the
	// StatefulSet's generation, which is updated on mutation by the API Server.
	// +optional
	observedGeneration?: int64 @protobuf(1,int64)

	// replicas is the number of Pods created by the StatefulSet controller.
	replicas?: int32 @protobuf(2,int32)

	// readyReplicas is the number of pods created for this StatefulSet with a Ready Condition.
	readyReplicas?: int32 @protobuf(3,int32)

	// currentReplicas is the number of Pods created by the StatefulSet controller from the StatefulSet version
	// indicated by currentRevision.
	currentReplicas?: int32 @protobuf(4,int32)

	// updatedReplicas is the number of Pods created by the StatefulSet controller from the StatefulSet version
	// indicated by updateRevision.
	updatedReplicas?: int32 @protobuf(5,int32)

	// currentRevision, if not empty, indicates the version of the StatefulSet used to generate Pods in the
	// sequence [0,currentReplicas).
	currentRevision?: string @protobuf(6,string)

	// updateRevision, if not empty, indicates the version of the StatefulSet used to generate Pods in the sequence
	// [replicas-updatedReplicas,replicas)
	updateRevision?: string @protobuf(7,string)

	// collisionCount is the count of hash collisions for the StatefulSet. The StatefulSet controller
	// uses this field as a collision avoidance mechanism when it needs to create the name for the
	// newest ControllerRevision.
	// +optional
	collisionCount?: int32 @protobuf(9,int32)

	// Represents the latest available observations of a statefulset's current state.
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	// +listType=map
	// +listMapKey=type
	conditions?: [...#StatefulSetCondition] @protobuf(10,StatefulSetCondition)

	// Total number of available pods (ready for at least minReadySeconds) targeted by this statefulset.
	// +optional
	availableReplicas?: int32 @protobuf(11,int32)
}

// StatefulSetUpdateStrategy indicates the strategy that the StatefulSet
// controller will use to perform updates. It includes any additional parameters
// necessary to perform the update for the indicated strategy.
#StatefulSetUpdateStrategy: {
	// Type indicates the type of the StatefulSetUpdateStrategy.
	// Default is RollingUpdate.
	// +optional
	type?: string @protobuf(1,string)

	// RollingUpdate is used to communicate parameters when Type is RollingUpdateStatefulSetStrategyType.
	// +optional
	rollingUpdate?: #RollingUpdateStatefulSetStrategy @protobuf(2,RollingUpdateStatefulSetStrategy)
}
