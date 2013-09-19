require 'trollop'

module SimplePerf
  module CLI
    class StartCustom
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Starts JMeter or Gatling with custom shell script.

Usage:
      simple_perf start_custom -e ENVIRONMENT -n STACK_NAME
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :name, "Stack name to manage", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :name, "is required but not specified" unless opts[:name]

        config = Config.new.environment opts[:environment]

        ENV['SIMPLE_DEPLOY_SSH_KEY'] = config['local_pem']
        ENV['SIMPLE_DEPLOY_SSH_USER'] = config['user']

        command = 'simple_deploy execute' +
                    ' -e ' + opts[:environment] +
                    ' -n ' + opts[:name] +
                    ' -c "cd ~/simple_perf_test_files; nohup ./start_custom.sh > start_custom.log  &"' +
                    ' -l debug'

        Shared::pretty_print `#{command}`
      end
    end
  end
end
