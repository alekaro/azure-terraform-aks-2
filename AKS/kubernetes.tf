resource "kubernetes_deployment" "dep1" {
  metadata {
    name = "dep-example"
    labels = {
      app = "example-app"
    }
  }

  lifecycle {
    ignore_changes = [
      # Number of replicas is controlled by
      # kubernetes_horizontal_pod_autoscaler, ignore the setting in this
      # deployment template.
      spec[0].replicas,
    ]
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "example-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "example-app"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example-container"

          resources {
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "50Mi"
            }
          }

          port {
            container_port    = 80
            #   host_port         = 80      # Not needed as host_port = container_port by default if not specified
            protocol            = "TCP"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ser1" {
  metadata {
    name = "ser-example"
  }
  spec {
    selector = {
      app = kubernetes_deployment.dep1.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "hpa1" {
  metadata {
    name = "hpa-example"
  }

  spec {
    min_replicas = 3
    max_replicas = 70

    scale_target_ref {
      api_version   = "apps/v1"
      kind          = "Deployment"
      name          = kubernetes_deployment.dep1.metadata.0.name
    }

    target_cpu_utilization_percentage = 4

    # metric {
    #   type = "External"
    #   external {
    #     metric {
    #       name = "latency"
    #       selector {
    #         match_labels = {
    #           lb_name = "app"
    #         }
    #       }
    #     }
    #     target {
    #       type  = "Value"
    #       value = "100"
    #     }
    #   }
    # }
  }

  depends_on    = [kubernetes_deployment.dep1]
}

resource "kubernetes_ingress" "ingr1" {
  metadata {
    name            = "ingr-example"
    annotations = {
        "kubernetes.io/ingress.class" = "azure/application-gateway"
            
    }
  }

  spec {
    backend {
      service_name = kubernetes_service.ser1.metadata.0.name
      service_port = 8080
    }

    rule {
      http {
        path {
          backend {
            service_name = kubernetes_service.ser1.metadata.0.name
            service_port = 8080
          }
        }
      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }
}