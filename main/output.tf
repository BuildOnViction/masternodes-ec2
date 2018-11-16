output "vpc_singapore_default" {
  value = "${module.vpc.vpc_id}"
}

output "masternode_sg_id" {
  description = "The ID of the security group"
  value = "${module.masternode_sg.this_security_group_id}"
}
output "ssh_sg_id" {
  description = "The ID of the security group"
  value = "${module.ssh_sg.this_security_group_id}"
}
output "bootnode_sg_id" {
  description = "The ID of the security group"
  value = "${module.bootnode_sg.this_security_group_id}"
}

output "testnet_sg_id" {
  description = "The ID of the security group"
  value = "${module.testnet_sg.this_security_group_id}"
}





