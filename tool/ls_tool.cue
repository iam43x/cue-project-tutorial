package k8s

import (
	"text/tabwriter"
	"tool/cli"
)

command: ls: print: cli.Print & {
	text: tabwriter.Write([
		"┌─ Kind\t─┬─ Name\t─┐",
		for obj in _allManifests {"│ \(obj.kind)\t │ \(obj.metadata.name)\t │"},
		"└─\t─┴─\t─┘",
	])
}
