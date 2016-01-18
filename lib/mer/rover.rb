module Mer
  class Rover
    STATE_PATTERN =
      /(?<x>\d+) (?<y>\d+) (?<orientation>[NESW])/

    DIRECTIONS = {
      north: [0, +1],
      south: [0, -1],
      east:  [+1, 0],
      west:  [-1, 0],
    }.freeze

    class << self
      def parse(state_str)
        unless state_str =~ STATE_PATTERN
          fail(ArgumentError, "Invalid rover state: '#{state_str}'")
        end

        x = Regexp.last_match[:x].to_i
        y = Regexp.last_match[:y].to_i
        orientation = ORIENTATION_LABELS.key(Regexp.last_match[:orientation])

        new(x, y, orientation)
      end
    end

    attr_reader :x, :y, :orientation

    def initialize(x, y, orientation)
      @x = x
      @y = y
      validate_orientation!(orientation)
      @orientation = orientation
    end

    def move
      (shift_x, shift_y) = DIRECTIONS[orientation]
      @x += shift_x
      @y += shift_y
    end

    def left
      rotate(-1)
    end

    def right
      rotate(+1)
    end

    def orientation_label
      ORIENTATION_LABELS[orientation]
    end

    private

    def rotate(shift)
      index = (ORIENTATIONS.index(orientation) + shift) % ORIENTATIONS.length
      @orientation = ORIENTATIONS[index]
    end

    def validate_orientation!(orientation)
      unless ORIENTATIONS.include?(orientation)
        fail(ArgumentError, "Invalid orientation: #{orientation}")
      end
    end
  end
end
