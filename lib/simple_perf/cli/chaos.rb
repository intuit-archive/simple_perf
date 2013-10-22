require 'trollop'

module SimplePerf
  module CLI
    class Chaos
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Randomly terminates an instance in the specified stack

Usage:
      simple_perf chaos -e ENVIRONMENT -n STACK_NAME
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :name, "Stack name to manage", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :name, "is required but not specified" unless opts[:name]

        config = Config.new.environment opts[:environment]

        command = 'simple_deploy instances' +
                   ' -e ' + opts[:environment] +
                   ' -n ' + opts[:name]

        output = `#{command}`
        output.gsub!(/\r\n?/, "\n")
        list = output.split("\n")
        target = list.sample

        puts "Target locked: " + target

        AWS.config(
            :access_key_id => config['access_key'],
            :secret_access_key => config['secret_key'])

        ec2 = AWS::EC2.new(:region => config['region'])
        ec2.instances.each do |i|
          if i.vpc_id
            if(i.private_ip_address == target)
              puts "Terminating instance with private IP: " + target
              i.terminate
            end
          elsif
            if(i.ip_address == target)
              puts "Terminating instance with public IP: " + target
              i.terminate
            end
          end
        end
      end
    end
  end
end