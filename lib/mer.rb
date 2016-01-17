require "mer/version"
require "mer/rover"
require "mer/plateau"
require "mer/mission"

module Mer
  ORIENTATIONS = [:north, :east, :south, :west]

  ORIENTATION_LABELS = ORIENTATIONS.map{|x| [x, x.to_s[0].upcase] }.to_h

  INSTRUCTIONS = {
    "M" => :move,
    "R" => :right,
    "L" => :left,
  }


  # Errors
  RoverPositionError = Class.new(RuntimeError)

end
