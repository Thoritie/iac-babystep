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
