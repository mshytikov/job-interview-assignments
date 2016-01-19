module Mer
  class Plateau
    attr_reader :x_side, :y_side

    def initialize(x_max, y_max)
      @x_side = 0..x_max
      @y_side = 0..y_max
    end

    def include?(x, y)
      @x_side.include?(x) && @y_side.include?(y)
    end
  end
end
