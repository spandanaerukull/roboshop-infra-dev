module "component" {
 for_each = var.components # iterating over components map variable
  source       = "../../terraform-aws-roboshopmodule"
  rule_priority = each.value.rule_priority
  component     = each.key
}