local kp =
  (import 'kube-prometheus/main.libsonnet') +
  {
    values+:: {
      common+: {
        namespace: 'monitoring',
      },
    },
    prometheusAdapter+:: {
      deployment+: {
        spec+: {
          replicas: 1,
        },
      },
    },
    grafana+:: {
      networkPolicy+: {
        spec+: {
          ingress: [{}],
        },
      },
    },
    prometheus+:: {
      networkPolicy+: {
        spec+: {
          ingress: [{}],
        },
      },
      prometheus+: {
        spec+: {
          replicas: 1,
          securityContext: {
            fsGroup: 2000,
            runAsNonRoot: false,
            runAsUser: 0,
          },
          retention: '30d',
          storage: {
            volumeClaimTemplate: {
              apiVersion: 'v1',
              kind: 'PersistentVolumeClaim',
              spec: {
                accessModes: ['ReadWriteMany'],
                resources: { requests: { storage: '100Gi' } },
                storageClassName: 'synology-iscsi-storage',
              },
            },
          },
        },
      },
    },
  };
{ ['setup/0namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor'), std.objectFields(kp.prometheusOperator))
} +
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
