module Mer
  class Rover
    DIRECTIONS = {
      north: [0, +1],
      south: [0, -1],
      east:  [+1, 0],
      west:  [-1, 0],
    }.freeze

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
      ORIENTATIONS.key(orientation)
    end

    private

    def orientations
      ORIENTATIONS.values
    end

    def rotate(shift)
      index = (orientations.index(orientation) + shift) % orientations.length
      @orientation = orientations[index]
    end

    def validate_orientation!(orientation)
      unless orientations.include?(orientation)
        fail(ArgumentError, "Invalid orientation: #{orientation}")
      end
    end
  end
end
