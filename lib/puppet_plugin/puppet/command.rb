module Puppet
  module CommandPuppet
    class Command < Vagrant.plugin("2", "command")
      def execute
        @options = {}
        @options[:verbose]     = false
        @options[:debug]       = false
        @options[:trace]       = false
        @options[:provider]    = :virtualbox
        @options[:environment] = 'obeheer1'
        @options[:transport]   = 'vagrant'

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant puppet fqdn ipaddress [options]"
          o.separator ""
          o.separator "Options:"
          o.separator ""

          o.on("--[no-]puppet-debug",
               "Run puppet with --debug (default to false)") do |debug|
            @options[:debug] = debug
          end

          o.on("--[no-]verbose",
               "Run puppet with --verbose (default to true)") do |verbose|
            @options[:verbose] = verbose
          end

          o.on("--[no-]trace",
               "Run puppet with --trace (default to true)") do |trace|
            @options[:trace] = trace
          end

          o.on("--environment ENV", String,
               "Specify the environment. Default is: obeheer1") do |environment|
            @options[:environment] = environment
          end


          o.on("--transport TRANSPORT", String,
               "Specify the transport. Default is: vagrant") do |transport|
            @options[:transport] = transport
          end


          o.on("--provider PROVIDER", String,
               "Back the machine with a specific provider") do |provider|
            @options[:provider] = provider
          end

        end
        # Parse the options
        argv = parse_options(opts)
        if argv && argv.size == 2
          @fqdn       = argv[0]
          @ipaddress  = argv[1]
          @hostname   = @fqdn.split('.').first
        else
          @env.ui.error(I18n.t("vagrant.puppet_plugin.commands.identify.need_ip_and_name"))
          return 1
        end

        @env.ui.info(I18n.t(
          "vagrant.puppet_plugin.commands.identify.starting",
          hostname: @fqdn,
          ipaddress: @ipaddress))
        #
        # Get default machine from Vagrantfile
        #
        machine = @env.machine(:default, @options[:provider])
        #
        # Set name and ipadress based on parameters
        #
        set_machine_name(machine)
        set_name_and_ip(machine)
        set_shell_command(machine)
        set_puppet_options(machine)
        #
        # Check what state we are in and act accordingly
        #
        if machine.state.id == :running
          machine.action(:provision, @options)
        else
          machine.action(:up, @options)
        end
      end

private
      def set_machine_name(machine)
        #
        # This is a hack to set the machine name
        #
        new_name = @hostname.to_sym
        machine.instance_variable_set(:@name, new_name)
        machine.instance_variable_set(:@id, new_name)
        ui = Vagrant::UI::Prefixed.new(@env.ui, new_name)
        machine.instance_variable_set(:@ui, ui)
        machine.provider_config.name = @hostname
      end

      def set_name_and_ip(machine)
        machine.config.vm.hostname = @fqdn
        machine.config.vm.network(:private_network, :ip => @ipaddress)
      end

      def set_puppet_options(machine)
        provider = provider_with_id(2, machine)
        provider.options  << ' --verbose ' if @options[:verbose]
        provider.options  << ' --debug ' if @options[:debug]
        provider.facter.merge!('environment' => @options[:environment])
        provider.facter.merge!('transport' => @options[:transport])
      end

      def set_shell_command(machine)
        provider = provider_with_id(1, machine)
        command = "puppet apply -e \"host {'#{@fqdn}': ip => '#{@ipaddress}', host_aliases => ['#{@hostname}']} host {'localhost': ip=>  '127.0.0.1', host_aliases => 'localhost.localdomain,localhost4,localhost4.localdomain4' }\""
        provider.inline = command # Add a shell provider
        shell = machine.config.vm.provisioners.last.config
        shell.finalize!
      end

      def provider_with_id(id, machine)
        id = id.to_s
        machine.config.vm.provisioners.select {|p| p.id == id}.first.config
      end

    end
  end
end
