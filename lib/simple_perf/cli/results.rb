require 'trollop'

module SimplePerf
  module CLI
    class Results
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Display JMeter log file results.

Usage:
      simple_perf results -e ENVIRONMENT -p PROJECT_NAME
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

        grep_command = %q['grep "Generate Summary Results +" /home/ec2-user/jmeter_test_files/jmeter.log | tail -n 3']

        command = 'simple_deploy execute' +
                    ' -e ' + opts[:environment] +
                    ' -n ' + 'simple-perf-' + opts[:project] +
                    ' -c ' + grep_command +
                    ' -l debug'

        Shared::pretty_print `#{command}`
      end
    end
  end
end
