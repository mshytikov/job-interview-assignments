require 'spec_helper'
require 'assignment2'

describe "Assignment2" do
  describe ".fizz_buzz(value)" do
    subject { Assignment2.fizz_buzz(value) }

    context "value is not an Integer" do
      let(:value) { '1' }
      it { expect{ subject }.to raise_error(ArgumentError, "Is not an Integer") }
    end 

    context "value is multiples of three" do
      let(:value) { 9 }
      it{ should == 'Fizz' }
    end

    context "value is multiples of five" do
      let(:value) { 10 }
      it{ should == 'Buzz' }
    end

    context "value is multiples of both three and five" do
        let(:value) { 30 }
        it{ should == 'FizzBuzz' }
    end

    context "value is not  multiples of three or five" do
        let(:value) { 16 }
        it{ should == '16' }
     end

  end
end
