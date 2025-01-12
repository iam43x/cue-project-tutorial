// $schema: istio.security.v1beta1.PeerAuthentication
// $title: PeerAuthentication
// $description: Peer authentication configuration for workloads.
// $location: https://istio.io/docs/reference/config/security/peer_authentication.html
// $aliases: [/docs/reference/config/security/v1beta1/peer_authentication]
package v1beta1

import "istio.io/api/type/v1beta1"

// PeerAuthentication defines mutual TLS (mTLS) requirements for incoming connections.
//
// In sidecar mode, PeerAuthentication determines whether or not mTLS is allowed or required
// for connections to an Envoy proxy sidecar.
//
// In ambient mode, security is transparently enabled for a pod by the ztunnel node agent.
// (Traffic between proxies uses the HBONE protocol, which includes encryption with mTLS.)
// Because of this, `DISABLE` mode is not supported.
// `STRICT` mode is useful to ensure that connections that bypass the mesh are not possible.
//
// Examples:
//
// Policy to require mTLS traffic for all workloads under namespace `foo`:
// ```yaml
// apiVersion: security.istio.io/v1
// kind: PeerAuthentication
// metadata:
//   name: default
//   namespace: foo
// spec:
//   mtls:
//     mode: STRICT
// ```
// For mesh level, put the policy in root-namespace according to your Istio installation.
//
// Policies to allow both mTLS and plaintext traffic for all workloads under namespace `foo`, but
// require mTLS for workload `finance`.
// ```yaml
// apiVersion: security.istio.io/v1
// kind: PeerAuthentication
// metadata:
//   name: default
//   namespace: foo
// spec:
//   mtls:
//     mode: PERMISSIVE
// ---
// apiVersion: security.istio.io/v1
// kind: PeerAuthentication
// metadata:
//   name: finance
//   namespace: foo
// spec:
//   selector:
//     matchLabels:
//       app: finance
//   mtls:
//     mode: STRICT
// ```
// Policy that enables strict mTLS for all `finance` workloads, but leaves the port `8080` to
// plaintext. Note the port value in the `portLevelMtls` field refers to the port
// of the workload, not the port of the Kubernetes service.
// ```yaml
// apiVersion: security.istio.io/v1
// kind: PeerAuthentication
// metadata:
//   name: default
//   namespace: foo
// spec:
//   selector:
//     matchLabels:
//       app: finance
//   mtls:
//     mode: STRICT
//   portLevelMtls:
//     8080:
//       mode: DISABLE
// ```
// Policy that inherits mTLS mode from namespace (or mesh) settings, and disables
// mTLS for workload port `8080`.
// ```yaml
// apiVersion: security.istio.io/v1
// kind: PeerAuthentication
// metadata:
//   name: default
//   namespace: foo
// spec:
//   selector:
//     matchLabels:
//       app: finance
//   mtls:
//     mode: UNSET
//   portLevelMtls:
//     8080:
//       mode: DISABLE
// ```
//
// <!-- crd generation tags
// +cue-gen:PeerAuthentication:groupName:security.istio.io
// +cue-gen:PeerAuthentication:versions:v1beta1,v1
// +cue-gen:PeerAuthentication:storageVersion
// +cue-gen:PeerAuthentication:annotations:helm.sh/resource-policy=keep
// +cue-gen:PeerAuthentication:labels:app=istio-pilot,chart=istio,istio=security,heritage=Tiller,release=istio
// +cue-gen:PeerAuthentication:subresource:status
// +cue-gen:PeerAuthentication:scope:Namespaced
// +cue-gen:PeerAuthentication:resource:categories=istio-io,security-istio-io,shortNames=pa
// +cue-gen:PeerAuthentication:preserveUnknownFields:false
// +cue-gen:PeerAuthentication:printerColumn:name=Mode,type=string,JSONPath=.spec.mtls.mode,description="Defines the mTLS mode used for peer authentication."
// +cue-gen:PeerAuthentication:printerColumn:name=Age,type=date,JSONPath=.metadata.creationTimestamp,description="CreationTimestamp is a timestamp
// representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations.
// Clients may not set this value. It is represented in RFC3339 form and is in UTC.
// Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata"
// -->
//
// <!-- go code generation tags
// +kubetype-gen
// +kubetype-gen:groupVersion=security.istio.io/v1beta1
// +genclient
// +k8s:deepcopy-gen=true
// -->
// +kubebuilder:validation:XValidation:message="portLevelMtls requires selector",rule="(has(self.selector) && has(self.selector.matchLabels) && self.selector.matchLabels.size() > 0) || !has(self.portLevelMtls)"
#PeerAuthentication: {
	// The selector determines the workloads to apply the PeerAuthentication on. The selector will match with workloads in the
	// same namespace as the policy. If the policy is in the root namespace, the selector will additionally match with workloads in all namespace.
	//
	// If not set, the policy will be applied to all workloads in the same namespace as the policy. If it is in the root namespace, it would be applied
	// to all workloads in the mesh.
	selector?: v1beta1.#WorkloadSelector @protobuf(1,istio.type.v1beta1.WorkloadSelector)

	// Mutual TLS settings.
	#MutualTLS: {
		#Mode: {
			// Inherit from parent, if has one. Otherwise treated as `PERMISSIVE`.
			"UNSET"
			#enumValue: 0
		} | {
			// Connection is not tunneled.
			"DISABLE"
			#enumValue: 1
		} | {
			// Connection can be either plaintext or mTLS tunnel.
			"PERMISSIVE"
			#enumValue: 2
		} | {
			// Connection is an mTLS tunnel (TLS with client cert must be presented).
			"STRICT"
			#enumValue: 3
		}

		#Mode_value: {
			UNSET:      0
			DISABLE:    1
			PERMISSIVE: 2
			STRICT:     3
		}

		// Defines the mTLS mode used for peer authentication.
		mode?: #Mode @protobuf(1,Mode)
	}

	// Mutual TLS settings for workload. If not defined, inherit from parent.
	mtls?: #MutualTLS @protobuf(2,MutualTLS)

	// Port specific mutual TLS settings. These only apply when a workload selector
	// is specified. The port refers to the port of the workload, not the port of the
	// Kubernetes service.
	// +kubebuilder:validation:XValidation:message="port must be between 1-65535",rule="self.all(key, 0 < int(key) && int(key) <= 65535)"
	// +kubebuilder:validation:MinProperties=1
	portLevelMtls?: {
		[string]: #MutualTLS
	} @protobuf(3,map[uint32]MutualTLS,port_level_mtls)
}
