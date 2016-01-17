require "mer/version"
require "mer/rover"
require "mer/plateau"

module Mer
  ORIENTATIONS = [:north, :east, :south, :west]

  # Errors
  RoverPositionError = Class.new(RuntimeError)

end
