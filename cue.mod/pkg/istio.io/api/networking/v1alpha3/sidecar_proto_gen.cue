// Copyright 2018 Istio Authors
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

// $schema: istio.networking.v1alpha3.Sidecar
// $title: Sidecar
// $description: Configuration affecting network reachability of a sidecar.
// $location: https://istio.io/docs/reference/config/networking/sidecar.html
// $aliases: [/docs/reference/config/networking/v1alpha3/sidecar]

// `Sidecar` describes the configuration of the sidecar proxy that mediates
// inbound and outbound communication to the workload instance it is attached to. By
// default, Istio will program all sidecar proxies in the mesh with the
// necessary configuration required to reach every workload instance in the mesh, as
// well as accept traffic on all the ports associated with the
// workload. The `Sidecar` configuration provides a way to fine tune the set of
// ports, protocols that the proxy will accept when forwarding traffic to
// and from the workload. In addition, it is possible to restrict the set
// of services that the proxy can reach when forwarding outbound traffic
// from workload instances.
//
// Services and configuration in a mesh are organized into one or more
// namespaces (e.g., a Kubernetes namespace or a CF org/space). A `Sidecar`
// configuration in a namespace will apply to one or more workload instances in the same
// namespace, selected using the `workloadSelector` field. In the absence of a
// `workloadSelector`, it will apply to all workload instances in the same
// namespace. When determining the `Sidecar` configuration to be applied to a
// workload instance, preference will be given to the resource with a
// `workloadSelector` that selects this workload instance, over a `Sidecar` configuration
// without any `workloadSelector`.
//
// **NOTE 1**: *_Each namespace can have only one `Sidecar`
// configuration without any `workloadSelector`_ that specifies the
// default for all pods in that namespace*. It is recommended to use
// the name `default` for the namespace-wide sidecar. The behavior of
// the system is undefined if more than one selector-less `Sidecar`
// configurations exist in a given namespace. The behavior of the
// system is undefined if two or more `Sidecar` configurations with a
// `workloadSelector` select the same workload instance.
//
// **NOTE 2**: *_A `Sidecar` configuration in the `MeshConfig`
// [root namespace](https://istio.io/docs/reference/config/istio.mesh.v1alpha1/#MeshConfig)
// will be applied by default to all namespaces without a `Sidecar`
// configuration_*. This global default `Sidecar` configuration should not have
// any `workloadSelector`.
//
// **NOTE 3**: *_A `Sidecar` is not applicable to gateways, even though gateways are istio-proxies_*.
//
// The example below declares a global default `Sidecar` configuration
// in the root namespace called `istio-config`, that configures
// sidecars in all namespaces to allow egress traffic only to other
// workloads in the same namespace as well as to services in the
// `istio-system` namespace.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: Sidecar
// metadata:
//   name: default
//   namespace: istio-config
// spec:
//   egress:
//   - hosts:
//     - "./*"
//     - "istio-system/*"
// ```
//
// The example below declares a `Sidecar` configuration in the
// `prod-us1` namespace that overrides the global default defined
// above, and configures the sidecars in the namespace to allow egress
// traffic to public services in the `prod-us1`, `prod-apis`, and the
// `istio-system` namespaces.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: Sidecar
// metadata:
//   name: default
//   namespace: prod-us1
// spec:
//   egress:
//   - hosts:
//     - "prod-us1/*"
//     - "prod-apis/*"
//     - "istio-system/*"
// ```
//
// The following example declares a `Sidecar` configuration in the
// `prod-us1` namespace for all pods with labels `app: ratings`
// belonging to the `ratings.prod-us1` service.  The workload accepts
// inbound HTTP traffic on port 9080. The traffic is then forwarded to
// the attached workload instance listening on a Unix domain
// socket. In the egress direction, in addition to the `istio-system`
// namespace, the sidecar proxies only HTTP traffic bound for port
// 9080 for services in the `prod-us1` namespace.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: Sidecar
// metadata:
//   name: ratings
//   namespace: prod-us1
// spec:
//   workloadSelector:
//     labels:
//       app: ratings
//   ingress:
//   - port:
//       number: 9080
//       protocol: HTTP
//       name: somename
//     defaultEndpoint: unix:///var/run/someuds.sock
//   egress:
//   - port:
//       number: 9080
//       protocol: HTTP
//       name: egresshttp
//     hosts:
//     - "prod-us1/*"
//   - hosts:
//     - "istio-system/*"
// ```
//
// If the workload is deployed without IPTables-based traffic capture,
// the `Sidecar` configuration is the only way to configure the ports
// on the proxy attached to the workload instance. The following
// example declares a `Sidecar` configuration in the `prod-us1`
// namespace for all pods with labels `app: productpage` belonging to
// the `productpage.prod-us1` service. Assuming that these pods are
// deployed without IPtable rules (i.e. the `istio-init` container)
// and the proxy metadata `ISTIO_META_INTERCEPTION_MODE` is set to
// `NONE`, the specification, below, allows such pods to receive HTTP
// traffic on port 9080 (wrapped inside Istio mutual TLS) and forward
// it to the application listening on `127.0.0.1:8080`. It also allows
// the application to communicate with a backing MySQL database on
// `127.0.0.1:3306`, that then gets proxied to the externally hosted
// MySQL service at `mysql.foo.com:3306`.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: Sidecar
// metadata:
//   name: no-ip-tables
//   namespace: prod-us1
// spec:
//   workloadSelector:
//     labels:
//       app: productpage
//   ingress:
//   - port:
//       number: 9080 # binds to proxy_instance_ip:9080 (0.0.0.0:9080, if no unicast IP is available for the instance)
//       protocol: HTTP
//       name: somename
//     defaultEndpoint: 127.0.0.1:8080
//     captureMode: NONE # not needed if metadata is set for entire proxy
//   egress:
//   - port:
//       number: 3306
//       protocol: MYSQL
//       name: egressmysql
//     captureMode: NONE # not needed if metadata is set for entire proxy
//     bind: 127.0.0.1
//     hosts:
//     - "*/mysql.foo.com"
// ```
//
// And the associated service entry for routing to `mysql.foo.com:3306`
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: ServiceEntry
// metadata:
//   name: external-svc-mysql
//   namespace: ns1
// spec:
//   hosts:
//   - mysql.foo.com
//   ports:
//   - number: 3306
//     name: mysql
//     protocol: MYSQL
//   location: MESH_EXTERNAL
//   resolution: DNS
// ```
//
// It is also possible to mix and match traffic capture modes in a single
// proxy. For example, consider a setup where internal services are on the
// `192.168.0.0/16` subnet. So, IP tables are setup on the VM to capture all
// outbound traffic on `192.168.0.0/16` subnet. Assume that the VM has an
// additional network interface on `172.16.0.0/16` subnet for inbound
// traffic. The following `Sidecar` configuration allows the VM to expose a
// listener on `172.16.1.32:80` (the VM's IP) for traffic arriving from the
// `172.16.0.0/16` subnet.
//
// **NOTE**: The `ISTIO_META_INTERCEPTION_MODE` metadata on the
// proxy in the VM should contain `REDIRECT` or `TPROXY` as its value,
// implying that IP tables based traffic capture is active.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: Sidecar
// metadata:
//   name: partial-ip-tables
//   namespace: prod-us1
// spec:
//   workloadSelector:
//     labels:
//       app: productpage
//   ingress:
//   - bind: 172.16.1.32
//     port:
//       number: 80 # binds to 172.16.1.32:80
//       protocol: HTTP
//       name: somename
//     defaultEndpoint: 127.0.0.1:8080
//     captureMode: NONE
//   egress:
//     # use the system detected defaults
//     # sets up configuration to handle outbound traffic to services
//     # in 192.168.0.0/16 subnet, based on information provided by the
//     # service registry
//   - captureMode: IPTABLES
//     hosts:
//     - "*/*"
// ```
//
// The following example declares a `Sidecar` configuration in the
// `prod-us1` namespace for all pods with labels `app: ratings`
// belonging to the `ratings.prod-us1` service.  The service accepts
// inbound HTTPS traffic on port 8443 and the sidecar proxy terminates
// one way TLS using the given server certificates.
// The traffic is then forwarded to the attached workload instance
// listening on a Unix domain socket.
// It is expected that PeerAuthentication policy would be configured
// in order to set mTLS mode to "DISABLE" on specific
// ports.
// In this example, the mTLS mode is disabled on PORT 80.
// This feature is currently experimental.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: Sidecar
// metadata:
//   name: ratings
//   namespace: prod-us1
// spec:
//   workloadSelector:
//     labels:
//       app: ratings
//   ingress:
//   - port:
//       number: 80
//       protocol: HTTPS
//       name: somename
//     defaultEndpoint: unix:///var/run/someuds.sock
//     tls:
//       mode: SIMPLE
//       privateKey: "/etc/certs/privatekey.pem"
//       serverCertificate: "/etc/certs/servercert.pem"
// ---
// apiVersion: v1
// kind: Service
// metadata:
//   name: ratings
//   labels:
//     app: ratings
//     service: ratings
// spec:
//   ports:
//   - port: 8443
//     name: https
//     targetPort: 80
//   selector:
//     app: ratings
// ---
// apiVersion: security.istio.io/v1
// kind: PeerAuthentication
// metadata:
//   name: ratings-peer-auth
//   namespace: prod-us1
// spec:
//   selector:
//     matchLabels:
//       app: ratings
//   mtls:
//     mode: STRICT
//   portLevelMtls:
//     80:
//       mode: DISABLE
// ```
//
// In addition to configuring traffic capture and how traffic is forwarded to the app,
// it's possible to control inbound connection pool settings. By default, Istio pushes
// connection pool settings from `DestinationRules` to both clients (for outbound
// connections to the service) as well as servers (for inbound connections to a service
// instance). Using the `InboundConnectionPool` and per-port `ConnectionPool` settings
// in a `Sidecar` allow you to control those connection pools for the server separately
// from the settings pushed to all clients.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: Sidecar
// metadata:
//   name: connection-pool-settings
//   namespace: prod-us1
// spec:
//   workloadSelector:
//     labels:
//       app: productpage
//   inboundConnectionPool:
//       http:
//         http1MaxPendingRequests: 1024
//         http2MaxRequests: 1024
//         maxRequestsPerConnection: 1024
//         maxRetries: 100
//   ingress:
//   - port:
//       number: 80
//       protocol: HTTP
//       name: somename
//     connectionPool:
//       http:
//         http1MaxPendingRequests: 1024
//         http2MaxRequests: 1024
//         maxRequestsPerConnection: 1024
//         maxRetries: 100
//       tcp:
//         maxConnections: 100
// ```
package v1alpha3

// `Sidecar` describes the configuration of the sidecar proxy that mediates
// inbound and outbound communication of the workload instance to which it is
// attached.
//
// <!-- crd generation tags
// +cue-gen:Sidecar:groupName:networking.istio.io
// +cue-gen:Sidecar:versions:v1beta1,v1alpha3,v1
// +cue-gen:Sidecar:annotations:helm.sh/resource-policy=keep
// +cue-gen:Sidecar:labels:app=istio-pilot,chart=istio,heritage=Tiller,release=istio
// +cue-gen:Sidecar:subresource:status
// +cue-gen:Sidecar:scope:Namespaced
// +cue-gen:Sidecar:resource:categories=istio-io,networking-istio-io
// +cue-gen:Sidecar:preserveUnknownFields:false
// -->
//
// <!-- go code generation tags
// +kubetype-gen
// +kubetype-gen:groupVersion=networking.istio.io/v1alpha3
// +genclient
// +k8s:deepcopy-gen=true
// -->
#Sidecar: {
	// Criteria used to select the specific set of pods/VMs on which this
	// `Sidecar` configuration should be applied. If omitted, the `Sidecar`
	// configuration will be applied to all workload instances in the same namespace.
	workloadSelector?: #WorkloadSelector @protobuf(1,WorkloadSelector,name=workload_selector)

	// Ingress specifies the configuration of the sidecar for processing
	// inbound traffic to the attached workload instance. If omitted, Istio will
	// automatically configure the sidecar based on the information about the workload
	// obtained from the orchestration platform (e.g., exposed ports, services,
	// etc.). If specified, inbound ports are configured if and only if the
	// workload instance is associated with a service.
	ingress?: [...#IstioIngressListener] @protobuf(2,IstioIngressListener)

	// Egress specifies the configuration of the sidecar for processing
	// outbound traffic from the attached workload instance to other
	// services in the mesh. If not specified, inherits the system
	// detected defaults from the namespace-wide or the global default Sidecar.
	egress?: [...#IstioEgressListener] @protobuf(3,IstioEgressListener)

	// Settings controlling the volume of connections Envoy will accept from the network.
	// This default will apply for all inbound listeners and can be overridden per-port
	// in the `Ingress` field. This configuration mirrors the `DestinationRule`'s
	// [`connectionPool`](https://istio.io/latest/docs/reference/config/networking/destination-rule/#ConnectionPoolSettings) field.
	//
	// By default, Istio applies a service's `DestinationRule` to client sidecars
	// for outbound traffic directed at the service -- the usual case folks think
	// of when configuring a `DestinationRule` -- but also to the server's inbound
	// sidecar. The `Sidecar`'s connection pool configures the server's inbound
	// sidecar directly, so its settings can be different than clients'. This is
	// valuable, for example, when you have many clients calling few servers: a
	// `DestinationRule` can limit the concurrency of any single client, while
	// the `Sidecar` allows you to configure much higher concurrency on the server
	// side.
	//
	// Connection pool settings for a server's inbound sidecar are configured in the
	// following precedence, highest to lowest:
	// - per-port `ConnectionPool` from the `Sidecar`
	// - top level `InboundConnectionPool` from the `Sidecar`
	// - per-port `TrafficPolicy.ConnectionPool` from the `DestinationRule`
	// - top level `TrafficPolicy.ConnectionPool` from the `DestinationRule`
	// - default connection pool settings (essentially unlimited)
	//
	// In every case, the connection pool settings are overriden, not merged.
	inboundConnectionPool?: #ConnectionPoolSettings @protobuf(7,ConnectionPoolSettings,name=inbound_connection_pool)

	// Configuration for the outbound traffic policy.  If your
	// application uses one or more external services that are not known
	// apriori, setting the policy to `ALLOW_ANY` will cause the
	// sidecars to route any unknown traffic originating from the
	// application to its requested destination. If not specified,
	// inherits the system detected defaults from the namespace-wide or
	// the global default Sidecar.
	outboundTrafficPolicy?: #OutboundTrafficPolicy @protobuf(4,OutboundTrafficPolicy,name=outbound_traffic_policy)
}

// `IstioIngressListener` specifies the properties of an inbound
// traffic listener on the sidecar proxy attached to a workload instance.
#IstioIngressListener: {
	// The port associated with the listener.
	port: #SidecarPort @protobuf(1,SidecarPort)

	// The IP(IPv4 or IPv6) to which the listener should be bound.
	// Unix domain socket addresses are not allowed in
	// the bind field for ingress listeners. If omitted, Istio will
	// automatically configure the defaults based on imported services
	// and the workload instances to which this configuration is applied
	// to.
	bind?: string @protobuf(2,string)

	// The captureMode option dictates how traffic to the listener is
	// expected to be captured (or not).
	captureMode?: #CaptureMode @protobuf(3,CaptureMode,name=capture_mode)

	// The IP endpoint or Unix domain socket to which
	// traffic should be forwarded to. This configuration can be used to
	// redirect traffic arriving at the bind `IP:Port` on the sidecar to a `localhost:port`
	// or Unix domain socket where the application workload instance is listening for
	// connections. Arbitrary IPs are not supported. Format should be one of
	// `127.0.0.1:PORT`, `[::1]:PORT` (forward to localhost),
	// `0.0.0.0:PORT`, `[::]:PORT` (forward to the instance IP),
	// or `unix:///path/to/socket` (forward to Unix domain socket).
	defaultEndpoint?: string @protobuf(4,string,name=default_endpoint)

	// Set of TLS related options that will enable TLS termination on the
	// sidecar for requests originating from outside the mesh.
	// Currently supports only SIMPLE and MUTUAL TLS modes.
	tls?: #ServerTLSSettings @protobuf(7,ServerTLSSettings)

	// Settings controlling the volume of connections Envoy will accept from the network.
	// This setting overrides the top-level default `inboundConnectionPool` to configure
	// specific settings for this port. This configuration mirrors the `DestinationRule`'s
	// [`PortTrafficPolicy.connectionPool`](https://istio.io/latest/docs/reference/config/networking/destination-rule/#TrafficPolicy-PortTrafficPolicy) field.
	// This port level connection pool has the highest precedence in configuration,
	// overriding both the `Sidecar`'s top level `InboundConnectionPool` as well as any
	// connection pooling settings from the `DestinationRule`.
	connectionPool?: #ConnectionPoolSettings @protobuf(8,ConnectionPoolSettings,name=connection_pool)
}

// `IstioEgressListener` specifies the properties of an outbound traffic
// listener on the sidecar proxy attached to a workload instance.
#IstioEgressListener: {
	// The port associated with the listener. If using Unix domain socket,
	// use 0 as the port number, with a valid protocol. The port if
	// specified, will be used as the default destination port associated
	// with the imported hosts. If the port is omitted, Istio will infer the
	// listener ports based on the imported hosts. Note that when multiple
	// egress listeners are specified, where one or more listeners have
	// specific ports while others have no port, the hosts exposed on a
	// listener port will be based on the listener with the most specific
	// port.
	port?: #SidecarPort @protobuf(1,SidecarPort)

	// The IP(IPv4 or IPv6) or the Unix domain socket to which the listener should be bound
	// to. Port MUST be specified if bind is not empty. Format: IPv4 or IPv6 address formats or
	// `unix:///path/to/uds` or `unix://@foobar` (Linux abstract namespace). If
	// omitted, Istio will automatically configure the defaults based on imported
	// services, the workload instances to which this configuration is applied to and
	// the captureMode. If captureMode is `NONE`, bind will default to
	// 127.0.0.1.
	bind?: string @protobuf(2,string)

	// When the bind address is an IP, the captureMode option dictates
	// how traffic to the listener is expected to be captured (or not).
	// captureMode must be DEFAULT or `NONE` for Unix domain socket binds.
	captureMode?: #CaptureMode @protobuf(3,CaptureMode,name=capture_mode)

	// One or more service hosts exposed by the listener
	// in `namespace/dnsName` format. Services in the specified namespace
	// matching `dnsName` will be exposed.
	// The corresponding service can be a service in the service registry
	// (e.g., a Kubernetes or cloud foundry service) or a service specified
	// using a `ServiceEntry` or `VirtualService` configuration. Any
	// associated `DestinationRule` in the same namespace will also be used.
	//
	// The `dnsName` should be specified using FQDN format, optionally including
	// a wildcard character in the left-most component (e.g., `prod/*.example.com`).
	// Set the `dnsName` to `*` to select all services from the specified namespace
	// (e.g., `prod/*`).
	//
	// The `namespace` can be set to `*`, `.`, or `~`, representing any, the current,
	// or no namespace, respectively. For example, `*/foo.example.com` selects the
	// service from any available namespace while `./foo.example.com` only selects
	// the service from the namespace of the sidecar. If a host is set to `*/*`,
	// Istio will configure the sidecar to be able to reach every service in the
	// mesh that is exported to the sidecar's namespace. The value `~/*` can be used
	// to completely trim the configuration for sidecars that simply receive traffic
	// and respond, but make no outbound connections of their own.
	//
	// NOTE: Only services and configuration artifacts exported to the sidecar's
	// namespace (e.g., `exportTo` value of `*`) can be referenced.
	// Private configurations (e.g., `exportTo` set to `.`) will
	// not be available. Refer to the `exportTo` setting in `VirtualService`,
	// `DestinationRule`, and `ServiceEntry` configurations for details.
	hosts: [...string] @protobuf(4,string)
}

// `WorkloadSelector` specifies the criteria used to determine if the
// `Gateway`, `Sidecar`, `EnvoyFilter`, `ServiceEntry`, or `DestinationRule`
// configuration can be applied to a proxy. The matching criteria
// includes the metadata associated with a proxy, workload instance
// info such as labels attached to the pod/VM, or any other info that
// the proxy provides to Istio during the initial handshake. If
// multiple conditions are specified, all conditions need to match in
// order for the workload instance to be selected. Currently, only
// label based selection mechanism is supported.
#WorkloadSelector: {
	// One or more labels that indicate a specific set of pods/VMs
	// on which the configuration should be applied. The scope of
	// label search is restricted to the configuration namespace in which the
	// the resource is present.
	labels?: {
		[string]: string
	} @protobuf(1,map[string]string)
	// $hide_from_docs
	// other forms of identification supplied by the proxy
	// when connecting to Pilot, such as X509 fields, tenant IDs, JWT,
	// etc. This has nothing to do with the request level authN etc.
}

// `OutboundTrafficPolicy` sets the default behavior of the sidecar for
// handling outbound traffic from the application.
// If your application uses one or more external
// services that are not known apriori, setting the policy to `ALLOW_ANY`
// will cause the sidecars to route any unknown traffic originating from
// the application to its requested destination.  Users are strongly
// encouraged to use `ServiceEntry` configurations to explicitly declare any external
// dependencies, instead of using `ALLOW_ANY`, so that traffic to these
// services can be monitored.
#OutboundTrafficPolicy: {
	#Mode: {
		// Outbound traffic will be restricted to services defined in the
		// service registry as well as those defined through `ServiceEntry` configurations.
		"REGISTRY_ONLY"
		#enumValue: 0
	} | {
		// Outbound traffic to unknown destinations will be allowed, in case
		// there are no services or `ServiceEntry` configurations for the destination port.
		"ALLOW_ANY"
		#enumValue: 1
	}

	#Mode_value: {
		REGISTRY_ONLY: 0
		ALLOW_ANY:     1
	}
	mode?: #Mode @protobuf(1,Mode)

	// Specifies the details of the egress proxy to which unknown
	// traffic should be forwarded to from the sidecar. Valid only if
	// the mode is set to ALLOW_ANY. If not specified when the mode is
	// ALLOW_ANY, the sidecar will send the unknown traffic directly to
	// the IP requested by the application.
	//
	// ** NOTE 1**: The specified egress host must be imported in the
	// egress section for the traffic forwarding to work.
	//
	// ** NOTE 2**: An Envoy based egress gateway is unlikely to be able
	// to handle plain text TCP connections forwarded from the sidecar.
	// Envoy's dynamic forward proxy can handle only HTTP and TLS
	// connections.
	// $hide_from_docs
	egressProxy?: #Destination @protobuf(2,Destination,name=egress_proxy)
}

// `CaptureMode` describes how traffic to a listener is expected to be
// captured. Applicable only when the listener is bound to an IP.
#CaptureMode: {
	// The default capture mode defined by the environment.
	"DEFAULT"
	#enumValue: 0
} | {
	// Capture traffic using IPtables redirection.
	"IPTABLES"
	#enumValue: 1
} | {
	// No traffic capture. When used in an egress listener, the application is
	// expected to explicitly communicate with the listener port or Unix
	// domain socket. When used in an ingress listener, care needs to be taken
	// to ensure that the listener port is not in use by other processes on
	// the host.
	"NONE"
	#enumValue: 2
}

#CaptureMode_value: {
	DEFAULT:  0
	IPTABLES: 1
	NONE:     2
}

// Port describes the properties of a specific port of a service.
#SidecarPort: {
	// A valid non-negative integer port number.
	number?: uint32 @protobuf(1,uint32)

	// The protocol exposed on the port.
	// MUST BE one of HTTP|HTTPS|GRPC|HTTP2|MONGO|TCP|TLS.
	// TLS can be either used to terminate non-HTTP based connections on a specific port
	// or to route traffic based on SNI header to the destination without terminating the TLS connection.
	protocol?: string @protobuf(2,string)

	// Label assigned to the port.
	name?: string @protobuf(3,string)

	// Has no effect, only for backwards compatibility
	// received. Applicable only when used with ServiceEntries.
	// $hide_from_docs
	targetPort?: uint32 @protobuf(4,uint32,name=target_port,deprecated)
}
