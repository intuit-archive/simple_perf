require 'trollop'

module SimplePerf
  module CLI
    class Destroy
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Destroys CloudFormation stacks.

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

        config = Config.new.environment opts[:environment]

        AWS.config(
            :access_key_id => config['access_key'],
            :secret_access_key => config['secret_key'])

        command = 'simple_deploy list' +
            ' -e ' + opts[:environment] +
            ' | grep ' + opts[:project] + '-s3'
        bucket_stack = `#{command}`

        puts bucket_stack

        if bucket_stack.empty?
          return
        end

        command = 'simple_deploy outputs' +
            ' -e ' + opts[:environment] +
            ' -n ' + bucket_stack
        bucket_name = `#{command}`
        bucket_name = bucket_name.split(' ')[1]

        if(config['region'] == 'us-east-1')
          s3_endpoint = 's3.amazonaws.com'
        else
          s3_endpoint = "s3-#{config['region']}.amazonaws.com"
        end

        s3 = AWS::S3.new(:s3_endpoint => s3_endpoint)

        # use existing s3 bucket
        b = s3.buckets[bucket_name]

        b.objects.each do |obj|
          puts obj.key
          obj.delete
        end

        command = 'simple_deploy destroy' +
            ' -e ' + opts[:environment] +
            ' -n ' + bucket_stack

        Shared::pretty_print `#{command}`

      end
    end
  end
end