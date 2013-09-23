require 'spec_helper'

describe Assignment1 do
  def uri(path)
    return "http://assignment1.droxbob.com" if path == :root
    "http://assignment1.droxbob.com/#{path}"
  end

  describe ".buildtree" do
    let(:root) { Assignment1.build_tree(uri(:root)) }
    let(:a_node) { root.children[0] }
    let(:b_node) { root.children[1] }
    let(:c_node) { root.children[2] }

    describe "Root node" do
      subject{ root}

      it { should be_an Node }
      its(:id) { should == uri(:root) }
      its(:inputs_count) { should == 2 }
      its(:children_inputs_count) { should == 6 }
      its("children.size") { should == 3 }

      describe "child A" do
        subject { a_node }

        it { should be_an Node }
        its(:id) { should == uri("a.html") }
        its(:inputs_count) { should == 2 }
        its(:children_inputs_count) { should == 2 }
        its("children.size") { should == 1 }

        describe "child C" do
          subject { a_node.children[0] }
          it { should == c_node }
        end
      end

      describe "child B" do
        subject { b_node }

        it { should be_an Node }
        its(:id) { should == uri("b.html") }
        its(:inputs_count) { should == 2 }
        its(:children_inputs_count) { should == 4 }
        its("children.size") { should == 2 }

        describe "child A" do
          subject { b_node.children[0] }
          it { should == a_node }
        end

        describe "child C" do
          subject { b_node.children[1] }
          it { should == c_node }
        end
      end

      describe "child C" do
        subject { c_node }

        it { should be_an Node }
        its(:id) { should == uri("c.html") }
        its(:inputs_count) { should == 2 }
        its(:children_inputs_count) { should == 0 }
        its("children.size") { should == 0 }
      end

    end
  end
end
