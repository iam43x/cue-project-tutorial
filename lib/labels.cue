package lib

import "strings"

Labels: {
	Component: "app.kubernetes.io/component": Tags.Component & #ResourceName
	Version: "app.kubernetes.io/version":     Tags.Version & #SemVer2
	CommitInfo: {
		let username = strings.Split(Tags.AuthorCommit, "@")[0]
		"app.kubernetes.io/author-commit": strings.ToLower(username) & #ResourceName
		"app.kubernetes.io/hash-commit":   Tags.HashCommit & =~"^[a-f0-9]{40}$"
	}
}
