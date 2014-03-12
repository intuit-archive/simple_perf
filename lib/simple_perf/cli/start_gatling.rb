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
      simple_perf start_gatling -e ENVIRONMENT -p PROJECT_NAME -s SIMULATION_NAME
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :project, "Project name to manage", :type => :string
          opt :simulation, "Gatling User simulation file (e.g. sample.SampleUserModelSimulation)", :type => :string
          opt :reports, "Pass 'nr' for no reporting.", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :project, "is required but not specified" unless opts[:project]
        Trollop::die :simulation, "is required but not specified" unless opts[:simulation]

        config = Config.new.environment opts[:environment]

        ENV['SIMPLE_DEPLOY_SSH_KEY'] = config['local_pem']
        ENV['SIMPLE_DEPLOY_SSH_USER'] = config['user']

        report = opts[:reports].to_s
        if defined?(report) && (report != '')
          report = " -#{report}"
        end

        command = 'simple_deploy execute' +
                    ' -e ' + opts[:environment] +
                    ' -n ' + 'simple-perf-' + opts[:project] +
                    ' -c "cd ~/simple_perf_test_files; nohup ./gatling.sh ' + opts[:simulation] + report + ' < input > gatling.log  &"' +
                    ' -l debug -x'

        Shared::pretty_print `#{command}`
      end
    end
  end
end
