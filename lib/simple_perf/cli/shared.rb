module SimplePerf
  module CLI
    module Shared

      def self.pretty_print(output)
        output.gsub!(/\r\n?/, "\n")

        output.each_line { |line|
          puts line.split(" : ")[1]
        }
      end

    end
  end
end