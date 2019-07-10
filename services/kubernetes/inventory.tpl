[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${private_key}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[masters]
${k8s_masters_ip}

[nodes]
${k8s_nodes_ip}