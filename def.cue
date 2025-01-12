package k8s

import lib_v1 "github.com/iam43x/cue-project-tutorial/lib@v1"

//*** main definition map k8s objects */
//*** base objects */
Job: [Name=string]: lib_v1.#Job & {metadata: name: Name}
Secret: [Name=string]: lib_v1.#Secret & {metadata: name: Name}
CronJob: [Name=string]: lib_v1.#CronJob & {metadata: name: Name}
Ingress: [Name=string]: lib_v1.#Ingress & {metadata: name: Name}
Service: [Name=string]: lib_v1.#Service & {metadata: name: Name}
ConfigMap: [Name=string]: lib_v1.#ConfigMap & {metadata: name: Name}
Deployment: [Name=string]: lib_v1.#Deployment & {metadata: name: Name}
NetworkPolicy: [Name=string]: lib_v1.#NetworkPolicy & {metadata: name: Name}
HorizontalPodAutoscaler: [Name=string]: lib_v1.#HorizontalPodAutoscaler & {metadata: name: Name}

//*** istio objects */
Sidecar: [Name=string]: lib_v1.#Sidecar & {metadata: name: Name}
Gateway: [Name=string]: lib_v1.#Gateway & {metadata: name: Name}
EnvoyFilter: [Name=string]: lib_v1.#EnvoyFilter & {metadata: name: Name}
ServiceEntry: [Name=string]: lib_v1.#ServiceEntry & {metadata: name: Name}
VirtualService: [Name=string]: lib_v1.#VirtualService & {metadata: name: Name}
DestinationRule: [Name=string]: lib_v1.#DestinationRule & {metadata: name: Name}
AuthorizationPolicy: [Name=string]: lib_v1.#AuthorizationPolicy & {metadata: name: Name}
//*** argo-cd objects */
AppProject: [Name=string]: lib_v1.#AppProject & {metadata: name: Name}
Application: [Name=string]: lib_v1.#Application & {metadata: name: Name}
ApplicationSet: [Name=string]: lib_v1.#ApplicationSet & {metadata: name: Name}