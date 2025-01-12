package k8s

import (
	"text/tabwriter"
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

command: ls: print: cli.Print & {
	text: tabwriter.Write([
		"┌─ Kind\t─┬─ Name\t─┐",
		for obj in _allManifests {"│ \(obj.kind)\t │ \(obj.metadata.name)\t │"},
		"└─\t─┴─\t─┘",
	])
}
