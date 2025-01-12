package v1alpha3

import (
	"k8s.io/apimachinery/pkg/apis/meta/v1"
	"istio.io/api/networking/v1alpha3"
	"istio.io/api/meta/v1alpha1"
)

#DestinationRule: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta            @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1alpha3.#DestinationRule @protobuf(3,.istio.networking.v1alpha3.DestinationRule)
	status?:   v1alpha1.#IstioStatus     @protobuf(4,.istio.meta.v1alpha1.IstioStatus)
}

#EnvoyFilter: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta        @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1alpha3.#EnvoyFilter @protobuf(3,.istio.networking.v1alpha3.EnvoyFilter)
	status?:   v1alpha1.#IstioStatus @protobuf(4,.istio.meta.v1alpha1.IstioStatus)
}

#Gateway: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta        @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1alpha3.#Gateway     @protobuf(3,.istio.networking.v1alpha3.Gateway)
	status?:   v1alpha1.#IstioStatus @protobuf(4,.istio.meta.v1alpha1.IstioStatus)
}

#ServiceEntry: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta               @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1alpha3.#ServiceEntry       @protobuf(3,.istio.networking.v1alpha3.ServiceEntry)
	status?:   v1alpha3.#ServiceEntryStatus @protobuf(4,.istio.networking.v1alpha3.ServiceEntryStatus)
}

#Sidecar: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta        @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1alpha3.#Sidecar     @protobuf(3,.istio.networking.v1alpha3.Sidecar)
	status?:   v1alpha1.#IstioStatus @protobuf(4,.istio.meta.v1alpha1.IstioStatus)
}

#VirtualService: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta           @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1alpha3.#VirtualService @protobuf(3,.istio.networking.v1alpha3.VirtualService)
	status?:   v1alpha1.#IstioStatus    @protobuf(4,.istio.meta.v1alpha1.IstioStatus)
}

#WorkloadEntry: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta          @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1alpha3.#WorkloadEntry @protobuf(3,.istio.networking.v1alpha3.WorkloadEntry)
	status?:   v1alpha1.#IstioStatus   @protobuf(4,.istio.meta.v1alpha1.IstioStatus)
}

#WorkloadGroup: {
	v1.#TypeMeta
	metadata?: v1.#ObjectMeta          @protobuf(2,.k8s.io.apimachinery.pkg.apis.meta.v1.ObjectMeta)
	spec?:     v1alpha3.#WorkloadGroup @protobuf(3,.istio.networking.v1alpha3.WorkloadGroup)
	status?:   v1alpha1.#IstioStatus   @protobuf(4,.istio.meta.v1alpha1.IstioStatus)
}
