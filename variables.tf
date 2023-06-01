variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
}

variable "effect" {
 type  = string
 description = "List of allowed Locations"
}
variable "assign_name" {
 type  = string
 description = "Name of the Assignment"
}
variable "name" {
 type  = string
 description = "Name of the Policy Definition"
}