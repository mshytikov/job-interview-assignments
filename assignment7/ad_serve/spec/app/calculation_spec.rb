require 'spec_helper' 

describe Calculation do 
  include Calculation

  let(:input) { Hash[(0..99).map{|i| ["key_#{i}", i] }] }

  describe "#pick_random_key" do

    it "picks mostly all elements" do
      picked_keys = 10000.times.map{ pick_random_key(input) }
      (input.keys - picked_keys).size.should <= 2
    end

  end

  describe "#pick_random_weighted_key" do

    it "picks mostly all elements" do
      picked_keys = 10000.times.map{ pick_random_weighted_key(input) }
      (input.keys - picked_keys).size.should <= 5
    end

    it "picks more weighted key first with high porbability" do
      input[99] = 1000
      keys_frequency = Hash.new(0)
      10000.times{|i|
        k = pick_random_weighted_key(input)
        keys_frequency[k] += 1
      }
      first_key = keys_frequency.max_by{|k,v| v}.first
      first_key.should == 99
    end

  end
end

