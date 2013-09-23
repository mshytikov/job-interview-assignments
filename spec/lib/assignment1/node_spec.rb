require 'spec_helper'


describe Node do
  it { should respond_to(:build) }
  it { should respond_to(:id) }
  it { should respond_to(:links) }
  it { should respond_to(:childrens) }
  it { should respond_to(:add_child) }
  it { should respond_to(:inputs_count) }
  it { should respond_to(:total_inputs_count) }
  it { should respond_to(:to_s) }

  describe ".new" do
    let(:link) { "/test.html" }
    subject { Node.new(link) }
    its(:id) { should == link }
  end
end
