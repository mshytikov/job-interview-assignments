module Mer
  class Mission
    attr_reader :instructions

    def initialize(instructions)
      @instructions = instructions
    end
  end
end
