module Puppet
  module CommandIdentify
    class Plugin < Vagrant.plugin("2")
      name "Identify as a known puppet node"
      description <<-DESC
      Boot as the specified node.
      DESC

      command("identify") do
        require_relative "command"
        Command
      end
    end
  end
end
