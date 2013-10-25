module SimplePerf
  module CLI
    module Shared

      def self.pretty_print(output)
        output.gsub!(/\r\n?/, "\n")

        output.each_line { |line|
          puts line.split(" : ")[1] unless line.to_s.include? "tar: Ignoring unknown extended header keyword"
        }
      end

    end
  end
end