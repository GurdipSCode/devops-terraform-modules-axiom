resource "axiom_dataset" "this" {
  count       = var.create_dataset ? 1 : 0
  name        = var.dataset_name
  description = var.dataset_description
}
