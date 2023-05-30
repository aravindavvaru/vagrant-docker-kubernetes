# -*- mode: ruby -*-
# vi: set ft=ruby :
require "yaml"
settings = YAML.load_file "settings.yaml"

IP_SECTIONS = settings["network"]["control_ip"].match(/^([0-9.]+\.)([^.]+)$/)
# First 3 octets including the trailing dot:
IP_NW = IP_SECTIONS.captures[0]
# Last octet excluding all dots:
IP_START = Integer(IP_SECTIONS.captures[1])
NUM_WORKER_NODES = settings["nodes"]["workers"]["count"]



Vagrant.configure(2) do |config|

  config.vm.define "master" do |master|
    
    master.vm.hostname = "master-node"
    master.vm.network "private_network", ip: settings["network"]["control_ip"]
    if settings["shared_folders"]
      settings["shared_folders"].each do |shared_folder|
        master.vm.synced_folder shared_folder["host_path"], shared_folder["vm_path"]
      end
    end

    config.vm.provider "docker" do |docker|
      #docker.build_dir = "."
       docker.image = "test"
      docker.has_ssh = true
      docker.privileged = true
      docker.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:rw"]
      docker.create_args = ["--cgroupns=host"]
      docker.remains_running = false
    end

    master.vm.provision "shell",
      env: {
        "DNS_SERVERS" => settings["network"]["dns_servers"].join(" "),
        "ENVIRONMENT" => settings["environment"],
        "KUBERNETES_VERSION" => settings["software"]["kubernetes"],
        "OS" => settings["software"]["os"]
      },
      path: "scripts/common.sh"

    # master.vm.provision "shell",
    #   env: {
    #     "CALICO_VERSION" => settings["software"]["calico"],
    #     "CONTROL_IP" => settings["network"]["control_ip"],
    #     "POD_CIDR" => settings["network"]["pod_cidr"],
    #     "SERVICE_CIDR" => settings["network"]["service_cidr"]
    #   },
    #   path: "scripts/master.sh"

  end
end