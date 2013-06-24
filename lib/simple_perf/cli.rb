require 'trollop'

require 'simple_perf/cli/shared'

require 'simple_perf/cli/start'
require 'simple_perf/cli/stop'
require 'simple_perf/cli/deploy'
require 'simple_perf/cli/create'
require 'simple_perf/cli/create_bucket'
require 'simple_perf/cli/destroy'
require 'simple_perf/cli/status'
require 'simple_perf/cli/results'
require 'simple_perf/cli/update'
require 'simple_perf/cli/chaos'
require 'simple_perf/cli/create_gatling'
require 'simple_perf/cli/deploy_gatling'
require 'simple_perf/cli/start_gatling'

module SimplePerf
  module CLI
    def self.start
      cmd = ARGV.shift

      case cmd
      when 'start'
        CLI::Start.new.execute
      when 'start_gatling'
        CLI::StartGatling.new.execute
      when 'stop'
        CLI::Stop.new.execute
      when 'deploy'
        CLI::Deploy.new.execute
      when 'deploy_gatling'
        CLI::DeployGatling.new.execute
      when 'create'
        CLI::Create.new.execute
      when 'create_gatling'
        CLI::CreateGatling.new.execute
      when 'create_bucket'
        CLI::CreateBucket.new.execute
      when 'destroy'
        CLI::Destroy.new.execute
      when 'status'
        CLI::Status.new.execute
      when 'results'
        CLI::Results.new.execute
      when 'update'
        CLI::Update.new.execute
      when 'chaos'
        CLI::Chaos.new.execute
      when '-h'
        puts "simple_perf [start|start_gatling|stop|deploy|deploy_gatling|create|create_gatling|create_bucket|destroy|status|results|update|chaos] [options]"
        puts "Append -h for help on specific subcommand."
      when '-v'
        puts SimplePerf::VERSION
      else
        puts "Unknown command: '#{cmd}'."
        puts "simple_perf [start|start_gatling|stop|deploy|deploy_gatling|create|create_gatling|create_bucket|destroy|status|results|update|chaos] [options]"
        puts "Append -h for help on specific subcommand."
        exit 1
      end
    end

  end
end