require 'spec_helper'

describe package('docker.io') do
  it { should be_installed }
end

describe package('kubeadm') do
  it { should be_installed }
end

describe service('docker') do
  it { should be_running }
end

describe package('nfs-common') do
  it { should be_installed }
end


describe command('kubectl get node') do
  its(:stdout) { should match /demo-master\s+Ready/ }
  its(:stdout) { should match /demo-worker\s+Ready/ }
end

describe command('kubectl get deployment') do
  its(:stdout) { should match /app\s+1\/1/ }
  its(:stdout) { should match /db-deployment\s+1\/1/ }
  its(:stdout) { should match /nginx-deployment\s+1\/1/ }
end

describe command('kubectl get pod') do
  its(:stdout) { should match /app.*1\/1\s+Running/ }
  its(:stdout) { should match /db-deployment.*1\/1\s+Running/ }
  its(:stdout) { should match /nginx-deployment.*1\/1\s+Running/ }
end

describe command('kubectl get pv') do
  its(:stdout) { should match /logs-pv.*RWX.*dev\/logs-pvc/ }
  its(:stdout) { should match /postgres-pv.*RWX.*dev\/postgres-pvc/ }
  its(:stdout) { should match /static-assets-pv.*RWX.*dev\/static-assets-pvc/ }
  its(:stdout) { should match /static-media-pv.*RWX.*dev\/static-media-pvc/ }
end

describe command('kubectl get pvc') do
  its(:stdout) { should match /logs-pv.*logs-pv.*RWX/ }
  its(:stdout) { should match /postgres-pvc.*postgres-pv.*RWX/ }
  its(:stdout) { should match /static-assets-pvc.*static-assets-pv.*RWX/ }
  its(:stdout) { should match /static-media-pvc.*static-media-pv.*RWX/ }
end

describe command('kubectl get secret') do
  its(:stdout) { should match /env-secrets/ }
end
