// Copyright 2020 Istio Authors
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

// $schema: istio.networking.v1alpha3.WorkloadGroup
// $title: Workload Group
// $description: Describes a collection of workload instances.
// $location: https://istio.io/docs/reference/config/networking/workload-group.html
// $aliases: [/docs/reference/config/networking/v1alpha3/workload-group]

// `WorkloadGroup` describes a collection of workload instances.
// It provides a specification that the workload instances can use to bootstrap
// their proxies, including the metadata and identity. It is only intended to
// be used with non-k8s workloads like Virtual Machines, and is meant to mimic
// the existing sidecar injection and deployment specification model used for
// Kubernetes workloads to bootstrap Istio proxies.
//
// The following example declares a workload group representing a collection
// of workloads that will be registered under `reviews` in namespace
// `bookinfo`. The set of labels will be associated with each workload
// instance during the bootstrap process, and the ports 3550 and 8080
// will be associated with the workload group and use service account `default`.
// `app.kubernetes.io/version` is just an arbitrary example of a label.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: WorkloadGroup
// metadata:
//   name: reviews
//   namespace: bookinfo
// spec:
//   metadata:
//     labels:
//       app.kubernetes.io/name: reviews
//       app.kubernetes.io/version: "1.3.4"
//   template:
//     ports:
//       grpc: 3550
//       http: 8080
//     serviceAccount: default
//   probe:
//     initialDelaySeconds: 5
//     timeoutSeconds: 3
//     periodSeconds: 4
//     successThreshold: 3
//     failureThreshold: 3
//     httpGet:
//      path: /foo/bar
//      host: 127.0.0.1
//      port: 3100
//      scheme: HTTPS
//      httpHeaders:
//      - name: Lit-Header
//        value: Im-The-Best
// ```
//
package v1alpha3

// `WorkloadGroup` enables specifying the properties of a single workload for bootstrap and
// provides a template for `WorkloadEntry`, similar to how `Deployment` specifies properties
// of workloads via `Pod` templates. A `WorkloadGroup` can have more than one `WorkloadEntry`.
// `WorkloadGroup` has no relationship to resources which control service registry like `ServiceEntry`
// and as such doesn't configure host name for these workloads.
//
// <!-- crd generation tags
// +cue-gen:WorkloadGroup:groupName:networking.istio.io
// +cue-gen:WorkloadGroup:versions:v1beta1,v1alpha3,v1
// +cue-gen:WorkloadGroup:labels:app=istio-pilot,chart=istio,heritage=Tiller,release=istio
// +cue-gen:WorkloadGroup:subresource:status
// +cue-gen:WorkloadGroup:scope:Namespaced
// +cue-gen:WorkloadGroup:resource:categories=istio-io,networking-istio-io,shortNames=wg,plural=workloadgroups
// +cue-gen:WorkloadGroup:printerColumn:name=Age,type=date,JSONPath=.metadata.creationTimestamp,description="CreationTimestamp is a timestamp
// representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations.
// Clients may not set this value. It is represented in RFC3339 form and is in UTC.
// Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata"
// +cue-gen:WorkloadGroup:preserveUnknownFields:false
// -->
//
// <!-- go code generation tags
// +kubetype-gen
// +kubetype-gen:groupVersion=networking.istio.io/v1alpha3
// +genclient
// +k8s:deepcopy-gen=true
// -->
#WorkloadGroup: {
	// Metadata that will be used for all corresponding `WorkloadEntries`.
	// User labels for a workload group should be set here in `metadata` rather than in `template`.
	metadata?: #ObjectMeta @protobuf(1,ObjectMeta)

	// Template to be used for the generation of `WorkloadEntry` resources that belong to this `WorkloadGroup`.
	// Please note that `address` and `labels` fields should not be set in the template, and an empty `serviceAccount`
	// should default to `default`. The workload identities (mTLS certificates) will be bootstrapped using the
	// specified service account's token. Workload entries in this group will be in the same namespace as the
	// workload group, and inherit the labels and annotations from the above `metadata` field.
	// +protoc-gen-crd:validation:IgnoreSubValidation:["Address is required"]
	template: #WorkloadEntry @protobuf(2,WorkloadEntry)

	// `ObjectMeta` describes metadata that will be attached to a `WorkloadEntry`.
	// It is a subset of the supported Kubernetes metadata.
	#ObjectMeta: {
		// Labels to attach
		labels?: {
			[string]: string
		} @protobuf(1,map[string]string)

		// Annotations to attach
		annotations?: {
			[string]: string
		} @protobuf(2,map[string]string)
	}

	// `ReadinessProbe` describes the configuration the user must provide for healthchecking on their workload.
	// This configuration mirrors K8S in both syntax and logic for the most part.
	probe?: #ReadinessProbe @protobuf(3,ReadinessProbe)
}

#ReadinessProbe: {
	// Number of seconds after the container has started before readiness probes are initiated.
	initialDelaySeconds?: int32 @protobuf(2,int32,name=initial_delay_seconds)

	// Number of seconds after which the probe times out.
	// Defaults to 1 second. Minimum value is 1 second.
	timeoutSeconds?: int32 @protobuf(3,int32,name=timeout_seconds)

	// How often (in seconds) to perform the probe.
	// Default to 10 seconds. Minimum value is 1 second.
	periodSeconds?: int32 @protobuf(4,int32,name=period_seconds)

	// Minimum consecutive successes for the probe to be considered successful after having failed.
	// Defaults to 1 second.
	successThreshold?: int32 @protobuf(5,int32,name=success_threshold)

	// Minimum consecutive failures for the probe to be considered failed after having succeeded.
	// Defaults to 3 seconds.
	failureThreshold?: int32 @protobuf(6,int32,name=failure_threshold)
	// Users can only provide one configuration for healthchecks (tcp, http, exec),
	// and this is expressed as a oneof. All of the other configuration values
	// hold true for any of the healthcheck methods.
	{} | {
		// `httpGet` is performed to a given endpoint
		// and the status/able to connect determines health.
		httpGet: #HTTPHealthCheckConfig @protobuf(7,HTTPHealthCheckConfig,name=http_get)
	} | {
		// Health is determined by if the proxy is able to connect.
		tcpSocket: #TCPHealthCheckConfig @protobuf(8,TCPHealthCheckConfig,name=tcp_socket)
	} | {
		// Health is determined by how the command that is executed exited.
		exec: #ExecHealthCheckConfig @protobuf(9,ExecHealthCheckConfig)
	}
}

#HTTPHealthCheckConfig: {
	// Path to access on the HTTP server.
	path?: string @protobuf(1,string)

	// Port on which the endpoint lives.
	port: uint32 @protobuf(2,uint32)

	// Host name to connect to, defaults to the pod IP. You probably want to set
	// "Host" in httpHeaders instead.
	host?: string @protobuf(3,string)

	// HTTP or HTTPS, defaults to HTTP
	scheme?: string @protobuf(4,string)

	// Headers the proxy will pass on to make the request.
	// Allows repeated headers.
	httpHeaders?: [...#HTTPHeader] @protobuf(5,HTTPHeader,name=http_headers)
}

#HTTPHeader: {
	// The header field name
	name?: string @protobuf(1,string)

	// The header field value
	value?: string @protobuf(2,string)
}

#TCPHealthCheckConfig: {
	// Host to connect to, defaults to localhost
	host?: string @protobuf(1,string)

	// Port of host
	port: uint32 @protobuf(2,uint32)
}

#ExecHealthCheckConfig: {
	// Command to run. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
	command?: [...string] @protobuf(1,string)
}
