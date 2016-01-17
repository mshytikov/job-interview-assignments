require "mer/version"
require "mer/rover"

module Mer
  ORIENTATIONS = [:north, :east, :south, :west]

  # Errors
  RoverPositionError = Class.new(RuntimeError)

end
