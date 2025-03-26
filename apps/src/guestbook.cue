package k8s

Application: "guestbook": {
	metadata: {
		namespace: _namespace
		finalizers: ["resources-finalizer.argocd.argoproj.io"]
	}
	spec: {
		destination: {
			namespace: Guestbook.Namespace
			server:    _apiServer
		}
		project: _project
		source: {
			path:           Guestbook.Path
			repoURL:        _repoURL
			targetRevision: "HEAD"
		}
	}
}
