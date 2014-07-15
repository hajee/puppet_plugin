module Puppet
  module CommandIdentify
    class Plugin < Vagrant.plugin("2")
      name "Load a known puppet node and apply the it"
      description <<-DESC
      Boot as the specified node and run puppet on it.
      DESC

      command("puppet") do
        require_relative "command"
        Command
      end
    end
  end
end
