// $schema: istio.security.v1beta1.AuthorizationPolicy
// $title: Authorization Policy
// $description: Configuration for access control on workloads.
// $location: https://istio.io/docs/reference/config/security/authorization-policy.html
// $weight: 20
// $aliases: [/docs/reference/config/authorization/authorization-policy]

// Istio Authorization Policy enables access control on workloads in the mesh.
//
// Authorization policy supports CUSTOM, DENY and ALLOW actions for access control. When CUSTOM, DENY and ALLOW actions
// are used for a workload at the same time, the CUSTOM action is evaluated first, then the DENY action, and finally the ALLOW action.
// The evaluation is determined by the following rules:
//
// 1. If there are any CUSTOM policies that match the request, evaluate and deny the request if the evaluation result is deny.
// 2. If there are any DENY policies that match the request, deny the request.
// 3. If there are no ALLOW policies for the workload, allow the request.
// 4. If any of the ALLOW policies match the request, allow the request.
// 5. Deny the request.
//
// Istio Authorization Policy also supports the AUDIT action to decide whether to log requests.
// AUDIT policies do not affect whether requests are allowed or denied to the workload.
// Requests will be allowed or denied based solely on CUSTOM, DENY and ALLOW actions.
//
// A request will be internally marked that it should be audited if there is an AUDIT policy on the workload that matches the request.
// A separate plugin must be configured and enabled to actually fulfill the audit decision and complete the audit behavior.
// The request will not be audited if there are no such supporting plugins enabled.
//
// Here is an example of Istio Authorization Policy:
//
// It sets the `action` to `ALLOW` to create an allow policy. The default action is `ALLOW`
// but it is useful to be explicit in the policy.
//
// It allows requests from:
//
// - service account `cluster.local/ns/default/sa/sleep` or
// - namespace `test`
//
// to access the workload with:
//
// - `GET` method at paths of prefix `/info` or,
// - `POST` method at path `/data`.
//
// when the request has a valid JWT token issued by `https://accounts.google.com`.
//
// Any other requests will be denied.
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//   name: httpbin
//   namespace: foo
// spec:
//   action: ALLOW
//   rules:
//   - from:
//     - source:
//         principals: ["cluster.local/ns/default/sa/sleep"]
//     - source:
//         namespaces: ["test"]
//     to:
//     - operation:
//         methods: ["GET"]
//         paths: ["/info*"]
//     - operation:
//         methods: ["POST"]
//         paths: ["/data"]
//     when:
//     - key: request.auth.claims[iss]
//       values: ["https://accounts.google.com"]
// ```
//
// The following is another example that sets `action` to `DENY` to create a deny policy.
// It denies requests from the `dev` namespace to the `POST` method on all workloads
// in the `foo` namespace.
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//   name: httpbin
//   namespace: foo
// spec:
//   action: DENY
//   rules:
//   - from:
//     - source:
//         namespaces: ["dev"]
//     to:
//     - operation:
//         methods: ["POST"]
// ```
//
// The following is another example that sets `action` to `DENY` to create a deny policy.
// It denies all the requests with `POST` method on port `8080` on all workloads
// in the `foo` namespace.
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//   name: httpbin
//   namespace: foo
// spec:
//   action: DENY
//   rules:
//   - to:
//     - operation:
//         methods: ["POST"]
//         ports: ["8080"]
// ```
//
// When this rule is applied to TCP traffic, the `method` field (as will all HTTP based attributes) cannot be processed.
// For a `DENY` rule, missing attributes are treated as matches. This means all TCP traffic on port `8080` would be denied in the example above.
// If we were to remove the `ports` match, all TCP traffic would be denied. As a result, it is recommended to always scope `DENY` policies to a specific port,
// especially when using HTTP attributes [Authorization Policy for TCP Ports](https://istio.io/latest/docs/tasks/security/authorization/authz-tcp/).
//
// The following authorization policy sets the `action` to `AUDIT`. It will audit any `GET` requests to the path with the
// prefix `/user/profile`.
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//   namespace: ns1
//   name: anyname
// spec:
//   selector:
//     matchLabels:
//       app: myapi
//   action: AUDIT
//   rules:
//   - to:
//     - operation:
//         methods: ["GET"]
//         paths: ["/user/profile/*"]
// ```
//
// Authorization Policy scope (target) is determined by "metadata/namespace" and
// an optional `selector`.
//
// - "metadata/namespace" tells which namespace the policy applies. If set to root
// namespace, the policy applies to all namespaces in a mesh.
// - workload `selector` can be used to further restrict where a policy applies.
//
// For example, the following authorization policy applies to all workloads in namespace `foo`. It allows nothing and effectively denies
// all requests to workloads in namespace `foo`.
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//  name: allow-nothing
//  namespace: foo
// spec:
//   {}
// ```
//
// The following authorization policy allows all requests to workloads in namespace `foo`.
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//  name: allow-all
//  namespace: foo
// spec:
//  rules:
//  - {}
// ```
//
// The following authorization policy applies to workloads containing label `app: httpbin` in namespace `bar`. It allows
// nothing and effectively denies all requests to the selected workloads.
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//   name: allow-nothing
//   namespace: bar
// spec:
//   selector:
//     matchLabels:
//       app: httpbin
// ```
//
// The following authorization policy applies to workloads containing label `version: v1` in all namespaces in the mesh.
// (Assuming the root namespace is configured to `istio-system`).
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//  name: allow-nothing
//  namespace: istio-system
// spec:
//  selector:
//    matchLabels:
//      version: v1
// ```
//
// The following example shows you how to set up an authorization policy using an [experimental annotation](https://istio.io/latest/docs/reference/config/annotations/)
// `istio.io/dry-run` to dry-run the policy without actually enforcing it.
//
// The dry-run annotation allows you to better understand the effect of an authorization policy before applying it to the production traffic.
// This helps to reduce the risk of breaking the production traffic caused by an incorrect authorization policy.
// For more information, see [dry-run tasks](https://istio.io/latest/docs/tasks/security/authorization/authz-dry-run/).
//
// ```yaml
// apiVersion: security.istio.io/v1
// kind: AuthorizationPolicy
// metadata:
//   name: dry-run-example
//   annotations:
//     "istio.io/dry-run": "true"
// spec:
//   selector:
//     matchLabels:
//       app: httpbin
//   action: DENY
//   rules:
//   - to:
//     - operation:
//         paths: ["/headers"]
// ```
package v1beta1

import "istio.io/api/type/v1beta1"

// AuthorizationPolicy enables access control on workloads.
//
// <!-- crd generation tags
// +cue-gen:AuthorizationPolicy:groupName:security.istio.io
// +cue-gen:AuthorizationPolicy:versions:v1beta1,v1
// +cue-gen:AuthorizationPolicy:storageVersion
// +cue-gen:AuthorizationPolicy:annotations:helm.sh/resource-policy=keep
// +cue-gen:AuthorizationPolicy:labels:app=istio-pilot,chart=istio,istio=security,heritage=Tiller,release=istio
// +cue-gen:AuthorizationPolicy:subresource:status
// +cue-gen:AuthorizationPolicy:scope:Namespaced
// +cue-gen:AuthorizationPolicy:resource:categories=istio-io,security-istio-io,shortNames=ap,plural=authorizationpolicies
// +cue-gen:AuthorizationPolicy:preserveUnknownFields:false
// +cue-gen:AuthorizationPolicy:printerColumn:name=Action,type=string,JSONPath=.spec.action,description="The operation to take."
// +cue-gen:AuthorizationPolicy:printerColumn:name=Age,type=date,JSONPath=.metadata.creationTimestamp,description="CreationTimestamp is a timestamp
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
#AuthorizationPolicy: {
	// Optional. The selector decides where to apply the authorization policy. The selector will match with workloads
	// in the same namespace as the authorization policy. If the authorization policy is in the root namespace, the selector
	// will additionally match with workloads in all namespaces.
	//
	// If the selector and the targetRef are not set, the selector will match all workloads.
	//
	// At most one of `selector` or `targetRefs` can be set for a given policy.
	selector?: v1beta1.#WorkloadSelector @protobuf(1,istio.type.v1beta1.WorkloadSelector)

	// $hide_from_docs
	targetRef?: v1beta1.#PolicyTargetReference @protobuf(5,istio.type.v1beta1.PolicyTargetReference)

	// Optional. The targetRefs specifies a list of resources the policy should be
	// applied to. The targeted resources specified will determine which workloads
	// the policy applies to.
	//
	// Currently, the following resource attachment types are supported:
	// * `kind: Gateway` with `group: gateway.networking.k8s.io` in the same namespace.
	// * `kind: Service` with `""` in the same namespace. This type is only supported for waypoints.
	//
	// If not set, the policy is applied as defined by the selector.
	// At most one of the selector and targetRefs can be set.
	//
	// NOTE: If you are using the `targetRefs` field in a multi-revision environment with Istio versions prior to 1.22,
	// it is highly recommended that you pin the policy to a revision running 1.22+ via the `istio.io/rev` label.
	// This is to prevent proxies connected to older control planes (that don't know about the `targetRefs` field)
	// from misinterpreting the policy as namespace-wide during the upgrade process.
	//
	// NOTE: Waypoint proxies are required to use this field for policies to apply; `selector` policies will be ignored.
	targetRefs?: [...v1beta1.#PolicyTargetReference] @protobuf(6,istio.type.v1beta1.PolicyTargetReference)

	// Optional. A list of rules to match the request. A match occurs when at least one rule matches the request.
	//
	// If not set, the match will never occur. This is equivalent to setting a default of deny for the target workloads if
	// the action is ALLOW.
	rules?: [...#Rule] @protobuf(2,Rule)

	// Action specifies the operation to take.
	#Action: {
		// Allow a request only if it matches the rules. This is the default type.
		"ALLOW"
		#enumValue: 0
	} | {
		// Deny a request if it matches any of the rules.
		"DENY"
		#enumValue: 1
	} | {
		// Audit a request if it matches any of the rules.
		"AUDIT"
		#enumValue: 2
	} | {
		// The CUSTOM action allows an extension to handle the user request if the matching rules evaluate to true.
		// The extension is evaluated independently and before the native ALLOW and DENY actions. When used together, A request
		// is allowed if and only if all the actions return allow, in other words, the extension cannot bypass the
		// authorization decision made by ALLOW and DENY action.
		// Extension behavior is defined by the named providers declared in MeshConfig. The authorization policy refers to
		// the extension by specifying the name of the provider.
		// One example use case of the extension is to integrate with a custom external authorization system to delegate
		// the authorization decision to it.
		//
		// The following authorization policy applies to an ingress gateway and delegates the authorization check to a named extension
		// `my-custom-authz` if the request path has prefix `/admin/`.
		//
		// ```yaml
		// apiVersion: security.istio.io/v1
		// kind: AuthorizationPolicy
		// metadata:
		//   name: ext-authz
		//   namespace: istio-system
		// spec:
		//   selector:
		//     matchLabels:
		//       app: istio-ingressgateway
		//   action: CUSTOM
		//   provider:
		//     name: "my-custom-authz"
		//   rules:
		//   - to:
		//     - operation:
		//         paths: ["/admin/*"]
		// ```
		"CUSTOM"
		#enumValue: 3
	}

	#Action_value: {
		ALLOW:  0
		DENY:   1
		AUDIT:  2
		CUSTOM: 3
	}

	// Optional. The action to take if the request is matched with the rules. Default is ALLOW if not specified.
	action?: #Action @protobuf(3,Action)

	#ExtensionProvider: {
		// Specifies the name of the extension provider. The list of available providers is defined in the MeshConfig.
		// Note, currently at most 1 extension provider is allowed per workload. Different workloads can use different extension provider.
		name?: string @protobuf(1,string)
	}
	{} | {
		// Specifies detailed configuration of the CUSTOM action. Must be used only with CUSTOM action.
		provider: #ExtensionProvider @protobuf(4,ExtensionProvider)
	}
}

// Rule matches requests from a list of sources that perform a list of operations subject to a
// list of conditions. A match occurs when at least one source, one operation and all conditions
// matches the request. An empty rule is always matched.
//
// Any string field in the rule supports Exact, Prefix, Suffix and Presence match:
//
// - Exact match: `abc` will match on value `abc`.
// - Prefix match: `abc*` will match on value `abc` and `abcd`.
// - Suffix match: `*abc` will match on value `abc` and `xabc`.
// - Presence match: `*` will match when value is not empty.
#Rule: {
	// From includes a list of sources.
	#From: {
		// Source specifies the source of a request.
		source?: #Source @protobuf(1,Source)
	}

	// Optional. `from` specifies the source of a request.
	//
	// If not set, any source is allowed.
	from?: [...#From] @protobuf(1,From)

	// To includes a list of operations.
	#To: {
		// Operation specifies the operation of a request.
		operation?: #Operation @protobuf(1,Operation)
	}

	// Optional. `to` specifies the operation of a request.
	//
	// If not set, any operation is allowed.
	to?: [...#To] @protobuf(2,To)

	// Optional. `when` specifies a list of additional conditions of a request.
	//
	// If not set, any condition is allowed.
	when?: [...#Condition] @protobuf(3,Condition)
}

// Source specifies the source identities of a request. Fields in the source are
// ANDed together.
//
// For example, the following source matches if the principal is `admin` or `dev`
// and the namespace is `prod` or `test` and the ip is not `203.0.113.4`.
//
// ```yaml
// principals: ["admin", "dev"]
// namespaces: ["prod", "test"]
// notIpBlocks: ["203.0.113.4"]
// ```
#Source: {
	// Optional. A list of peer identities derived from the peer certificate. The peer identity is in the format of
	// `"<TRUST_DOMAIN>/ns/<NAMESPACE>/sa/<SERVICE_ACCOUNT>"`, for example, `"cluster.local/ns/default/sa/productpage"`.
	// This field requires mTLS enabled and is the same as the `source.principal` attribute.
	//
	// If not set, any principal is allowed.
	principals?: [...string] @protobuf(1,string)

	// Optional. A list of negative match of peer identities.
	notPrincipals?: [...string] @protobuf(5,string,name=not_principals)

	// Optional. A list of request identities derived from the JWT. The request identity is in the format of
	// `"<ISS>/<SUB>"`, for example, `"example.com/sub-1"`. This field requires request authentication enabled and is the
	// same as the `request.auth.principal` attribute.
	//
	// If not set, any request principal is allowed.
	requestPrincipals?: [...string] @protobuf(2,string,name=request_principals)

	// Optional. A list of negative match of request identities.
	notRequestPrincipals?: [...string] @protobuf(6,string,name=not_request_principals)

	// Optional. A list of namespaces derived from the peer certificate.
	// This field requires mTLS enabled and is the same as the `source.namespace` attribute.
	//
	// If not set, any namespace is allowed.
	namespaces?: [...string] @protobuf(3,string)

	// Optional. A list of negative match of namespaces.
	notNamespaces?: [...string] @protobuf(7,string,name=not_namespaces)

	// Optional. A list of IP blocks, populated from the source address of the IP packet. Single IP (e.g. `203.0.113.4`) and
	// CIDR (e.g. `203.0.113.0/24`) are supported. This is the same as the `source.ip` attribute.
	//
	// If not set, any IP is allowed.
	ipBlocks?: [...string] @protobuf(4,string,name=ip_blocks)

	// Optional. A list of negative match of IP blocks.
	notIpBlocks?: [...string] @protobuf(8,string,name=not_ip_blocks)

	// Optional. A list of IP blocks, populated from `X-Forwarded-For` header or proxy protocol.
	// To make use of this field, you must configure the `numTrustedProxies` field of the `gatewayTopology` under the `meshConfig`
	// when you install Istio or using an annotation on the ingress gateway.  See the documentation here:
	// [Configuring Gateway Network Topology](https://istio.io/latest/docs/ops/configuration/traffic-management/network-topologies/).
	// Single IP (e.g. `203.0.113.4`) and CIDR (e.g. `203.0.113.0/24`) are supported.
	// This is the same as the `remote.ip` attribute.
	//
	// If not set, any IP is allowed.
	remoteIpBlocks?: [...string] @protobuf(9,string,name=remote_ip_blocks)

	// Optional. A list of negative match of remote IP blocks.
	notRemoteIpBlocks?: [...string] @protobuf(10,string,name=not_remote_ip_blocks)
}

// Operation specifies the operations of a request. Fields in the operation are
// ANDed together.
//
// For example, the following operation matches if the host has suffix `.example.com`
// and the method is `GET` or `HEAD` and the path doesn't have prefix `/admin`.
//
// ```yaml
// hosts: ["*.example.com"]
// methods: ["GET", "HEAD"]
// notPaths: ["/admin*"]
// ```
#Operation: {
	// Optional. A list of hosts as specified in the HTTP request. The match is case-insensitive.
	// See the [security best practices](https://istio.io/latest/docs/ops/best-practices/security/#writing-host-match-policies) for
	// recommended usage of this field.
	//
	// If not set, any host is allowed. Must be used only with HTTP.
	hosts?: [...string] @protobuf(1,string)

	// Optional. A list of negative match of hosts as specified in the HTTP request. The match is case-insensitive.
	notHosts?: [...string] @protobuf(5,string,name=not_hosts)

	// Optional. A list of ports as specified in the connection.
	//
	// If not set, any port is allowed.
	ports?: [...string] @protobuf(2,string)

	// Optional. A list of negative match of ports as specified in the connection.
	notPorts?: [...string] @protobuf(6,string,name=not_ports)

	// Optional. A list of methods as specified in the HTTP request.
	// For gRPC service, this will always be `POST`.
	//
	// If not set, any method is allowed. Must be used only with HTTP.
	methods?: [...string] @protobuf(3,string)

	// Optional. A list of negative match of methods as specified in the HTTP request.
	notMethods?: [...string] @protobuf(7,string,name=not_methods)

	// Optional. A list of paths as specified in the HTTP request. See the [Authorization Policy Normalization](https://istio.io/latest/docs/reference/config/security/normalization/)
	// for details of the path normalization.
	// For gRPC service, this will be the fully-qualified name in the form of `/package.service/method`.
	//
	// If a path in the list contains the `{*}` or `{**}` path template operator, it will be interpreted as an [Envoy Uri Template](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/path/match/uri_template/v3/uri_template_match.proto).
	// To be a valid path template, the path must not contain `*`, `{`, or `}` outside of a supported operator. No other characters are allowed in the path segment with the path template operator.
	// - `{*}` matches a single glob that cannot extend beyond a path segment.
	// - `{**}` matches zero or more globs. If a path contains `{**}`, it must be the last operator.
	//
	// Examples:
	// - `/foo/{*}` matches `/foo/bar` but not `/foo/bar/baz`
	// - `/foo/{**}/` matches `/foo/bar/`, `/foo/bar/baz.txt`, and `/foo//` but not `/foo/bar`
	// - `/foo/{*}/bar/{**}` matches `/foo/buzz/bar/` and `/foo/buzz/bar/baz`
	// - `/*/baz/{*}` is not a valid path template since it includes `*` outside of a supported operator
	// - `/**/baz/{*}` is not a valid path template since it includes `**` outside of a supported operator
	// - `/{**}/foo/{*}` is not a valid path template since `{**}` is not the last operator
	// - `/foo/{*}.txt` is invalid since there are characters other than `{*}` in the path segment
	//
	// If not set, any path is allowed. Must be used only with HTTP.
	paths?: [...string] @protobuf(4,string)

	// Optional. A list of negative match of paths.
	notPaths?: [...string] @protobuf(8,string,name=not_paths)
}

// Condition specifies additional required attributes.
#Condition: {
	// The name of an Istio attribute.
	// See the [full list of supported attributes](https://istio.io/docs/reference/config/security/conditions/).
	key: string @protobuf(1,string)

	// Optional. A list of allowed values for the attribute.
	// Note: at least one of `values` or `notValues` must be set.
	values?: [...string] @protobuf(2,string)

	// Optional. A list of negative match of values for the attribute.
	// Note: at least one of `values` or `notValues` must be set.
	notValues?: [...string] @protobuf(3,string,name=not_values)
}
