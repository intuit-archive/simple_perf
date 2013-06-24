require 'trollop'

module SimplePerf
  module CLI
    class CreateGatling
      include Shared

      def execute
        opts = Trollop::options do
          version SimplePerf::VERSION
          banner <<-EOS

Creates CloudFormation stack for Gatling instances.

Usage:
      simple_perf create -e ENVIRONMENT -n STACK_NAME -a AMI -i INSTANCE_TYPE -s S3_BUCKET
EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :name, "Stack name to manage", :type => :string
          opt :ami, "AWS ami", :type => :string
          opt :instancetype, "AWS instance type", :type => :string
          opt :s3bucket, "AWS s3 bucket", :type => :string
        end
        Trollop::die :environment, "is required but not specified" unless opts[:environment]
        Trollop::die :name, "is required but not specified" unless opts[:name]
        Trollop::die :ami, "is required but not specified" unless opts[:ami]
        Trollop::die :instancetype, "is required but not specified" unless opts[:instancetype]
        Trollop::die :s3bucket, "is required but not specified" unless opts[:s3bucket]

        gem_root = File.expand_path '../..', __FILE__

        config = Config.new.environment opts[:environment]

        command = 'simple_deploy create' +
            ' -e ' + opts[:environment] +
            ' -n ' + opts[:name] +
            ' -t '+ gem_root + '/cloud_formation_templates/instance_group_gatling.json' +
            ' -a Description="EC2 Gatling Instance"' +
            ' -a KeyName=' +  extract_keyname(config['key']) +
            ' -a AmiId=' +  opts[:ami] +
            ' -a S3BucketName=' + opts[:s3bucket] +
            ' -a InstanceType=' + opts[:instancetype]

        Shared::pretty_print `#{command}`
      end

      def extract_keyname(fullpath_keypair)
        a = fullpath_keypair.split('/')
        a[a.length-1].sub('.pem', '')
      end

    end
  end
end