// $schema: istio.networking.v1alpha3.DestinationRule
// $title: Destination Rule
// $description: Configuration affecting load balancing, outlier detection, etc.
// $location: https://istio.io/docs/reference/config/networking/destination-rule.html
// $aliases: [/docs/reference/config/networking/v1alpha3/destination-rule]

// `DestinationRule` defines policies that apply to traffic intended for a
// service after routing has occurred. These rules specify configuration
// for load balancing, connection pool size from the sidecar, and outlier
// detection settings to detect and evict unhealthy hosts from the load
// balancing pool. For example, a simple load balancing policy for the
// ratings service would look as follows:
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: bookinfo-ratings
// spec:
//   host: ratings.prod.svc.cluster.local
//   trafficPolicy:
//     loadBalancer:
//       simple: LEAST_REQUEST
// ```
//
// Version specific policies can be specified by defining a named
// `subset` and overriding the settings specified at the service level. The
// following rule uses a round robin load balancing policy for all traffic
// going to a subset named testversion that is composed of endpoints (e.g.,
// pods) with labels (version:v3).
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: bookinfo-ratings
// spec:
//   host: ratings.prod.svc.cluster.local
//   trafficPolicy:
//     loadBalancer:
//       simple: LEAST_REQUEST
//   subsets:
//   - name: testversion
//     labels:
//       version: v3
//     trafficPolicy:
//       loadBalancer:
//         simple: ROUND_ROBIN
// ```
//
// **Note:** Policies specified for subsets will not take effect until
// a route rule explicitly sends traffic to this subset.
//
// Traffic policies can be customized to specific ports as well. The
// following rule uses the least connection load balancing policy for all
// traffic to port 80, while uses a round robin load balancing setting for
// traffic to the port 9080.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: bookinfo-ratings-port
// spec:
//   host: ratings.prod.svc.cluster.local
//   trafficPolicy: # Apply to all ports
//     portLevelSettings:
//     - port:
//         number: 80
//       loadBalancer:
//         simple: LEAST_REQUEST
//     - port:
//         number: 9080
//       loadBalancer:
//         simple: ROUND_ROBIN
// ```
//
// Destination Rules can be customized to specific workloads as well.
// The following example shows how a destination rule can be applied to a
// specific workload using the workloadSelector configuration.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: configure-client-mtls-dr-with-workloadselector
// spec:
//   host: example.com
//   workloadSelector:
//     matchLabels:
//       app: ratings
//   trafficPolicy:
//     loadBalancer:
//       simple: ROUND_ROBIN
//     portLevelSettings:
//     - port:
//         number: 31443
//       tls:
//         credentialName: client-credential
//         mode: MUTUAL
// ```
package v1alpha3

import (
	"istio.io/api/type/v1beta1"
	"time"
	time_1 "time"
)

// DestinationRule defines policies that apply to traffic intended for a service
// after routing has occurred.
//
// <!-- crd generation tags
// +cue-gen:DestinationRule:groupName:networking.istio.io
// +cue-gen:DestinationRule:versions:v1beta1,v1alpha3,v1
// +cue-gen:DestinationRule:annotations:helm.sh/resource-policy=keep
// +cue-gen:DestinationRule:labels:app=istio-pilot,chart=istio,heritage=Tiller,release=istio
// +cue-gen:DestinationRule:subresource:status
// +cue-gen:DestinationRule:scope:Namespaced
// +cue-gen:DestinationRule:resource:categories=istio-io,networking-istio-io,shortNames=dr
// +cue-gen:DestinationRule:printerColumn:name=Host,type=string,JSONPath=.spec.host,description="The name of a service from the service registry"
// +cue-gen:DestinationRule:printerColumn:name=Age,type=date,JSONPath=.metadata.creationTimestamp,description="CreationTimestamp is a timestamp
// representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations.
// Clients may not set this value. It is represented in RFC3339 form and is in UTC.
// Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata"
// +cue-gen:DestinationRule:preserveUnknownFields:false
// -->
//
// <!-- go code generation tags
// +kubetype-gen
// +kubetype-gen:groupVersion=networking.istio.io/v1alpha3
// +genclient
// +k8s:deepcopy-gen=true
// -->
#DestinationRule: {
	// The name of a service from the service registry. Service
	// names are looked up from the platform's service registry (e.g.,
	// Kubernetes services, Consul services, etc.) and from the hosts
	// declared by [ServiceEntries](https://istio.io/docs/reference/config/networking/service-entry/#ServiceEntry). Rules defined for
	// services that do not exist in the service registry will be ignored.
	//
	// *Note for Kubernetes users*: When short names are used (e.g. "reviews"
	// instead of "reviews.default.svc.cluster.local"), Istio will interpret
	// the short name based on the namespace of the rule, not the service. A
	// rule in the "default" namespace containing a host "reviews" will be
	// interpreted as "reviews.default.svc.cluster.local", irrespective of
	// the actual namespace associated with the reviews service. _To avoid
	// potential misconfigurations, it is recommended to always use fully
	// qualified domain names over short names._
	//
	// Note that the host field applies to both HTTP and TCP services.
	host: string @protobuf(1,string)

	// Traffic policies to apply (load balancing policy, connection pool
	// sizes, outlier detection).
	trafficPolicy?: #TrafficPolicy @protobuf(2,TrafficPolicy,name=traffic_policy)

	// One or more named sets that represent individual versions of a
	// service. Traffic policies can be overridden at subset level.
	subsets?: [...#Subset] @protobuf(3,Subset)

	// A list of namespaces to which this destination rule is exported.
	// The resolution of a destination rule to apply to a service occurs in the
	// context of a hierarchy of namespaces. Exporting a destination rule allows
	// it to be included in the resolution hierarchy for services in
	// other namespaces. This feature provides a mechanism for service owners
	// and mesh administrators to control the visibility of destination rules
	// across namespace boundaries.
	//
	// If no namespaces are specified then the destination rule is exported to all
	// namespaces by default.
	//
	// The value "." is reserved and defines an export to the same namespace that
	// the destination rule is declared in. Similarly, the value "*" is reserved and
	// defines an export to all namespaces.
	exportTo?: [...string] @protobuf(4,string,name=export_to)

	//
	// Criteria used to select the specific set of pods/VMs on which this
	// `DestinationRule` configuration should be applied. If specified, the `DestinationRule`
	// configuration will be applied only to the workload instances matching the workload selector
	// label in the same namespace. Workload selectors do not apply across namespace boundaries.
	// If omitted, the `DestinationRule` falls back to its default behavior.
	// For example, if specific sidecars need to have egress TLS settings for services outside
	// of the mesh, instead of every sidecar in the mesh needing to have the
	// configuration (which is the default behaviour), a workload selector can be specified.
	workloadSelector?: v1beta1.#WorkloadSelector @protobuf(5,istio.type.v1beta1.WorkloadSelector,name=workload_selector)
}

// Traffic policies to apply for a specific destination, across all
// destination ports. See DestinationRule for examples.
#TrafficPolicy: {
	// Settings controlling the load balancer algorithms.
	loadBalancer?: #LoadBalancerSettings @protobuf(1,LoadBalancerSettings,name=load_balancer)

	// Settings controlling the volume of connections to an upstream service
	connectionPool?: #ConnectionPoolSettings @protobuf(2,ConnectionPoolSettings,name=connection_pool)

	// Settings controlling eviction of unhealthy hosts from the load balancing pool
	outlierDetection?: #OutlierDetection @protobuf(3,OutlierDetection,name=outlier_detection)

	// TLS related settings for connections to the upstream service.
	tls?: #ClientTLSSettings @protobuf(4,ClientTLSSettings)

	// Traffic policies that apply to specific ports of the service
	#PortTrafficPolicy: {
		// Specifies the number of a port on the destination service
		// on which this policy is being applied.
		//
		port?: #PortSelector @protobuf(1,PortSelector)

		// Settings controlling the load balancer algorithms.
		loadBalancer?: #LoadBalancerSettings @protobuf(2,LoadBalancerSettings,name=load_balancer)

		// Settings controlling the volume of connections to an upstream service
		connectionPool?: #ConnectionPoolSettings @protobuf(3,ConnectionPoolSettings,name=connection_pool)

		// Settings controlling eviction of unhealthy hosts from the load balancing pool
		outlierDetection?: #OutlierDetection @protobuf(4,OutlierDetection,name=outlier_detection)

		// TLS related settings for connections to the upstream service.
		tls?: #ClientTLSSettings @protobuf(5,ClientTLSSettings)
	}

	// Traffic policies specific to individual ports. Note that port level
	// settings will override the destination-level settings. Traffic
	// settings specified at the destination-level will not be inherited when
	// overridden by port-level settings, i.e. default values will be applied
	// to fields omitted in port-level traffic policies.
	// +kubebuilder:validation:MaxItems=4096
	portLevelSettings?: [...#PortTrafficPolicy] @protobuf(5,PortTrafficPolicy,name=port_level_settings)

	#TunnelSettings: {
		// Specifies which protocol to use for tunneling the downstream connection.
		// Supported protocols are:
		//   CONNECT - uses HTTP CONNECT;
		//   POST - uses HTTP POST.
		// CONNECT is used by default if not specified.
		// HTTP version for upstream requests is determined by the service protocol defined for the proxy.
		protocol?: string @protobuf(1,string)

		// Specifies a host to which the downstream connection is tunneled.
		// Target host must be an FQDN or IP address.
		targetHost: string @protobuf(2,string,name=target_host)

		// Specifies a port to which the downstream connection is tunneled.
		targetPort: uint32 @protobuf(3,uint32,name=target_port)
	}

	// Configuration of tunneling TCP over other transport or application layers
	// for the host configured in the DestinationRule.
	// Tunnel settings can be applied to TCP or TLS routes and can't be applied to HTTP routes.
	tunnel?: #TunnelSettings @protobuf(6,TunnelSettings)

	#ProxyProtocol: {
		#VERSION: {
			// ⁣PROXY protocol version 1. Human readable format.
			"V1"
			#enumValue: 0
		} | {
			// ⁣PROXY protocol version 2. Binary format.
			"V2"
			#enumValue: 1
		}

		#VERSION_value: {
			V1: 0
			V2: 1
		}

		// The PROXY protocol version to use. See https://www.haproxy.org/download/2.1/doc/proxy-protocol.txt for details.
		// By default it is `V1`.
		version?: #VERSION @protobuf(1,VERSION)
	}

	// The upstream PROXY protocol settings.
	proxyProtocol?: #ProxyProtocol @protobuf(7,ProxyProtocol,name=proxy_protocol)
}

// A subset of endpoints of a service. Subsets can be used for scenarios
// like A/B testing, or routing to a specific version of a service. Refer
// to [VirtualService](https://istio.io/docs/reference/config/networking/virtual-service/#VirtualService) documentation for examples of using
// subsets in these scenarios. In addition, traffic policies defined at the
// service-level can be overridden at a subset-level. The following rule
// uses a round robin load balancing policy for all traffic going to a
// subset named testversion that is composed of endpoints (e.g., pods) with
// labels (version:v3).
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: bookinfo-ratings
// spec:
//   host: ratings.prod.svc.cluster.local
//   trafficPolicy:
//     loadBalancer:
//       simple: LEAST_REQUEST
//   subsets:
//   - name: testversion
//     labels:
//       version: v3
//     trafficPolicy:
//       loadBalancer:
//         simple: ROUND_ROBIN
// ```
//
// **Note:** Policies specified for subsets will not take effect until
// a route rule explicitly sends traffic to this subset.
//
// One or more labels are typically required to identify the subset destination,
// however, when the corresponding DestinationRule represents a host that
// supports multiple SNI hosts (e.g., an egress gateway), a subset without labels
// may be meaningful. In this case a traffic policy with [ClientTLSSettings](#ClientTLSSettings)
// can be used to identify a specific SNI host corresponding to the named subset.
#Subset: {
	// Name of the subset. The service name and the subset name can
	// be used for traffic splitting in a route rule.
	name: string @protobuf(1,string)

	// Labels apply a filter over the endpoints of a service in the
	// service registry. See route rules for examples of usage.
	labels?: {
		[string]: string
	} @protobuf(2,map[string]string)

	// Traffic policies that apply to this subset. Subsets inherit the
	// traffic policies specified at the DestinationRule level. Settings
	// specified at the subset level will override the corresponding settings
	// specified at the DestinationRule level.
	trafficPolicy?: #TrafficPolicy @protobuf(3,TrafficPolicy,name=traffic_policy)
}

// Load balancing policies to apply for a specific destination. See Envoy's
// load balancing
// [documentation](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/load_balancing/load_balancing)
// for more details.
//
// For example, the following rule uses a round robin load balancing policy
// for all traffic going to the ratings service.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: bookinfo-ratings
// spec:
//   host: ratings.prod.svc.cluster.local
//   trafficPolicy:
//     loadBalancer:
//       simple: ROUND_ROBIN
// ```
//
// The following example sets up sticky sessions for the ratings service
// hashing-based load balancer for the same ratings service using the
// the User cookie as the hash key.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: bookinfo-ratings
// spec:
//   host: ratings.prod.svc.cluster.local
//   trafficPolicy:
//     loadBalancer:
//       consistentHash:
//         httpCookie:
//           name: user
//           ttl: 0s
// ```
//
#LoadBalancerSettings: {
	// Standard load balancing algorithms that require no tuning.
	#SimpleLB: {
		// No load balancing algorithm has been specified by the user. Istio
		// will select an appropriate default.
		"UNSPECIFIED"
		#enumValue: 0
	} | {
		// Deprecated. Use LEAST_REQUEST instead.
		"LEAST_CONN"
		#enumValue: 1
	} | {
		// The random load balancer selects a random healthy host. The random
		// load balancer generally performs better than round robin if no health
		// checking policy is configured.
		"RANDOM"
		#enumValue: 2
	} | {
		// This option will forward the connection to the original IP address
		// requested by the caller without doing any form of load
		// balancing. This option must be used with care. It is meant for
		// advanced use cases. Refer to Original Destination load balancer in
		// Envoy for further details.
		"PASSTHROUGH"
		#enumValue: 3
	} | {
		// A basic round robin load balancing policy. This is generally unsafe
		// for many scenarios (e.g. when endpoint weighting is used) as it can
		// overburden endpoints. In general, prefer to use LEAST_REQUEST as a
		// drop-in replacement for ROUND_ROBIN.
		"ROUND_ROBIN"
		#enumValue: 4
	} | {
		// The least request load balancer spreads load across endpoints, favoring
		// endpoints with the least outstanding requests. This is generally safer
		// and outperforms ROUND_ROBIN in nearly all cases. Prefer to use
		// LEAST_REQUEST as a drop-in replacement for ROUND_ROBIN.
		"LEAST_REQUEST"
		#enumValue: 5
	}

	#SimpleLB_value: {
		UNSPECIFIED:   0
		LEAST_CONN:    1
		RANDOM:        2
		PASSTHROUGH:   3
		ROUND_ROBIN:   4
		LEAST_REQUEST: 5
	}

	// Consistent Hash-based load balancing can be used to provide soft
	// session affinity based on HTTP headers, cookies or other
	// properties. The affinity to a particular destination host may be
	// lost when one or more hosts are added/removed from the destination
	// service.
	//
	// Note: consistent hashing is less reliable at maintaining affinity than common
	// "sticky sessions" implementations, which often encode a specific destination in
	// a cookie, ensuring affinity is maintained as long as the backend remains.
	// With consistent hash, the guarantees are weaker; any host addition or removal can
	// break affinity for `1/backends` requests.
	//
	// Warning: consistent hashing depends on each proxy having a consistent view of endpoints.
	// This is not the case when locality load balancing is enabled. Locality load balancing
	// and consistent hash will only work together when all proxies are in the same locality,
	// or a high level load balancer handles locality affinity.
	#ConsistentHashLB: {

		#RingHash: {
			// The minimum number of virtual nodes to use for the hash
			// ring. Defaults to 1024. Larger ring sizes result in more granular
			// load distributions. If the number of hosts in the load balancing
			// pool is larger than the ring size, each host will be assigned a
			// single virtual node.
			minimumRingSize?: uint64 @protobuf(1,uint64,name=minimum_ring_size)
		}

		#MagLev: {
			// The table size for Maglev hashing. This helps in controlling the
			// disruption when the backend hosts change.
			// Increasing the table size reduces the amount of disruption.
			// The table size must be prime number less than 5000011.
			// If it is not specified, the default is 65537.
			tableSize?: uint64 @protobuf(1,uint64,name=table_size)
		}

		// Describes a HTTP cookie that will be used as the hash key for the
		// Consistent Hash load balancer.
		#HTTPCookie: {
			// Name of the cookie.
			name: string @protobuf(1,string)

			// Path to set for the cookie.
			path?: string @protobuf(2,string)

			// Lifetime of the cookie. If specified, a cookie with the TTL will be
			// generated if the cookie is not present. If the TTL is present and zero,
			// the generated cookie will be a session cookie.
			// +kubebuilder:duration-validation:none
			ttl?: time.Duration @protobuf(3,google.protobuf.Duration)
		}

		// The hash key to use.
		{} | {
			// Hash based on a specific HTTP header.
			httpHeaderName: string @protobuf(1,string,name=http_header_name)
		} | {
			// Hash based on HTTP cookie.
			httpCookie: #HTTPCookie @protobuf(2,HTTPCookie,name=http_cookie)
		} | {
			// Hash based on the source IP address.
			// This is applicable for both TCP and HTTP connections.
			useSourceIp: bool @protobuf(3,bool,name=use_source_ip)
		} | {
			// Hash based on a specific HTTP query parameter.
			httpQueryParameterName: string @protobuf(5,string,name=http_query_parameter_name)
		}

		// The hash algorithm to use.
		// Please refer to https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/load_balancing/load_balancers#ring-hash
		// and https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/load_balancing/load_balancers#maglev for
		// considerations on choosing an algorithm.
		// Defaults to RingHash if not specified.
		{} | {
			// The ring/modulo hash load balancer implements consistent hashing to backend hosts.
			ringHash: #RingHash @protobuf(6,RingHash,name=ring_hash)
		} | {
			// The Maglev load balancer implements consistent hashing to backend hosts.
			maglev: #MagLev @protobuf(7,MagLev)
		}

		// Deprecated. Use RingHash instead.
		minimumRingSize?: uint64 @protobuf(4,uint64,name=minimum_ring_size,deprecated)
	}
	// (-- TODO: Enable Subset load balancing after moving to v2 API Also
	// look into enabling Priotity based load balancing for spilling over
	// from one priority pool to another. --)

	// Upstream load balancing policy.
	{} | {
		simple: #SimpleLB @protobuf(1,SimpleLB)
	} | {
		consistentHash: #ConsistentHashLB @protobuf(2,ConsistentHashLB,name=consistent_hash)
	}

	// Locality load balancer settings, this will override mesh wide settings in entirety, meaning no merging would be performed
	// between this object and the object one in MeshConfig
	localityLbSetting?: #LocalityLoadBalancerSetting @protobuf(3,LocalityLoadBalancerSetting,name=locality_lb_setting)

	// Represents the warmup duration of Service. If set, the newly created endpoint of service
	// remains in warmup mode starting from its creation time for the duration of this window and
	// Istio progressively increases amount of traffic for that endpoint instead of sending proportional amount of traffic.
	// This should be enabled for services that require warm up time to serve full production load with reasonable latency.
	// Please note that this is most effective when few new endpoints come up like scale event in Kubernetes. When all the
	// endpoints are relatively new like new deployment, this is not very effective as all endpoints end up getting same
	// amount of requests.
	// Currently this is only supported for ROUND_ROBIN and LEAST_REQUEST load balancers.
	warmupDurationSecs?: time.Duration @protobuf(4,google.protobuf.Duration,name=warmup_duration_secs)
}

// Connection pool settings for an upstream host. The settings apply to
// each individual host in the upstream service.  See Envoy's [circuit
// breaker](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/circuit_breaking)
// for more details. Connection pool settings can be applied at the TCP
// level as well as at HTTP level.
//
// For example, the following rule sets a limit of 100 connections to redis
// service called myredissrv with a connect timeout of 30ms
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: bookinfo-redis
// spec:
//   host: myredissrv.prod.svc.cluster.local
//   trafficPolicy:
//     connectionPool:
//       tcp:
//         maxConnections: 100
//         connectTimeout: 30ms
//         tcpKeepalive:
//           time: 7200s
//           interval: 75s
// ```
//
#ConnectionPoolSettings: {
	// Settings common to both HTTP and TCP upstream connections.
	#TCPSettings: {
		// TCP keepalive.
		#TcpKeepalive: {
			// Maximum number of keepalive probes to send without response before
			// deciding the connection is dead. Default is to use the OS level configuration
			// (unless overridden, Linux defaults to 9.)
			probes?: uint32 @protobuf(1,uint32)

			// The time duration a connection needs to be idle before keep-alive
			// probes start being sent. Default is to use the OS level configuration
			// (unless overridden, Linux defaults to 7200s (ie 2 hours.)
			time?: time_1.Duration @protobuf(2,google.protobuf.Duration)

			// The time duration between keep-alive probes.
			// Default is to use the OS level configuration
			// (unless overridden, Linux defaults to 75s.)
			interval?: time_1.Duration @protobuf(3,google.protobuf.Duration)
		}

		// Maximum number of HTTP1 /TCP connections to a destination host. Default 2^32-1.
		maxConnections?: int32 @protobuf(1,int32,name=max_connections)

		// TCP connection timeout. format:
		// 1h/1m/1s/1ms. MUST BE >=1ms. Default is 10s.
		connectTimeout?: time.Duration @protobuf(2,google.protobuf.Duration,name=connect_timeout)

		// If set then set SO_KEEPALIVE on the socket to enable TCP Keepalives.
		tcpKeepalive?: #TcpKeepalive @protobuf(3,TcpKeepalive,name=tcp_keepalive)

		// The maximum duration of a connection. The duration is defined as the period since a connection
		// was established. If not set, there is no max duration. When max_connection_duration
		// is reached the connection will be closed. Duration must be at least 1ms.
		maxConnectionDuration?: time.Duration @protobuf(4,google.protobuf.Duration,name=max_connection_duration)

		// The idle timeout for TCP connections.
		// The idle timeout is defined as the period in which there are no bytes sent or received on either
		// the upstream or downstream connection.
		// If not set, the default idle timeout is 1 hour. If set to 0s, the timeout will be disabled.
		// Idle timeout is not configured per each cluster individually when weighted destinations are used,
		// because idleTimeout is a property of a listener, not a cluster. In that case, idleTimeout
		// specified in a destination rule for the first weighted route is configured in the listener,
		// which means also for all weighted routes.
		idleTimeout?: time.Duration @protobuf(5,google.protobuf.Duration,name=idle_timeout)
	}

	// Settings applicable to HTTP1.1/HTTP2/GRPC connections.
	#HTTPSettings: {
		// Maximum number of requests that will be queued while waiting for
		// a ready connection pool connection. Default 2^32-1.
		// Refer to https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/circuit_breaking
		// under which conditions a new connection is created for HTTP2.
		// Please note that this is applicable to both HTTP/1.1 and HTTP2.
		http1MaxPendingRequests?: int32 @protobuf(1,int32,name=http1_max_pending_requests)

		// Maximum number of active requests to a destination. Default 2^32-1.
		// Please note that this is applicable to both HTTP/1.1 and HTTP2.
		http2MaxRequests?: int32 @protobuf(2,int32,name=http2_max_requests)

		// Maximum number of requests per connection to a backend. Setting this
		// parameter to 1 disables keep alive. Default 0, meaning "unlimited",
		// up to 2^29.
		maxRequestsPerConnection?: int32 @protobuf(3,int32,name=max_requests_per_connection)

		// Maximum number of retries that can be outstanding to all hosts in a
		// cluster at a given time. Defaults to 2^32-1.
		maxRetries?: int32 @protobuf(4,int32,name=max_retries)

		// The idle timeout for upstream connection pool connections. The idle timeout
		// is defined as the period in which there are no active requests.
		// If not set, the default is 1 hour. When the idle timeout is reached,
		// the connection will be closed. If the connection is an HTTP/2
		// connection a drain sequence will occur prior to closing the connection.
		// Note that request based timeouts mean that HTTP/2 PINGs will not
		// keep the connection alive. Applies to both HTTP1.1 and HTTP2 connections.
		idleTimeout?: time.Duration @protobuf(5,google.protobuf.Duration,name=idle_timeout)

		// Policy for upgrading http1.1 connections to http2.
		#H2UpgradePolicy: {
			// Use the global default.
			"DEFAULT"
			#enumValue: 0
		} | {
			// Do not upgrade the connection to http2.
			// This opt-out option overrides the default.
			"DO_NOT_UPGRADE"
			#enumValue: 1
		} | {
			// Upgrade the connection to http2.
			// This opt-in option overrides the default.
			"UPGRADE"
			#enumValue: 2
		}

		#H2UpgradePolicy_value: {
			DEFAULT:        0
			DO_NOT_UPGRADE: 1
			UPGRADE:        2
		}

		// Specify if http1.1 connection should be upgraded to http2 for the associated destination.
		h2UpgradePolicy?: #H2UpgradePolicy @protobuf(6,H2UpgradePolicy,name=h2_upgrade_policy)

		// If set to true, client protocol will be preserved while initiating connection to backend.
		// Note that when this is set to true, h2_upgrade_policy will be ineffective i.e. the client
		// connections will not be upgraded to http2.
		useClientProtocol?: bool @protobuf(7,bool,name=use_client_protocol)

		// The maximum number of concurrent streams allowed for a peer on one HTTP/2 connection.
		// Defaults to 2^31-1.
		maxConcurrentStreams?: int32 @protobuf(8,int32,name=max_concurrent_streams)
	}

	// Settings common to both HTTP and TCP upstream connections.
	tcp?: #TCPSettings @protobuf(1,TCPSettings)

	// HTTP connection pool settings.
	http?: #HTTPSettings @protobuf(2,HTTPSettings)
}

// A Circuit breaker implementation that tracks the status of each
// individual host in the upstream service.  Applicable to both HTTP and
// TCP services.  For HTTP services, hosts that continually return 5xx
// errors for API calls are ejected from the pool for a pre-defined period
// of time. For TCP services, connection timeouts or connection
// failures to a given host counts as an error when measuring the
// consecutive errors metric. See Envoy's [outlier
// detection](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/outlier)
// for more details.
//
// The following rule sets a connection pool size of 100 HTTP1 connections
// with no more than 10 req/connection to the "reviews" service. In addition,
// it sets a limit of 1000 concurrent HTTP2 requests and configures upstream
// hosts to be scanned every 5 mins so that any host that fails 7 consecutive
// times with a 502, 503, or 504 error code will be ejected for 15 minutes.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: reviews-cb-policy
// spec:
//   host: reviews.prod.svc.cluster.local
//   trafficPolicy:
//     connectionPool:
//       tcp:
//         maxConnections: 100
//       http:
//         http2MaxRequests: 1000
//         maxRequestsPerConnection: 10
//     outlierDetection:
//       consecutive5xxErrors: 7
//       interval: 5m
//       baseEjectionTime: 15m
// ```
//
#OutlierDetection: {
	// Number of errors before a host is ejected from the connection
	// pool. Defaults to 5. When the upstream host is accessed over HTTP, a
	// 502, 503, or 504 return code qualifies as an error. When the upstream host
	// is accessed over an opaque TCP connection, connect timeouts and
	// connection error/failure events qualify as an error.
	// $hide_from_docs
	consecutiveErrors?: int32 @protobuf(1,int32,name=consecutive_errors,deprecated)

	// Determines whether to distinguish local origin failures from external errors. If set to true
	// consecutive_local_origin_failure is taken into account for outlier detection calculations.
	// This should be used when you want to derive the outlier detection status based on the errors
	// seen locally such as failure to connect, timeout while connecting etc. rather than the status code
	// returned by upstream service. This is especially useful when the upstream service explicitly returns
	// a 5xx for some requests and you want to ignore those responses from upstream service while determining
	// the outlier detection status of a host.
	// Defaults to false.
	splitExternalLocalOriginErrors?: bool @protobuf(8,bool,name=split_external_local_origin_errors)

	// The number of consecutive locally originated failures before ejection
	// occurs. Defaults to 5. Parameter takes effect only when split_external_local_origin_errors
	// is set to true.
	consecutiveLocalOriginFailures?: null | uint32 @protobuf(9,google.protobuf.UInt32Value,name=consecutive_local_origin_failures)

	// Number of gateway errors before a host is ejected from the connection pool.
	// When the upstream host is accessed over HTTP, a 502, 503, or 504 return
	// code qualifies as a gateway error. When the upstream host is accessed over
	// an opaque TCP connection, connect timeouts and connection error/failure
	// events qualify as a gateway error.
	// This feature is disabled by default or when set to the value 0.
	//
	// Note that consecutive_gateway_errors and consecutive_5xx_errors can be
	// used separately or together. Because the errors counted by
	// consecutive_gateway_errors are also included in consecutive_5xx_errors,
	// if the value of consecutive_gateway_errors is greater than or equal to
	// the value of consecutive_5xx_errors, consecutive_gateway_errors will have
	// no effect.
	consecutiveGatewayErrors?: null | uint32 @protobuf(6,google.protobuf.UInt32Value,name=consecutive_gateway_errors)

	// Number of 5xx errors before a host is ejected from the connection pool.
	// When the upstream host is accessed over an opaque TCP connection, connect
	// timeouts, connection error/failure and request failure events qualify as a
	// 5xx error.
	// This feature defaults to 5 but can be disabled by setting the value to 0.
	//
	// Note that consecutive_gateway_errors and consecutive_5xx_errors can be
	// used separately or together. Because the errors counted by
	// consecutive_gateway_errors are also included in consecutive_5xx_errors,
	// if the value of consecutive_gateway_errors is greater than or equal to
	// the value of consecutive_5xx_errors, consecutive_gateway_errors will have
	// no effect.
	consecutive5xxErrors?: null | uint32 @protobuf(7,google.protobuf.UInt32Value,name=consecutive_5xx_errors)

	// Time interval between ejection sweep analysis. format:
	// 1h/1m/1s/1ms. MUST BE >=1ms. Default is 10s.
	interval?: time.Duration @protobuf(2,google.protobuf.Duration)

	// Minimum ejection duration. A host will remain ejected for a period
	// equal to the product of minimum ejection duration and the number of
	// times the host has been ejected. This technique allows the system to
	// automatically increase the ejection period for unhealthy upstream
	// servers. format: 1h/1m/1s/1ms. MUST BE >=1ms. Default is 30s.
	baseEjectionTime?: time.Duration @protobuf(3,google.protobuf.Duration,name=base_ejection_time)

	// Maximum % of hosts in the load balancing pool for the upstream
	// service that can be ejected. Defaults to 10%.
	maxEjectionPercent?: int32 @protobuf(4,int32,name=max_ejection_percent)

	// Outlier detection will be enabled as long as the associated load balancing
	// pool has at least min_health_percent hosts in healthy mode. When the
	// percentage of healthy hosts in the load balancing pool drops below this
	// threshold, outlier detection will be disabled and the proxy will load balance
	// across all hosts in the pool (healthy and unhealthy). The threshold can be
	// disabled by setting it to 0%. The default is 0% as it's not typically
	// applicable in k8s environments with few pods per service.
	minHealthPercent?: int32 @protobuf(5,int32,name=min_health_percent)
}

// SSL/TLS related settings for upstream connections. See Envoy's [TLS
// context](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/transport_sockets/tls/v3/common.proto.html#common-tls-configuration)
// for more details. These settings are common to both HTTP and TCP upstreams.
//
// For example, the following rule configures a client to use mutual TLS
// for connections to upstream database cluster.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: db-mtls
// spec:
//   host: mydbserver.prod.svc.cluster.local
//   trafficPolicy:
//     tls:
//       mode: MUTUAL
//       clientCertificate: /etc/certs/myclientcert.pem
//       privateKey: /etc/certs/client_private_key.pem
//       caCertificates: /etc/certs/rootcacerts.pem
// ```
//
// The following rule configures a client to use TLS when talking to a
// foreign service whose domain matches *.foo.com.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: tls-foo
// spec:
//   host: "*.foo.com"
//   trafficPolicy:
//     tls:
//       mode: SIMPLE
// ```
//
// The following rule configures a client to use Istio mutual TLS when talking
// to rating services.
//
// ```yaml
// apiVersion: networking.istio.io/v1
// kind: DestinationRule
// metadata:
//   name: ratings-istio-mtls
// spec:
//   host: ratings.prod.svc.cluster.local
//   trafficPolicy:
//     tls:
//       mode: ISTIO_MUTUAL
// ```
//
#ClientTLSSettings: {
	// TLS connection mode
	#TLSmode: {
		// Do not setup a TLS connection to the upstream endpoint.
		"DISABLE"
		#enumValue: 0
	} | {
		// Originate a TLS connection to the upstream endpoint.
		"SIMPLE"
		#enumValue: 1
	} | {
		// Secure connections to the upstream using mutual TLS by presenting
		// client certificates for authentication.
		"MUTUAL"
		#enumValue: 2
	} | {
		// Secure connections to the upstream using mutual TLS by presenting
		// client certificates for authentication.
		// Compared to Mutual mode, this mode uses certificates generated
		// automatically by Istio for mTLS authentication. When this mode is
		// used, all other fields in `ClientTLSSettings` should be empty.
		"ISTIO_MUTUAL"
		#enumValue: 3
	}

	#TLSmode_value: {
		DISABLE:      0
		SIMPLE:       1
		MUTUAL:       2
		ISTIO_MUTUAL: 3
	}

	// Indicates whether connections to this port should be secured
	// using TLS. The value of this field determines how TLS is enforced.
	mode?: #TLSmode @protobuf(1,TLSmode)

	// REQUIRED if mode is `MUTUAL`. The path to the file holding the
	// client-side TLS certificate to use.
	// Should be empty if mode is `ISTIO_MUTUAL`.
	clientCertificate?: string @protobuf(2,string,name=client_certificate)

	// REQUIRED if mode is `MUTUAL`. The path to the file holding the
	// client's private key.
	// Should be empty if mode is `ISTIO_MUTUAL`.
	privateKey?: string @protobuf(3,string,name=private_key)

	// OPTIONAL: The path to the file containing certificate authority
	// certificates to use in verifying a presented server certificate. If
	// omitted, the proxy will verify the server's certificate using
	// the OS CA certificates.
	// Should be empty if mode is `ISTIO_MUTUAL`.
	caCertificates?: string @protobuf(4,string,name=ca_certificates)

	// The name of the secret that holds the TLS certs for the
	// client including the CA certificates. This secret must exist in
	// the namespace of the proxy using the certificates.
	// An Opaque secret should contain the following keys and values:
	// `key: <privateKey>`, `cert: <clientCert>`, `cacert: <CACertificate>`,
	// `crl: <certificateRevocationList>`
	// Here CACertificate is used to verify the server certificate.
	// For mutual TLS, `cacert: <CACertificate>` can be provided in the
	// same secret or a separate secret named `<secret>-cacert`.
	// A TLS secret for client certificates with an additional
	// `ca.crt` key for CA certificates and `ca.crl` key for
	// certificate revocation list(CRL) is also supported.
	// Only one of client certificates and CA certificate
	// or credentialName can be specified.
	//
	// **NOTE:** This field is applicable at sidecars only if
	// `DestinationRule` has a `workloadSelector` specified.
	// Otherwise the field will be applicable only at gateways, and
	// sidecars will continue to use the certificate paths.
	credentialName?: string @protobuf(7,string,name=credential_name)

	// A list of alternate names to verify the subject identity in the
	// certificate. If specified, the proxy will verify that the server
	// certificate's subject alt name matches one of the specified values.
	// If specified, this list overrides the value of subject_alt_names
	// from the ServiceEntry. If unspecified, automatic validation of upstream
	// presented certificate for new upstream connections will be done based on the
	// downstream HTTP host/authority header.
	subjectAltNames?: [...string] @protobuf(5,string,name=subject_alt_names)

	// SNI string to present to the server during TLS handshake.
	// If unspecified, SNI will be automatically set based on downstream HTTP
	// host/authority header for SIMPLE and MUTUAL TLS modes.
	sni?: string @protobuf(6,string)

	// `insecureSkipVerify` specifies whether the proxy should skip verifying the
	// CA signature and SAN for the server certificate corresponding to the host.
	// The default value of this field is false.
	insecureSkipVerify?: null | bool @protobuf(8,google.protobuf.BoolValue,name=insecure_skip_verify)

	// OPTIONAL: The path to the file containing the certificate revocation list (CRL)
	// to use in verifying a presented server certificate. `CRL` is a list of certificates
	// that have been revoked by the CA (Certificate Authority) before their scheduled expiration date.
	// If specified, the proxy will verify if the presented certificate is part of the revoked list of certificates.
	// If omitted, the proxy will not verify the certificate against the `crl`.
	caCrl?: string @protobuf(9,string,name=ca_crl)
}

// Locality-weighted load balancing allows administrators to control the
// distribution of traffic to endpoints based on the localities of where the
// traffic originates and where it will terminate. These localities are
// specified using arbitrary labels that designate a hierarchy of localities in
// {region}/{zone}/{sub-zone} form. For additional detail refer to
// [Locality Weight](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/load_balancing/locality_weight)
// The following example shows how to setup locality weights mesh-wide.
//
// Given a mesh with workloads and their service deployed to "us-west/zone1/*"
// and "us-west/zone2/*". This example specifies that when traffic accessing a
// service originates from workloads in "us-west/zone1/*", 80% of the traffic
// will be sent to endpoints in "us-west/zone1/*", i.e the same zone, and the
// remaining 20% will go to endpoints in "us-west/zone2/*". This setup is
// intended to favor routing traffic to endpoints in the same locality.
// A similar setting is specified for traffic originating in "us-west/zone2/*".
//
// ```yaml
//   distribute:
//     - from: us-west/zone1/*
//       to:
//         "us-west/zone1/*": 80
//         "us-west/zone2/*": 20
//     - from: us-west/zone2/*
//       to:
//         "us-west/zone1/*": 20
//         "us-west/zone2/*": 80
// ```
//
// If the goal of the operator is not to distribute load across zones and
// regions but rather to restrict the regionality of failover to meet other
// operational requirements an operator can set a 'failover' policy instead of
// a 'distribute' policy.
//
// The following example sets up a locality failover policy for regions.
// Assume a service resides in zones within us-east, us-west & eu-west
// this example specifies that when endpoints within us-east become unhealthy
// traffic should failover to endpoints in any zone or sub-zone within eu-west
// and similarly us-west should failover to us-east.
//
// ```yaml
//  failover:
//    - from: us-east
//      to: eu-west
//    - from: us-west
//      to: us-east
// ```
// Locality load balancing settings.
#LocalityLoadBalancerSetting: {
	// Describes how traffic originating in the 'from' zone or sub-zone is
	// distributed over a set of 'to' zones. Syntax for specifying a zone is
	// {region}/{zone}/{sub-zone} and terminal wildcards are allowed on any
	// segment of the specification. Examples:
	//
	// `*` - matches all localities
	//
	// `us-west/*` - all zones and sub-zones within the us-west region
	//
	// `us-west/zone-1/*` - all sub-zones within us-west/zone-1
	#Distribute: {
		// Originating locality, '/' separated, e.g. 'region/zone/sub_zone'.
		from?: string @protobuf(1,string)

		// Map of upstream localities to traffic distribution weights. The sum of
		// all weights should be 100. Any locality not present will
		// receive no traffic.
		to?: {
			[string]: uint32
		} @protobuf(2,map[string]uint32)
	}

	// Specify the traffic failover policy across regions. Since zone and sub-zone
	// failover is supported by default this only needs to be specified for
	// regions when the operator needs to constrain traffic failover so that
	// the default behavior of failing over to any endpoint globally does not
	// apply. This is useful when failing over traffic across regions would not
	// improve service health or may need to be restricted for other reasons
	// like regulatory controls.
	#Failover: {
		// Originating region.
		from?: string @protobuf(1,string)

		// Destination region the traffic will fail over to when endpoints in
		// the 'from' region becomes unhealthy.
		to?: string @protobuf(2,string)
	}

	// Optional: only one of distribute, failover or failoverPriority can be set.
	// Explicitly specify loadbalancing weight across different zones and geographical locations.
	// Refer to [Locality weighted load balancing](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/load_balancing/locality_weight)
	// If empty, the locality weight is set according to the endpoints number within it.
	distribute?: [...#Distribute] @protobuf(1,Distribute)

	// Optional: only one of distribute, failover or failoverPriority can be set.
	// Explicitly specify the region traffic will land on when endpoints in local region becomes unhealthy.
	// Should be used together with OutlierDetection to detect unhealthy endpoints.
	// Note: if no OutlierDetection specified, this will not take effect.
	failover?: [...#Failover] @protobuf(2,Failover)

	// failoverPriority is an ordered list of labels used to sort endpoints to do priority based load balancing.
	// This is to support traffic failover across different groups of endpoints.
	// Two kinds of labels can be specified:
	// - Specify only label keys `[key1, key2, key3]`, istio would compare the label values of client with endpoints.
	//   Suppose there are total N label keys `[key1, key2, key3, ...keyN]` specified:
	//
	//   1. Endpoints matching all N labels with the client proxy have priority P(0) i.e. the highest priority.
	//   2. Endpoints matching the first N-1 labels with the client proxy have priority P(1) i.e. second highest priority.
	//   3. By extension of this logic, endpoints matching only the first label with the client proxy has priority P(N-1) i.e. second lowest priority.
	//   4. All the other endpoints have priority P(N) i.e. lowest priority.
	//
	// - Specify labels with key and value `[key1=value1, key2=value2, key3=value3]`, istio would compare the labels with endpoints.
	//   Suppose there are total N labels `[key1=value1, key2=value2, key3=value3, ...keyN=valueN]` specified:
	//
	//   1. Endpoints matching all N labels have priority P(0) i.e. the highest priority.
	//   2. Endpoints matching the first N-1 labels have priority P(1) i.e. second highest priority.
	//   3. By extension of this logic, endpoints matching only the first label has priority P(N-1) i.e. second lowest priority.
	//   4. All the other endpoints have priority P(N) i.e. lowest priority.
	//
	// Note: For a label to be considered for match, the previous labels must match, i.e. nth label would be considered matched only if first n-1 labels match.
	//
	// It can be any label specified on both client and server workloads.
	// The following labels which have special semantic meaning are also supported:
	//
	//   - `topology.istio.io/network` is used to match the network metadata of an endpoint, which can be specified by pod/namespace label `topology.istio.io/network`, sidecar env `ISTIO_META_NETWORK` or MeshNetworks.
	//   - `topology.istio.io/cluster` is used to match the clusterID of an endpoint, which can be specified by pod label `topology.istio.io/cluster` or pod env `ISTIO_META_CLUSTER_ID`.
	//   - `topology.kubernetes.io/region` is used to match the region metadata of an endpoint, which maps to Kubernetes node label `topology.kubernetes.io/region` or the deprecated label `failure-domain.beta.kubernetes.io/region`.
	//   - `topology.kubernetes.io/zone` is used to match the zone metadata of an endpoint, which maps to Kubernetes node label `topology.kubernetes.io/zone` or the deprecated label `failure-domain.beta.kubernetes.io/zone`.
	//   - `topology.istio.io/subzone` is used to match the subzone metadata of an endpoint, which maps to Istio node label `topology.istio.io/subzone`.
	//   - `kubernetes.io/hostname` is used to match the current node of an endpoint, which maps to Kubernetes node label `kubernetes.io/hostname`.
	//
	// The below topology config indicates the following priority levels:
	//
	// ```yaml
	// failoverPriority:
	// - "topology.istio.io/network"
	// - "topology.kubernetes.io/region"
	// - "topology.kubernetes.io/zone"
	// - "topology.istio.io/subzone"
	// ```
	//
	// 1. endpoints match same [network, region, zone, subzone] label with the client proxy have the highest priority.
	// 2. endpoints have same [network, region, zone] label but different [subzone] label with the client proxy have the second highest priority.
	// 3. endpoints have same [network, region] label but different [zone] label with the client proxy have the third highest priority.
	// 4. endpoints have same [network] but different [region] labels with the client proxy have the fourth highest priority.
	// 5. all the other endpoints have the same lowest priority.
	//
	// Suppose a service associated endpoints reside in multi clusters, the below example represents:
	// 1. endpoints in `clusterA` and has `version=v1` label have P(0) priority.
	// 2. endpoints not in `clusterA` but has `version=v1` label have P(1) priority.
	// 2. all the other endpoints have P(2) priority.
	//
	// ```yaml
	// failoverPriority:
	// - "version=v1"
	// - "topology.istio.io/cluster=clusterA"
	// ```
	//
	// Optional: only one of distribute, failover or failoverPriority can be set.
	// And it should be used together with `OutlierDetection` to detect unhealthy endpoints, otherwise has no effect.
	failoverPriority?: [...string] @protobuf(4,string,name=failover_priority)

	// enable locality load balancing, this is DestinationRule-level and will override mesh wide settings in entirety.
	// e.g. true means that turn on locality load balancing for this DestinationRule no matter what mesh wide settings is.
	enabled?: null | bool @protobuf(3,google.protobuf.BoolValue)
}
