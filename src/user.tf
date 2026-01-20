resource "axiom_user" "this" {
  count = var.create_user ? 1 : 0

  name  = var.user_name
  email = var.user_email
  role  = var.user_role
}
