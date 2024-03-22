[master]
%{ for ip in master_ips ~}
${ip} ansible_user=ubuntu ansible_ssh_private_key_file=./pro1.pem
%{ endfor ~}

[workers]
%{ for ip in worker_ips ~}
${ip} ansible_user=ubuntu ansible_ssh_private_key_file=./pro1.pem ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ubuntu@${master_ips[0]} -i ./pro1.pem"'
%{ endfor ~}
