require 'serverspec'
require 'net/ssh'

set :backend, :ssh

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

set :host,        options[:host_name] || host
set :ssh_options, {
  :keys => ENV['SSH_PRIVATE_KEY'],
  :user => 'ubuntu'
}
