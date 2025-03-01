package lib

Labels: {
	Component: "app.kubernetes.io/component": Tags.Component & #ResourceName
	Version: "app.kubernetes.io/version":     Tags.Version & #SemVer2
	CommitInfo: {
		"app.kubernetes.io/author-commit": Tags.AuthorCommit & =~"^.+@.+$"
		"app.kubernetes.io/hash-commit":   Tags.HashCommit & =~"^[a-f0-9]{40}$"
	}
}
