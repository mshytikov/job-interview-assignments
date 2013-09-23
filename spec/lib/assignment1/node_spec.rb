require 'spec_helper'


describe Assignment1::Node do
  def uri(path)
    "http://assignment1.droxbob.com/#{path}"
  end
  let(:node) { Assignment1::Node.new(uri(nil)) }


  describe ".new" do
    subject { node }
    it { should respond_to(:id) }
    its(:id) { should == "http://assignment1.droxbob.com/" }
    its(:children) { should == [] }
    its(:children_inputs_count) { should == 0 }

    it { should respond_to(:build) }
    it { should respond_to(:links) }
    it { should respond_to(:children) }
    it { should respond_to(:add_child) }
    it { should respond_to(:inputs_count) }
    it { should respond_to(:children_inputs_count) }
    it { should respond_to(:to_s) }
  end

  describe "#build" do


    it "respond with node" do
      expect( node.build ).to eq(node)
    end

    it "fills links" do
      expected_array = ['a.html', 'b.html', 'c.html'].map{|p| uri(p) }
      expect{ node.build }.to change{ node.links }.from(nil).to(expected_array)
    end

    it "fills input_counts" do
      expect{ node.build }.to change{ node.inputs_count }.from(nil).to(2)
    end
  end

  describe "#add_child" do
    let(:child) { Assignment1::Node.new(uri("a.html")).build }
    it  "increases children_inputs_count" do
      expect{ node.add_child(child) }.to change{ node.children_inputs_count }.from(0).to(2)
    end

    it "adds child" do
      expect{ node.add_child(child) }.to change{ node.children }.from([]).to([child])
    end

  end
end
