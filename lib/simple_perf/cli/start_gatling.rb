require 'trollop'

module SimplePerf
  module CLI
    class StartGatling
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Starts Gatling java processes.

Usage:
      simple_perf start_gatling -e ENVIRONMENT -n STACK_NAME
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :name, "Stack name to manage", :type => :string
          opt :simulation, "Gatling User simulation file (e.g. live_community.TaxUserModelSimulation)", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :name, "is required but not specified" unless opts[:name]
        Trollop::die :simulation, "is required but not specified" unless opts[:simulation]

        config = Config.new.environment opts[:environment]

        ENV['SIMPLE_DEPLOY_SSH_KEY'] = config['local_pem']
        ENV['SIMPLE_DEPLOY_SSH_USER'] = config['user']

        command = 'simple_deploy execute' +
                    ' -e ' + opts[:environment] +
                    ' -n ' + opts[:name] +
                    ' -c "cd ~/gatling_test_files; nohup ./gatling.sh ' + opts[:simulation] + ' < input > gatling.log  &"' +
                    ' -l debug'

        Shared::pretty_print `#{command}`
      end
    end
  end
end
