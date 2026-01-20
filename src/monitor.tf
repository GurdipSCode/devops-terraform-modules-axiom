resource "axiom_monitor" "this" {
  count = var.create_monitor ? 1 : 0

  depends_on = [
    axiom_dataset.this,
    axiom_notifier.this
  ]

  type             = var.monitor_type
  name             = var.monitor_name
  description      = var.monitor_description
  apl_query        = var.monitor_apl_query
  interval_minutes = var.monitor_interval_minutes
  range_minutes    = var.monitor_range_minutes

  operator  = var.monitor_operator
  threshold = var.monitor_threshold

  compare_days = var.monitor_compare_days
  tolerance    = var.monitor_tolerance

  notifier_ids     = local.effective_notifier_ids
  alert_on_no_data = var.monitor_alert_on_no_data
  notify_by_group  = var.monitor_notify_by_group
}
