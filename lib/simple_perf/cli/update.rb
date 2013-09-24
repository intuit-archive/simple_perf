require 'trollop'

module SimplePerf
  module CLI
    class Update
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Updates number of JMeter or Gatling instances.

Usage:
      simple_perf update -e ENVIRONMENT -p PROJECT_NAME -c COUNT
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :project, "Project name to manage", :type => :string
          opt :count, "Number of JMeter or Gatling instances", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :project, "is required but not specified" unless opts[:project]
        Trollop::die :count, "is required but not specified" unless opts[:count]

        command = 'simple_deploy update' +
                 ' -e ' + opts[:environment] +
                 ' -n ' + 'simple-perf-' + opts[:project] +
                 ' -a MinimumInstances=' + opts[:count] +
                 ' -a MaximumInstances=' + opts[:count]

        Shared::pretty_print `#{command}`
      end
    end
  end
end