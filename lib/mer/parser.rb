module Mer
  class Parser
    PLATEAU_SIZE_PATTERN = /\A(?<x_max>\d+) (?<y_max>\d+)\z/
    ROVER_STATE_PATTERN =
      /\A(?<x>\d+) (?<y>\d+) (?<orientation>[#{ORIENTATIONS.keys}])\z/

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
            rover = Mer::Rover.parse(line)
            next
          end

          mission = Mer::Mission.parse(line)

          yield(plateau, rover, mission)

          # reset rover
          rover = nil
        end
      end
    end
  end
end
