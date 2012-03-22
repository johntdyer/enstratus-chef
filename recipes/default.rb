#
# Cookbook Name:: enstratus
# Recipe:: default
#
# Copyright 2012, Voxeo Labs ©2011
#
# All rights reserved - Do Not Redistribute
#

url = node[:enstratus][:url]
tmp = Chef::Config[:file_cache_path]
o   =  node[:enstratus][:user]
g   =  node[:enstratus][:group]


package_name = value_for_platform(
  ["centos", "redhat", "amazon"] => { "default" => "enstratus-agent-centos-v#{node[:enstratus][:version]}.tar.gz" },
  "ubuntu" => { "default" => "enstratus-agent-ubuntu-v#{node[:enstratus][:version]}.tar.gz" },
  "debian" => { "default" => "enstratus-agent-debian-v#{node[:enstratus][:version]}.tar.gz" },
  "smartos" => { "default" => "enstratus-agent-smartos-v#{node[:enstratus][:version]}.tar.gz" },
  "fedora" => { "default" => "enstratus-agent-fedora-v#{node[:enstratus][:version]}.tar.gz" }
  )

user "enstratus" do
  comment "Enstratus User"
  system true
  shell "/bin/false"
end

directory "/mnt/tmp" do
  owner o
  group g
  mode "0755"
  recursive true
  action :create
end

remote_file "#{tmp}/#{package_name}" do
  source "#{url}/#{package_name}"
  owner o
  group g
  checksum node[:enstratus][:checksum]
  notifies :run, "script[install package]", :immediately
end

script "install package" do
  action :nothing
  interpreter "bash"
  user o
  cwd "/mnt/tmp"
  code <<-EOF
  cp #{tmp}/#{package_name} /mnt/tmp
  tar zxvf #{package_name}
  cd enstratus/bin
  chmod o+x *
  ./setup-centos -Y
  /mnt/tmp/enstratus/install.sh #{node[:enstratus][:cloud]} #{node[:enstratus][:environment]} #{node[:enstratus][:proxy]}
  EOF
end

