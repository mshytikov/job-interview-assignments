require 'spec_helper'


describe Assignment1::Visitable do
  class Dummy
    include Assignment1::Visitable
  end

  describe "include Visitable" do
    subject(:obj) { Dummy.new }
    it{ should respond_to(:visit!) }
    it{ should respond_to(:visited?) }
    its(:visited?) { should be_false}

    describe "#.visit!(&block)" do
      it "call block with self" do
        target = nil
        expect{ obj.visit!{|e| target = e } }.to change{ target }.from(nil).to(obj);
      end
      it "change #visited? to true" do
        expect{ obj.visit!{} }.to change{ obj.visited? }.from(false).to(true);
      end

    end
  end
end
