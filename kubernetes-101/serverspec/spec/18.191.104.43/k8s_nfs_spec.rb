require 'spec_helper'

describe package('nfs-kernel-server') do
  it { should be_installed }
end

describe service('nfs-kernel-server') do
  it { should be_running }
end

describe file('/etc/exports') do
  it { should exist }
  it { should be_file }
end

describe file('/var/docker/db') do
  it { should exist }
  it { should be_directory }
end

describe file('/var/docker/static/assets') do
  it { should exist }
  it { should be_directory }
end

describe file('/var/docker/static/media') do
  it { should exist }
  it { should be_directory }
end

describe file('/var/docker/logs') do
  it { should exist }
  it { should be_directory }
end

describe file('/etc/exports') do
  it { should contain '/var/docker/db            *(rw,sync,no_subtree_check,no_root_squash)' }
  it { should contain '/var/docker/static/assets *(rw,sync,no_subtree_check,no_root_squash)' }
  it { should contain '/var/docker/static/media  *(rw,sync,no_subtree_check,no_root_squash)' }
end

describe command('showmount -e') do
  its(:stdout) { should match('/var/docker/logs') }
  its(:stdout) { should match('/var/docker/db') }
  its(:stdout) { should match('/var/docker/static/assets') }
  its(:stdout) { should match('/var/docker/static/media') }
end
