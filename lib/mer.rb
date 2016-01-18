require "mer/version"
require "mer/rover"
require "mer/plateau"
require "mer/mission"
require "mer/engine"

module Mer
  ORIENTATIONS = [:north, :east, :south, :west].freeze

  ORIENTATION_LABELS = ORIENTATIONS.map { |x| [x, x.to_s[0].upcase] }.to_h

  INSTRUCTIONS = {
    "M" => :move,
    "R" => :right,
    "L" => :left,
  }.freeze

  # Errors
  RoverPositionError = Class.new(RuntimeError)
end
