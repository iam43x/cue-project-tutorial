package k8s

import (
	"encoding/yaml"
	"tool/cli"
)

command: dump: print: cli.Print & {
	text: yaml.MarshalStream(_allManifests)
}
