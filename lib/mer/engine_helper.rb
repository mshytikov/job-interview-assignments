module Mer
  module EngineHelper

    def rover_position_valid?(plateau, rover)
      plateau.include?(rover.x, rover.y)
    end

    def perform_instruction(rover, instruction)
      rover.public_send(instruction)
    end

    def can_perform_instruction?(plateu, rover, instruction)
      test_rover = rover.clone
      perform_instruction(test_rover, instruction)
      rover_position_valid?(plateu, test_rover)
    end
  end
end
