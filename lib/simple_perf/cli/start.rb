require 'trollop'

module SimplePerf
  module CLI
    class Start
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Starts JMeter java processes.

Usage:
      simple_perf start -e ENVIRONMENT -n STACK_NAME -t JMETER_TEST_PLAN
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :name, "Stack name to manage", :type => :string
          opt :testplan, "JMeter Test Plan (.jmx file)", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :name, "is required but not specified" unless opts[:name]
        Trollop::die :testplan, "is required but not specified" unless opts[:testplan]

        config = Config.new.environment opts[:environment]

        ENV['SIMPLE_DEPLOY_SSH_KEY'] = config['local_pem']
        ENV['SIMPLE_DEPLOY_SSH_USER'] = config['user']

        command = 'simple_deploy execute' +
                    ' -e ' + opts[:environment] +
                    ' -n ' + opts[:name] +
                    ' -c "cd ~/jmeter_test_files; nohup jmeter -Dsun.net.inetaddr.ttl=60 -n -t ' + opts[:testplan] + ' </dev/null >/dev/null 2>&1 &"' +
                    ' -l debug'

        Shared::pretty_print `#{command}`
      end
    end
  end
end
