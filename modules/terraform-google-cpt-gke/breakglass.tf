/**
*   Binauthz Breakglass Metric
*   ---
*   A logging metric based on a filter that exposes logs which contain a break-glass label.
**/
resource "google_logging_metric" "binauthz_breakglass_metric" {
  project = var.project_id
  name   = "${var.name}/binauthz-break-glass"
  filter = <<FILTER
    resource.type="k8s_cluster"
    resource.labels.cluster_name="${var.name}"
    logName:"cloudaudit.googleapis.com%2Factivity"
    (protoPayload.methodName="io.k8s.core.v1.pods.create" OR
    protoPayload.methodName="io.k8s.core.v1.pods.update")
    labels."imagepolicywebhook.image-policy.k8s.io/break-glass"="true"
  FILTER
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}
/**
*   Monitoring Notification Channel

*   ---
*   Notification channels for each e-mail address to receive breakglass notifications
**/
resource "google_monitoring_notification_channel" "binauthz_breakglass_alert_channel" {
  count        = length(var.binauthz.breakglass.email_addresses)
  project      = var.project_id
  display_name = "${var.name}-breakglass-channel-${count.index}"
  type         = "email"
  labels = {
    email_address = var.binauthz.breakglass.email_addresses[count.index]
  }
}

resource "time_sleep" "wait_for_metric_propogation" {
  depends_on = [google_logging_metric.binauthz_breakglass_metric]
  create_duration = "30s"
}

/**
*   Monitoring Alert Policy
*   ---
*   A monitoring alert policy which alerts based on the above breakglass logging metric
**/ 
resource "google_monitoring_alert_policy" "binauthz_breakglass_alert_policy" {
  count        = length(var.binauthz.breakglass.email_addresses) > 0 ? 1 : 0
  project = var.project_id
  display_name = "${var.name}-breakglass-alerts"
  notification_channels = [
    for channel in google_monitoring_notification_channel.binauthz_breakglass_alert_channel:
    channel.name
  ]
  combiner     = "OR"
  conditions {
    display_name = "Break-glass Count"
    condition_threshold {
      filter     = <<FILTER
      metric.type="logging.googleapis.com/user/${var.name}/binauthz-break-glass" AND resource.type="k8s_cluster"
      FILTER
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "120s"
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }

  depends_on = [
    time_sleep.wait_for_metric_propogation
  ]
}