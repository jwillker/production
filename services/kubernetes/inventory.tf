#data  "template_file" "k8s" {
#  template = "${file("./inventory.tpl")}"
#  vars {
#    private_key    = "Bastion_Key"
#    k8s_masters_ip = "${join("\n", module.masters.public_ip)}"
#    k8s_nodes_ip   = "${join("\n", module.nodes.public_ip)}"
#  }
#}
#
#resource "local_file" "k8s_file" {
#  content  = "${data.template_file.k8s.rendered}"
#  filename = "../kubeadm_create/hosts"
#}
#
