require 'spec_helper'

describe Converter do

  describe ".celsius_to_fahrenheit(value)" do
    subject{ Converter.celsius_to_fahrenheit(value) }
    context "with integer value" do
      let(:value) { 1 }
      it { should == 33.8 }
    end
    context "with float value" do
      let(:value) { 1.0 }
      it { should == 33.8 }
    end
  end

  describe ".fahrenheit_to_celsius" do
    subject{ Converter.fahrenheit_to_celsius(value) }
    context "with integer value" do
      let(:value) { 1 }
      it { should be_within(0.0001).of(-17.2222) }
    end
    context "with float value" do
      let(:value) { 1.0 }
      it { should be_within(0.0001).of(-17.2222) }
    end
  end

  describe ".convert" do
    context "with supported conversion" do
      it "converts fahrenheit to celsius" do
        Converter.convert('fahrenheit', 'celsius', 1).should be_within(0.0001).of(-17.2222) 
      end
      it "converts celsius to fahrenheit" do
        Converter.convert('celsius', 'fahrenheit', 1).should == 33.8
      end
    end

    context "with unsupported conversion" do
      it "raise error" do
        expect{
          Converter.convert('a', 'b', 1)
        }.to raise_error ArgumentError, "undefined conversion from 'a' to 'b'"
      end
    end
  end

  describe ".types" do
    subject { Converter.types }
    it { should be_an Array}
    it { should include(['fahrenheit', 'celsius']) }
    it { should include(['celsius', 'fahrenheit']) }
  end
end
