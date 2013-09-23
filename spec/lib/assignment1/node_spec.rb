require 'spec_helper'


describe Assignment1::Node do

  describe ".new" do
    let(:link) { "/test.html" }
    subject { Assignment1::Node.new(link) }
    it { should respond_to(:id) }
    its(:id) { should == link }

    it { should respond_to(:build) }
    it { should respond_to(:links) }
    it { should respond_to(:childrens) }
    it { should respond_to(:add_child) }
    it { should respond_to(:inputs_count) }
    it { should respond_to(:total_inputs_count) }
    it { should respond_to(:to_s) }
  end
end
