module Puppet
  module CommandIdentify
    class Command < Vagrant.plugin("2", "command")
      def execute
        @options = {}
        @options[:verbose]     = false
        @options[:debug]       = false
        @options[:trace]       = false
        @options[:provider]    = 'virtualbox'
        @options[:environment] = 'obeheer1'
        @options[:transport]   = 'vagrant'

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant identify [options] [name]"
          o.separator ""
          o.separator "Options:"
          o.separator ""

          o.on("--[no-]debug",
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
        if argv.size < 2
          @env.ui.info(I18n.t("vagrant.puppet_plugin.commands.identify.need_ip_and_name"))
          return 1
        end

        @hostname  = argv[0]
        @ipaddress = argv[1]
 
        @env.ui.info(I18n.t(
          "vagrant.puppet_plugin.commands.identify.starting",
          hostname: @hostname,
          ipaddress: @ipaddress))

        with_target_vms('default', provider: @options[:provider]) do |machine|
          set_name_and_ip(machine)
          set_puppet_options(machine)
          set_shell_command(machine)
          machine.action(:up, @options)
        end
      end

private
      def set_name_and_ip(machine)
        machine.config.vm.hostname = @hostname
        machine.config.vm.network(:private_network, :ip => @ipaddress)
      end

      def set_puppet_options(machine)
        puppet = machine.config.vm.provisioners.first.config
        puppet.options  << '--verbose' if @options[:verbose]
        puppet.options  << '--debug' if @options[:debug]
        puppet.facter.merge!('environment' => @options[:environment])
        puppet.facter.merge!('transport' => @options[:transport])
      end

      def set_shell_command(machine)
        host_alias = @hostname.split('.').first
        machine.config.vm.provision(:shell) # Add a shell provider
        shell = machine.config.vm.provisioners.last.config
        shell.inline = "puppet apply -e \"host {'#{@hostname}': ip => #{@ipaddress}, host_aliases => ['${host_alias}']} host {'localhost': ip=>  '127.0.0.1', host_aliases => 'localhost.localdomain,localhost4,localhost4.localdomain4' }\""
        shell.path = nil
        shell.args = nil
      end

    end
  end
end
