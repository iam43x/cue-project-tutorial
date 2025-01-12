package k8s

_selector: {
	"app.kubernetes.io/component": "guestbook"
}

_labels: {
	_selector
}

_metadata: {
	namespace: Values.Namespace
	labels:    _labels
}