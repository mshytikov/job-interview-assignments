require 'spec_helper'

describe Converter do

  describe ".celcius_to_fahrenheit(value)" do
    subject{ Converter.celcius_to_fahrenheit(value) }
    context "with integer value" do
      let(:value) { 1 }
      it { should == 33.8 }
    end
    context "with float value" do
      let(:value) { 1.0 }
      it { should == 33.8 }
    end
  end

  describe ".fahrenheit_to_celcius" do
    subject{ Converter.fahrenheit_to_celcius(value) }
    context "with integer value" do
      let(:value) { 1 }
      it { should == -17.2222 }
    end
    context "with float value" do
      let(:value) { 1.0 }
      it { should == -17.2222 }
    end
  end

  describe ".convert" do
    context "with supported conversion" do
      it "converts fahrenheit to celcius" do
        Converter.convert('fahrenheit', 'celcius', 1).should == -17.22222 
      end
      it "converts celcius to fahrenheit" do
        Converter.convert('fahrenheit', 'celcius', 1).should == 33.8
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


end
