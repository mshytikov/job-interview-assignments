module Mer
  class Parser
    PLATEAU_SIZE_PATTERN = /\A(?<x_max>\d+) (?<y_max>\d+)\z/

    ROVER_STATE_PATTERN =
      /\A(?<x>\d+) (?<y>\d+) (?<orientation>[#{ORIENTATIONS.keys}])\z/

    MISSION_INSTRUCTIONS_PATTERN =
      /\A(?<instructions>[#{INSTRUCTIONS.keys}]+)\z/

    class << self
      def parse_file(file_path)
        plateau = nil
        rover = nil
        mission = nil

        File.foreach(file_path) do |line|
          line = line.chomp

          unless plateau
            # performed only once for the first line in the file
            plateau = parse_plateau(line)
            next
          end

          unless rover
            rover = parse_rover(line)
            next
          end

          mission = parse_mission(line)

          yield(plateau, rover, mission)

          # reset rover
          rover = nil
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
