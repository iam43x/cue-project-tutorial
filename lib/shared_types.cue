package lib

import "strings"

#ResourceName: =~"^[a-z0-9-]+$" | strings.MaxRunes(63)

#ExportTo: *["."] | ["*"]

#FQDN: "*" | =~"^[a-z0-9-.]+[.][a-z0-9-]+$" | strings.MaxRunes(63)

#Protocol: "HTTP" | "HTTPS" | "GRPC" | "GRPC-WEB" | "HTTP2" | "MONGO" | "TCP" | "TLS"

//*** exclude 0, because 0 maybe all/random port value... */
#Port: uint16 & >0

#Labels: {
	"app.kubernetes.io/component": #ResourceName
	"app.kubernetes.io/instance"?: #ResourceName
	#GitLabels
	[string]: string
}

#GitLabels: {
	"app.kubernetes.io/version":       Version & =~"^v\\d.\\d.\\d$"
	"app.kubernetes.io/author-commit": AuthorCommit & =~"^.+@.+$"
	"app.kubernetes.io/hash-commit":   HashCommit & =~"^[a-f0-9]{40}$"
}
