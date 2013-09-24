require 'trollop'

module SimplePerf
  module CLI
    class Destroy
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Destroys CloudFormation stack.

Usage:
      simple_perf destroy -e ENVIRONMENT -p PROJECT_NAME
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :project, "Project name to manage", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :project, "is required but not specified" unless opts[:project]

        command = 'simple_deploy destroy' +
                        ' -e ' + opts[:environment] +
                        ' -n ' + 'simple-perf-' + opts[:project]

        Shared::pretty_print `#{command}`
      end
    end
  end
end