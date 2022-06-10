variable "appName" {
    type = string
    default = ""
}
variable "description" {
    type = string
    default = ""
}
variable "env" {
    type = string
    default = ""
}
variable "delay_seconds" {
    type = number

}
variable "max_message_size" {
    type = number
}
variable "message_retention_seconds" {
    type = number
}
variable "receive_wait_time_seconds" {
    type = number
}
variable "Visibility" {
    type = number
}
variable "stack_name" {
    type = string
    default = ""
}
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}