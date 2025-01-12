# Changelog

### v1.0.0
___
#### Changed

- [github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1/generated_proto_gen.cue](./github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1/generated_proto_gen.cue)
для `#AppProject, #Application, #ApplicationSet` добавлено поле `v1.#TypeMeta`
- [k8s.io/apimachinery/pkg/util/intstr/generated_proto_gen.cue](./k8s.io/apimachinery/pkg/util/intstr/generated_proto_gen.cue) Исправлен тип `intOrString` на `int | string`
- [k8s.io/api/apps/v1/generated_proto_gen.cue](./k8s.io/api/apps/v1/generated_proto_gen.cue) для
`#ControllerRevision, #DaemonSet, #Deployment, #ReplicaSet, #StatefulSet` добавлено поле `v1.#TypeMeta`
- [k8s.io/api/core/v1/generated_proto_gen.cue](./k8s.io/api/core/v1/generated_proto_gen.cue) для
    `#Binding, #ComponentStatus, #ConfigMap, #Endpoints, #Event, #LimitRange, #Namespace, #Node, #PersistentVolume, #PersistentVolumeClaim, #PersistentVolumeClaimTemplate, #Pod, #PodStatusResult, #PodTemplate, #PodTemplateSpec, #RangeAllocation, #ReplicationController, #ResourceQuota, #Secret, #Service, #ServiceAccount` добавлено поле `v1.#TypeMeta`
- [k8s.io/api/networking/v1/generated_proto_gen.cue](./k8s.io/api/networking/v1/generated_proto_gen.cue) для `#Ingress, #IngressClass, #NetworkPolicy` добавлено поле `v1.#TypeMeta`
- [k8s.io/api/autoscaling/v2/generated_proto_gen.cue](./k8s.io/api/autoscaling/v2/generated_proto_gen.cue) для `#HorizontalPodAutoscaler` добавлено поле `v1.#TypeMeta`
- [k8s.io/api/batch/v1/generated_proto_gen.cue](./k8s.io/api/batch/v1/generated_proto_gen.cue) `#CronJob, #Job` добавлено поле `v1.#TypeMeta`

#### Added

Добавлено Istio API

* [istio.io/client-go/pkg/apis/networking/all_types_networking.cue](./istio.io/client-go/pkg/apis/networking/all_types_networking.cue)
* [istio.io/client-go/pkg/apis/security/all_types_security.cue](./istio.io/client-go/pkg/apis/security/all_types_security.cue)

---