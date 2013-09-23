require 'spec_helper'


describe Assignment1::Node do

  describe ".new" do
    let(:url) { "http://test.droxbob.com/a.html" }
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
    def uri(path)
      "http://assignment1.droxbob.com/#{path}"
    end

    let(:node) { Assignment1::Node.new(uri(nil)) }

    it "respond with true" do
      expect{ node.build }.to be_true
    end

    it "fills links" do
      expected_array = ['a.html', 'b.html', 'c.html'].map{|p| uri(p) }
      expect{ node.build }.to change{ node.links }.from(nil).to(expected_array)
    end

    it "fills input_counts" do
      expect{ node.build }.to change{ node.inputs_count }.from(nil).to(2)
    end
  end
end
