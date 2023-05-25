VM_CPUS="4"
VM_MEM="4396"


Vagrant.configure("2") do |config|
  config.vm.box = "gusztavvargadr/windows-10"
  config.vm.define "recobery" do |vb|
    vb.vm.hostname = "win-10"
    vb.vm.provider "virtualbox" do |v|
      v.name = ENV["VM_NAME"] || "windows-10" # Using ENV_VAR
      v.memory = VM_MEM
      v.cpus = VM_CPUS

    end

  end
end
