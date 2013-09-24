require 'trollop'

module SimplePerf
  module CLI
    class Status
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Display JMeter or Gatling army process status

Usage:
      simple_perf status -e ENVIRONMENT -p PROJECT_NAME
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :project, "Project name to manage", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :project, "is required but not specified" unless opts[:project]

        config = Config.new.environment opts[:environment]

        ENV['SIMPLE_DEPLOY_SSH_KEY'] = config['local_pem']
        ENV['SIMPLE_DEPLOY_SSH_USER'] = config['user']

        command = 'simple_deploy execute' +
                     ' -e ' + opts[:environment] +
                     ' -n ' + 'simple-perf-' + opts[:project] +
                     ' -c "ps -ef | grep java | grep -v grep || echo \"java process not found\""' +
                     ' -l debug'

        Shared::pretty_print `#{command}`
      end
    end
  end
end
