require 'trollop'

module SimplePerf
  module CLI
    class Update
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Updates CloudFormation stack parameters.

Usage:
      simple_perf update -e ENVIRONMENT -n STACK_NAME -c COUNT
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :name, "Stack name to manage", :type => :string
          opt :count, "Number of jmeter instances", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :name, "is required but not specified" unless opts[:name]
        Trollop::die :count, "is required but not specified" unless opts[:count]

        command = 'simple_deploy update' +
                 ' -e ' + opts[:environment] +
                 ' -n ' + opts[:name] +
                 ' -a MinimumInstances=' + opts[:count] +
                 ' -a MaximumInstances=' + opts[:count]

        Shared::pretty_print `#{command}`
      end
    end
  end
end