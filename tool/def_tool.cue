package k8s

_allManifests: [
	for map in [
		//*** base objects */
		Job,
		Secret,
		CronJob,
		Ingress,
		Secret,
		Service,
		ConfigMap,
		Deployment,
		NetworkPolicy,
		HorizontalPodAutoscaler,
		//*** istio objects */
		Sidecar,
		Gateway,
		EnvoyFilter,
		ServiceEntry,
		VirtualService,
		DestinationRule,
		AuthorizationPolicy,
		//*** argocd objects */
		AppProject,
		Application,
		ApplicationSet,
	] for _, obj in map {obj},
]
