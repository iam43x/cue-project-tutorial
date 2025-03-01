package lib

import "strings"

#ResourceName: =~"^[a-z0-9-]+$" | strings.MaxRunes(63)

#ExportTo: *["."] | ["*"]

#FQDN: "*" | =~"^[a-z0-9-.]+[.][a-z0-9-]+$" | strings.MaxRunes(63)

#ProtocolIPv4: *"TCP" | "UDP"

#Protocol: #ProtocolIPv4 | "HTTP" | "HTTPS" | "GRPC" | "GRPC-WEB" | "HTTP2" | "MONGO" | "TLS"

#PortName: strings.HasPrefix("tcp-") | strings.HasPrefix("udp-") | strings.HasPrefix("http-") | strings.HasPrefix("https-") |
	strings.HasPrefix("grpc-") | strings.HasPrefix("grpc-web-") | strings.HasPrefix("http2-") | strings.HasPrefix("mongo-") |
	strings.HasPrefix("tls-")

//*** exclude 0, because 0 maybe all/random port value... */
#Port: uint16 & >0

#Labels: {
	Labels.Version
	Labels.Component
	Labels.CommitInfo
	"app.kubernetes.io/instance"?: #ResourceName
	[string]:                      string
}

#SemVer2: =~"^v\\d+.\\d+.\\d+$"