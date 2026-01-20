resource "axiom_notifier" "this" {
  count = var.create_notifier ? 1 : 0
  name  = var.notifier_name

  properties = {
    "${var.notifier_type}" = var.notifier_properties
  }
}
