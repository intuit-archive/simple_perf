require 'trollop'
require 'aws-sdk'

module SimplePerf
  module CLI
    class DeployGatling
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Deploys Gatling test assets (user-files directory) to EC2 Gatling instances.

Usage:
      simple_perf deploy_gatling -e ENVIRONMENT -p PROJECT_NAME
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :project, "Stack name to manage", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :project, "is required but not specified" unless opts[:name]

        file_name = 'user-files.tar.gz'

        `#{'COPYFILE_DISABLE=1; export COPYFILE_DISABLE; gnutar cvzf user-files.tar.gz user-files/'}`

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

        if(config['region'] == 'us-east-1')
          s3_endpoint = 's3.amazonaws.com'
        else
          s3_endpoint = "s3-#{config['region']}.amazonaws.com"
        end

        s3 = AWS::S3.new(:s3_endpoint => s3_endpoint)

        # create a bucket
        #b = s3.buckets.create(bucket_name)

        # use existing s3 bucket
        b = s3.buckets[bucket_name] # no request made

        # upload a file
        basename = File.basename(file_name)
        o = b.objects[basename]
        o.write(:file => file_name)

        puts "Uploaded #{file_name} to:"
        puts o.public_url

        command = 'simple_deploy execute' +
                    ' -e ' + opts[:environment] +
                    ' -n ' + 'simple-perf-' + opts[:name] + '-gatling' +
                    ' -c "~/sync_gatling_files.sh"' +
                    ' -l debug'

        Shared::pretty_print `#{command}`

        command = 'simple_deploy execute' +
                            ' -e ' + opts[:environment] +
                            ' -n ' + 'simple-perf-' + opts[:name] + '-gatling' +
                            ' -c "cd ~/simple_perf_test_files; tar xvfz "' + file_name +
                            ' -l debug'

        Shared::pretty_print `#{command}`
      end
    end
  end
end
