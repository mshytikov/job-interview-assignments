module Mer
  class Mission
    attr_reader :instructions

    def initialize(instructions)
      @instructions = instructions
    end

    class << self
      def parse(instructions_str)
        instructions = instructions_str.chars.map(&method(:parse_instruction))
        new(instructions)
      end

      private

      def parse_instruction(instruction)
        INSTRUCTIONS[instruction] ||
          fail(ArgumentError, "Invalid instruction: '#{instruction}'")
      end
    end
  end
end
