variable "components" {
default = {
    catalogue = {
        rule_priority = 10
      }
    cart = {
        rule_priority = 30
      }
   user = {
        
        rule_priority = 20
      }

    shipping = {
        
        rule_priority = 40
      }

      payment = {
        
        rule_priority = 50
      }
    frontend = {
        
        rule_priority = 10
      }


}
}
