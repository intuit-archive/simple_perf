module SimplePerf
  class Config

    attr_accessor :config

    def initialize(args = {})
      load_config_file
    end

    def environments
      config['environments']
    end

    def environment(name)
      raise "Environment not found" unless environments.include? name
      environments[name]
    end

    def notifications
      config['notifications']
    end

    def region(name)
      environment(name)['region']
    end

    private

    def load_config_file
      config_file = "#{ENV['HOME']}/.simple_deploy.yml"

      begin
        self.config = YAML::load( File.open( config_file ) )
      rescue Errno::ENOENT
        raise "#{config_file} not found"
      rescue Psych::SyntaxError => e
        raise "#{config_file} is corrupt"
      end
    end

    def env_home
      ENV['HOME']
    end

    def env_user
      ENV['USER']
    end

  end
end