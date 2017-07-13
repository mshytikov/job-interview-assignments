require_relative 'engine_helper'

module Mer
  class Engine
    include EngineHelper

    def initialize(plateau:, rover:, mission:, logger:)
      @plateau = plateau
      @rover = rover
      @mission = mission
      @logger = logger
    end

    def run
      validate_rover_position!

      mission.instructions.each do |instruction|
        if can_perform_instruction?(plateau, rover, instruction)
          perform_instruction(rover, instruction)
        else
          logger.warn("Skipping instruction: #{instruction}")
        end
      end

      logger.info("#{rover.x} #{rover.y} #{rover.orientation_label}")
    end

    private

    attr_reader :plateau, :logger, :rover, :mission

    def validate_rover_position!
      unless rover_position_valid?(plateau, rover)
        fail(RoverPositionError, "Invalid postion: #{rover.inspect}")
      end
    end
  end
end
