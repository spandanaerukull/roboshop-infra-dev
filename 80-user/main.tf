module "user" {
  source       = "../../terraform-aws-roboshopmodule"
  rule_priority = 20
  component     = "user"
}