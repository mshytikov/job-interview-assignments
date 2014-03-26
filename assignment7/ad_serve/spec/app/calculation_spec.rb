require 'spec_helper' 

describe Calculation do 
  include Calculation

  describe "#pick_random_key" do
    let(:input) { Hash[(1..50).map{|i| [i.to_s, i] }] }

    it "picks mostly all elements" do
      picked_keys = 1000.times.map{ pick_random_key(input) }
      (input.keys - picked_keys).size.should <= 2
    end
  end
end

