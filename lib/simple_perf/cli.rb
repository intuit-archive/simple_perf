require 'trollop'

require 'simple_perf/cli/shared'

require 'simple_perf/cli/stop'
require 'simple_perf/cli/destroy'
require 'simple_perf/cli/status'
require 'simple_perf/cli/results'
require 'simple_perf/cli/update'
require 'simple_perf/cli/chaos'
require 'simple_perf/cli/create_bucket'
require 'simple_perf/cli/create_jmeter'
require 'simple_perf/cli/create_gatling'
require 'simple_perf/cli/deploy'
require 'simple_perf/cli/start_jmeter'
require 'simple_perf/cli/start_gatling'
require 'simple_perf/cli/start_custom'
require 'simple_perf/cli/gatling_results'

module SimplePerf
  module CLI
    def self.start
      cmd = ARGV.shift

      case cmd
      when 'start_jmeter'
        CLI::StartJmeter.new.execute
      when 'start_gatling'
        CLI::StartGatling.new.execute
      when 'start_custom'
        CLI::StartCustom.new.execute
      when 'stop'
        CLI::Stop.new.execute
      when 'deploy'
        CLI::Deploy.new.execute
      when 'create_jmeter'
        CLI::CreateJmeter.new.execute
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
      when 'gatling_results'
        CLI::GatlingResults.new.execute
      when '-h'
        puts "simple_perf [start_jmeter|start_gatling|start_custom|stop|deploy|create_jmeter|create_gatling|create_bucket|destroy|status|results|update|chaos] [options]"
        puts "Append -h for help on specific subcommand."
      when '-v'
        puts SimplePerf::VERSION
      else
        puts "Unknown command: '#{cmd}'."
        puts "simple_perf [start_jmeter|start_gatling|start_custom|stop|deploy|create_jmeter|create_gatling|create_bucket|destroy|status|results|update|chaos] [options]"
        puts "Append -h for help on specific subcommand."
        exit 1
      end
    end

  end
end