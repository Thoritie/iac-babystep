kubectl config set-cluster k8s-pronto-world-dev --server=https://108.128.179.69:6443
kubectl config set clusters.k8s-pronto-world-dev.certificate-authority-data $(cat certificate/pronto_world_certificate_authority_data)
kubectl config set-context kube-pronto-world --cluster=k8s-pronto-world-dev --user=kube-pronto-world-admin
kubectl config set users.kube-pronto-world-admin.client-key-data $(cat certificate/pronto_world_client_key_data)
kubectl config set users.kube-pronto-world-admin.client-certificate-data $(cat certificate/pronto_world_client_certificate_data)
kubectl config use-context kube-pronto-world
