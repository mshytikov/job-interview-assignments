require 'spec_helper'


describe Assignment1::Node do

  describe ".new" do
    let(:url) { "http://google.com" }
    subject { Assignment1::Node.new(url) }
    it { should respond_to(:id) }
    its(:id) { should == url }

    it { should respond_to(:build) }
    it { should respond_to(:links) }
    it { should respond_to(:childrens) }
    it { should respond_to(:add_child) }
    it { should respond_to(:inputs_count) }
    it { should respond_to(:total_inputs_count) }
    it { should respond_to(:to_s) }
  end

  describe "#build" do
    let(:url) { "http://google.com" }
    let(:node) { Assignment1::Node.new(url) }
    before { node.build }

    it "respond with true" do
      expect{ node.build }.to be_true
    end

    it "fills links" do
      expect{ node.build }.to chage(:links).from(nil).to(5)
    end

    it "fills input_counts" do
      expect{ node.build }.to chage(:input_counts).from(nil).to(10)
    end
  end
end
