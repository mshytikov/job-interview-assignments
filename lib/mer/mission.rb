module Mer

  class Mission

    attr_reader :instructions

    def initialize(instructions)
      @instructions = parse(instructions)
    end

    private

    def parse(instructions)
      instructions.chars.map(&method(:parse_instruction))
    end

    def parse_instruction(instruction)
      INSTRUCTIONS[instruction] ||
        fail(ArgumentError, "Invalid instruction: '#{instruction}'")
    end
  end
end
