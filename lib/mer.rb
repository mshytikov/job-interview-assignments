require "mer/version"
require "mer/rover"
require "mer/plateau"
require "mer/mission"

module Mer
  ORIENTATIONS = [:north, :east, :south, :west]

  INSTRUCTIONS = {
    "M" => :move,
    "R" => :right,
    "L" => :left,
  }


  # Errors
  RoverPositionError = Class.new(RuntimeError)

end
