require 'trollop'
require 'aws-sdk'

module SimplePerf
  module CLI
    class GatlingResults
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Moves simulations logs from  EC2 simple_perf instances to s3 bucket for respective project.

Usage:
      simple_perf gatling_results -e ENVIRONMENT -p PROJECT_NAME
          EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :project, "Stack name to manage", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :project, "is required but not specified" unless opts[:project]


        config = Config.new.environment opts[:environment]

        ENV['SIMPLE_DEPLOY_SSH_KEY'] = config['local_pem']
        ENV['SIMPLE_DEPLOY_SSH_USER'] = config['user']

        AWS.config(
            :access_key_id => config['access_key'],
            :secret_access_key => config['secret_key'])

        command = 'simple_deploy list' +
            ' -e ' + opts[:environment] +
            ' | grep ' + opts[:project] + '-s3'
        bucket_stack = `#{command}`

        command = 'simple_deploy outputs' +
            ' -e ' + opts[:environment] +
            ' -n ' + bucket_stack
        bucket_name = `#{command}`
        bucket_name = bucket_name.split(' ')[1]


        command = 'simple_deploy execute' +
            ' -e ' + opts[:environment] +
            ' -n ' + 'simple-perf-' + opts[:project] +
            ' -c "~/sync_to_s3.sh "' + bucket_name +
            ' -l debug -x'

        Shared::pretty_print `#{command}`

      end
    end
  end
end
