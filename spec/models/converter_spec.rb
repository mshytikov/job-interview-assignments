require 'spec_helper'

describe Converter do

  describe ".celcius_to_fahrenheit(value)" do
    subject{ Converter.celcius_to_fahrenheit(value) }
    context "with integer value" do
      let(:value) { 1 }
      its { should == 33.8}
    end
    context "with float value" do
      let(:value) { 1.0 }
      its { should == 33.8}
    end
  end

  describe ".fahrenheit_to_celcius" do
    subject{ Converter.fahrenheit_to_celcius(value) }
    context "with integer value" do
      let(:value) { 1 }
      its { should == -17.2222}
    end
    context "with float value" do
      let(:value) { 1.0 }
      its { should == -17.2222}
    end
  end

  describe ".convert" do

  end


end
