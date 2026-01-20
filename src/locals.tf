locals {
  dataset_id  = try(axiom_dataset.this[0].id, null)
  notifier_id = try(axiom_notifier.this[0].id, null)
  monitor_id  = try(axiom_monitor.this[0].id, null)
  user_id     = try(axiom_user.this[0].id, null)

  effective_notifier_ids = var.create_notifier ? (
    local.notifier_id == null ? [] : [local.notifier_id]
  ) : var.monitor_notifier_ids
}
