// $title: Workload Selector
// $description: Definition of a workload selector.
// $location: https://istio.io/docs/reference/config/type/workload-selector.html
package v1beta1

// WorkloadSelector specifies the criteria used to determine if a policy can be applied
// to a proxy. The matching criteria includes the metadata associated with a proxy,
// workload instance info such as labels attached to the pod/VM, or any other info
// that the proxy provides to Istio during the initial handshake. If multiple conditions are
// specified, all conditions need to match in order for the workload instance to be
// selected. Currently, only label based selection mechanism is supported.
#WorkloadSelector: {
	// One or more labels that indicate a specific set of pods/VMs
	// on which a policy should be applied. The scope of label search is restricted to
	// the configuration namespace in which the resource is present.
	// +kubebuilder:validation:XValidation:message="wildcard not allowed in label key match",rule="self.all(key, !key.contains('*'))"
	// +kubebuilder:validation:XValidation:message="key must not be empty",rule="self.all(key, key.size() != 0)"
	// +kubebuilder:map-value-validation:XValidation:message="wildcard not allowed in label value match",rule="!self.contains('*')"
	// +kubebuilder:map-value-validation:MaxLength=63
	// +kubebuilder:validation:MaxProperties=4096
	matchLabels?: {
		[string]: string
	} @protobuf(1,map[string]string,match_labels)
}

// PortSelector is the criteria for specifying if a policy can be applied to
// a listener having a specific port.
#PortSelector: {
	// Port number
	// +kubebuilder:validation:Minimum=1
	// +kubebuilder:validation:Maximum=65535
	number: uint32 @protobuf(1,uint32)
}

// WorkloadMode allows selection of the role of the underlying workload in
// network traffic. A workload is considered as acting as a SERVER if it is
// the destination of the traffic (that is, traffic direction, from the
// perspective of the workload is *inbound*). If the workload is the source of
// the network traffic, it is considered to be in CLIENT mode (traffic is
// *outbound* from the workload).
#WorkloadMode: {
	// Default value, which will be interpreted by its own usage.
	"UNDEFINED"
	#enumValue: 0
} | {
	// Selects for scenarios when the workload is the
	// source of the network traffic. In addition,
	// if the workload is a gateway, selects this.
	"CLIENT"
	#enumValue: 1
} | {
	// Selects for scenarios when the workload is the
	// destination of the network traffic.
	"SERVER"
	#enumValue: 2
} | {
	// Selects for scenarios when the workload is either the
	// source or destination of the network traffic.
	"CLIENT_AND_SERVER"
	#enumValue: 3
}

#WorkloadMode_value: {
	UNDEFINED:         0
	CLIENT:            1
	SERVER:            2
	CLIENT_AND_SERVER: 3
}

// PolicyTargetReference format as defined by [GEP-2648](https://gateway-api.sigs.k8s.io/geps/gep-2648/#direct-policy-design-rules).
//
// PolicyTargetReference specifies the targeted resource which the policy
// should be applied to. It must only target a single resource at a time, but it
// can be used to target larger resources such as Gateways that may apply to
// multiple child resources. The PolicyTargetReference will be used instead of
// a WorkloadSelector in the RequestAuthentication, AuthorizationPolicy,
// Telemetry, and WasmPlugin CRDs to target a Kubernetes Gateway.
//
// The following is an example of an AuthorizationPolicy bound to a waypoint proxy using
// a PolicyTargetReference. The example sets `action` to `DENY` to create a deny policy.
// It denies all the requests with `POST` method on port `8080` directed through the
// `waypoint` Gateway in the `foo` namespace.
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//   name: httpbin
//   namespace: foo
// spec:
//   targetRefs:
//   - name: waypoint
//     kind: Gateway
//     group: gateway.networking.k8s.io
//   action: DENY
//   rules:
//   - to:
//     - operation:
//         methods: ["POST"]
//         ports: ["8080"]
// ```
// +kubebuilder:validation:XValidation:message="Support kinds are core/Service and gateway.networking.k8s.io/Gateway",rule="[self.group, self.kind] in [['core','Service'], ['','Service'], ['gateway.networking.k8s.io','Gateway']]"
#PolicyTargetReference: {
	// group is the group of the target resource.
	// +kubebuilder:validation:MaxLength=253
	// +kubebuilder:validation:Pattern=`^$|^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$`
	group?: string @protobuf(1,string)

	// kind is kind of the target resource.
	// +kubebuilder:validation:MinLength=1
	// +kubebuilder:validation:MaxLength=63
	// +kubebuilder:validation:Pattern=`^[a-zA-Z]([-a-zA-Z0-9]*[a-zA-Z0-9])?$`
	kind: string @protobuf(2,string)

	// name is the name of the target resource.
	// +kubebuilder:validation:MinLength=1
	// +kubebuilder:validation:MaxLength=253
	name: string @protobuf(3,string)

	// namespace is the namespace of the referent. When unspecified, the local
	// namespace is inferred.
	// +kubebuilder:validation:XValidation:message="cross namespace referencing is not currently supported",rule="self.size() == 0"
	namespace?: string @protobuf(4,string)
}
