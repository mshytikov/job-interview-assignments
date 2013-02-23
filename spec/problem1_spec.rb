require 'spec_helper'

describe Problem1 do

  describe ".letters_count" do
    it { Problem1.letters_count(1).should == 3 }
    it { Problem1.letters_count(15).should == 7 }
    it { Problem1.letters_count(342).should == 23 }
    it { Problem1.letters_count(115).should == 20 }
    it { Problem1.letters_count(42).should == 8 }
    it { Problem1.letters_count(1000).should == 11 }
    it { Problem1.letters_count(100).should == 10 }
    it { expect{ Problem1.letters_count(1001) }.to raise_error(ArgumentError)}
    it { expect{ Problem1.letters_count(-1) }.to raise_error(ArgumentError)}
  end

  describe ".letters_count_till" do
    it { Problem1.letters_count_till(1000).should == 21124}
  end


end

