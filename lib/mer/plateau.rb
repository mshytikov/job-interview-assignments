module Mer
  class Plateau
    SIZE_PATTERN = /\A(?<x_max>\d+) (?<y_max>\d+)\z/

    class << self
      def parse(size_str)
        unless size_str =~ SIZE_PATTERN
          fail(ArgumentError, "Invalid plateau size: '#{size_str}'")
        end

        x_max = Regexp.last_match[:x_max].to_i
        y_max = Regexp.last_match[:y_max].to_i
        new(x_max, y_max)
      end
    end

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
