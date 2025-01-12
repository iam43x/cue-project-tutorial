package v1

import (
	"k8s.io/apimachinery/pkg/apis/meta/v1"
	"istio.io/api/security/v1beta1"
	"istio.io/api/meta/v1alpha1"
)

#AuthorizationPolicy: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta               @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1beta1.#AuthorizationPolicy @protobuf(3,.istio.security.v1beta1.AuthorizationPolicy)
	status?:   v1alpha1.#IstioStatus        @protobuf(4,.istio.meta.v1alpha1.IstioStatus)
}

#PeerAuthentication: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta              @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1beta1.#PeerAuthentication @protobuf(3,.istio.security.v1beta1.PeerAuthentication)
	status?:   v1alpha1.#IstioStatus       @protobuf(4,istio.meta.v1alpha1.IstioStatus)
}

#RequestAuthentication: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta                 @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1beta1.#RequestAuthentication @protobuf(3,.istio.security.v1beta1.RequestAuthentication)
	status?:   v1alpha1.#IstioStatus          @protobuf(4,istio.meta.v1alpha1.IstioStatus)
}
