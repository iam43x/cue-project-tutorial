package k8s

import (
	"tool/file"
	"strings"
	"encoding/yaml"
)

buildPath: string @tag(build_path)

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

command: build: {
	for i, obj in _allManifests {
		let type = strings.ToLower(obj.kind)
		let name = obj.metadata.name
		"\(type)/\(name)": {
			mkdir: file.MkdirAll & {
				path: "\(buildPath)/build/\(type)"
			}
			write: file.Create & {
				$dep:     mkdir.$done
				filename: "\(mkdir.path)/\(name).yaml"
				contents: yaml.Marshal(obj)
			}
		}
	}
}