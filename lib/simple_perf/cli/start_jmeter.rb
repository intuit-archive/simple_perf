require 'trollop'

module SimplePerf
  module CLI
    class StartJmeter
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Starts JMeter java processes.

Usage:
      simple_perf start_jmeter -e ENVIRONMENT -p PROJECT_NAME -t JMETER_TEST_PLAN
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :project, "Project name to manage", :type => :string
          opt :testplan, "JMeter Test Plan (.jmx file)", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :project, "is required but not specified" unless opts[:project]
        Trollop::die :testplan, "is required but not specified" unless opts[:testplan]

        config = Config.new.environment opts[:environment]

        ENV['SIMPLE_DEPLOY_SSH_KEY'] = config['local_pem']
        ENV['SIMPLE_DEPLOY_SSH_USER'] = config['user']

        command = 'simple_deploy execute' +
                    ' -e ' + opts[:environment] +
                    ' -n ' + 'simple-perf-' + opts[:project] +
                    ' -c "cd ~/simple_perf_test_files; nohup jmeter -Dsun.net.inetaddr.ttl=60 -n -t ' + opts[:testplan] + ' </dev/null >/dev/null 2>&1 &"' +
                    ' -l debug'

        Shared::pretty_print `#{command}`
      end
    end
  end
end
