resource "kubernetes_persistent_volume_claim" "example_pvc" {
  metadata {
    name      = "example-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    storage_class_name = "gp2"
  }
}


