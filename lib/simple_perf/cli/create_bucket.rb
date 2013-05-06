require 'trollop'

module SimplePerf
  module CLI
    class CreateBucket
      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Creates CloudFormation stack for s3 bucket.

Usage:
      simple_perf create_bucket -e ENVIRONMENT -n STACK_NAME
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :name, "Stack name to manage", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :name, "is required but not specified" unless opts[:name]

        gem_root = File.expand_path '../..', __FILE__

        config = Config.new.environment opts[:environment]

        command = 'simple_deploy create' +
            ' -e ' + opts[:environment] +
            ' -n ' + opts[:name] +
            ' -t '+ gem_root + '/cloud_formation_templates/s3_bucket.json'

        `#{command}`

        command = 'simple_deploy outputs' +
            ' -e ' + opts[:environment] +
            ' -n ' + opts[:name]

        (0..5).each do |i|
          puts "Getting s3 bucket name..."
          sleep 10
          output = `#{command}`
          if output.length > 0
            puts output
            break
          end
        end

      end
    end
  end
end