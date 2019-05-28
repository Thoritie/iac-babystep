kubectl config set-cluster demo-k8s --server=http://18.191.198.18:6443
kubectl config set clusters.demo-k8s.certificate-authority-data $(cat certificate/pronto_world_certificate_authority_data)
kubectl config set-context kube-demo --cluster=demo-k8s --user=demo-admin
kubectl config set users.demo-admin.client-key-data $(cat certificate/pronto_world_client_key_data)
kubectl config set users.demo-admin.client-certificate-data $(cat certificate/pronto_world_client_certificate_data)
kubectl config use-context kube-demo
