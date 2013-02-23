require 'spec_helper'

describe Problem1 do

  describe ".letters_count" do
    it { Problem1.letters_count(1).should == 3 }
    it { Problem1.letters_count(15).should == 7 }
    it { Problem1.letters_count(342).should == 23 }
    it { Problem1.letters_count(115).should == 20 }
    it { Problem1.letters_count(42).should == 8 }
  end


end

