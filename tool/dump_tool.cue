package k8s

import (
	"encoding/yaml"
	"tool/cli"
)

_allManifests: [
	for map in [
		//*** base objects */
		Secret,
		Service,
		ConfigMap,
		Deployment,
		//*** istio objects */
		Sidecar,
		Gateway,
		EnvoyFilter,
		ServiceEntry,
		VirtualService,
		DestinationRule,
		AuthorizationPolicy,
	] for _, obj in map {obj},
]

command: dump: print: cli.Print & {
	text: yaml.MarshalStream(_allManifests)
}
