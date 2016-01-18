module Mer
  # Constants
  ORIENTATIONS = {
    "N" => :north,
    "E" => :east,
    "S" => :south,
    "W" => :west,
  }.freeze

  INSTRUCTIONS = {
    "M" => :move,
    "R" => :right,
    "L" => :left,
  }.freeze

  # Errors
  RoverPositionError = Class.new(RuntimeError)
end

require "mer/version"
require "mer/rover"
require "mer/plateau"
require "mer/mission"
require "mer/engine"
