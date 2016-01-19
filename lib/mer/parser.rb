module Mer
  class Parser
    PLATEAU_SIZE_PATTERN = /\A(?<x_max>\d+) (?<y_max>\d+)\z/

    ROVER_STATE_PATTERN =
      /\A(?<x>\d+) (?<y>\d+) (?<orientation>[#{ORIENTATIONS.keys}])\z/

    MISSION_INSTRUCTIONS_PATTERN =
      /\A(?<instructions>[#{INSTRUCTIONS.keys}]+)\z/

    class << self
      def parse_file(file_path)
        read_spec = ->(f) { f.readline.chomp }
        File.open(file_path) do |f|
          plateau = parse_plateau(read_spec[f])

          loop do
            begin
              rover = parse_rover(read_spec[f])
            rescue EOFError # no more rovers in the file
              break
            end
            mission = parse_mission(read_spec[f])

            yield(plateau, rover, mission)
          end
        end
      end

      def parse_plateau(spec)
        unless spec =~ PLATEAU_SIZE_PATTERN
          fail(ArgumentError, "Invalid plateau size: '#{spec}'")
        end

        x_max = Regexp.last_match[:x_max].to_i
        y_max = Regexp.last_match[:y_max].to_i
        Plateau.new(x_max, y_max)
      end

      def parse_rover(spec)
        unless spec =~ ROVER_STATE_PATTERN
          fail(ArgumentError, "Invalid rover state: '#{spec}'")
        end

        x = Regexp.last_match[:x].to_i
        y = Regexp.last_match[:y].to_i
        orientation = ORIENTATIONS.fetch(Regexp.last_match[:orientation])

        Rover.new(x, y, orientation)
      end

      def parse_mission(spec)
        unless spec =~ MISSION_INSTRUCTIONS_PATTERN
          fail(ArgumentError, "Invalid mission instructions: '#{spec}'")
        end
        instructions = spec.chars.map { |c| INSTRUCTIONS.fetch(c) }
        Mission.new(instructions)
      end
    end
  end
end
