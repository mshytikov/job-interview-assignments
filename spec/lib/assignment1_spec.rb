require 'spec_helper'

describe Assignment1 do
  def uri(path)
    return "http://assignment1.droxbob.com" if path == :root
    "http://assignment1.droxbob.com/#{path}"
  end

  describe ".build_tree" do
    use_vcr_cassette
    context "with deep = 3" do
      let(:root) { Assignment1.build_tree(uri(:root), 3) }
      let(:a_node) { root.children[0] }
      let(:b_node) { root.children[1] }
      let(:c_node) { root.children[2] }

      describe "Root node" do
        subject{ root }

        it { should be_an Assignment1::Node }
        its(:id) { should == uri(:root) }
        its(:inputs_count) { should == 2 }
        its(:children_inputs_count) { should == 6 }
        its("children.size") { should == 3 }

        describe "child A" do
          subject { a_node }

          it { should be_an Assignment1::Node }
          its(:id) { should == uri("a.html") }
          its(:inputs_count) { should == 2 }
          its(:children_inputs_count) { should == 2 }
          its("children.size") { should == 1 }

          describe "child C" do
            subject { a_node.children[0] }
            it "same as root child C" do 
              should be(c_node)
            end
          end
        end

        describe "child B" do
          subject { b_node }

          it { should be_an Assignment1::Node }
          its(:id) { should == uri("b.html") }
          its(:inputs_count) { should == 2 }
          its(:children_inputs_count) { should == 4 }
          its("children.size") { should == 2 }

          describe "child A" do
            subject { b_node.children[0] }
            it "same as root child A" do 
              should be(a_node)
            end
          end

          describe "child C" do
            subject { b_node.children[1] }
            it "same as root child C" do 
              should be(c_node)
            end
          end
        end

        describe "child C" do
          subject { c_node }

          it { should be_an Assignment1::Node }
          its(:id) { should == uri("c.html") }
          its(:inputs_count) { should == 2 }
          its(:children_inputs_count) { should == 2 }
          its("children.size") { should == 1 }

          describe "child D" do
            subject { c_node.children[0] }

            it { should be_an Assignment1::Node }
            its(:id) { should == uri("d.html") }
            its(:inputs_count) { should == 2 }
            its(:children_inputs_count) { should == 0 }
            its("children.size") { should == 0 }
          end
        end

      end
    end

    context "with limit = 2" do
      let(:root) { Assignment1.build_tree(uri(:root), 3, 2) }
      let(:a_node) { root.children[0] }

      describe "Root node" do
        subject{ root}

        it { should be_an Assignment1::Node }
        its(:id) { should == uri(:root) }
        its(:inputs_count) { should == 2 }
        its(:children_inputs_count) { should == 2 }
        its("children.size") { should == 1 }

        describe "child A" do
          subject { a_node }

          it { should be_an Assignment1::Node }
          its(:id) { should == uri("a.html") }
          its(:inputs_count) { should == 2 }
          its(:children_inputs_count) { should == 2 }
          its("children.size") { should == 1 }

          describe "child C" do
            let(:c_node) { a_node.children[0] }
            subject{ c_node }

            it { should be_an Assignment1::Node }
            its(:id) { should == uri("c.html") }
            its(:inputs_count) { should == 2 }
            its(:children_inputs_count) { should == 0 }
            its("children.size") { should == 0 }
          end
        end

      end
    end
  end

  describe ".solve" do
    describe "call trace" do
      use_vcr_cassette
      let(:call_trace) { [] }
      let(:visit_node) { ->(node){ call_trace << [node.id, node.inputs_count + node.children_inputs_count] } }
      subject{ call_trace }
      before{ Assignment1.solve(uri(:root), &visit_node) }
      its(:size) { should == 5}
      its([0]){ should == [uri(:root),    8 ] }
      its([1]){ should == [uri('a.html'), 4 ] }
      its([2]){ should == [uri('b.html'), 6 ] }
      its([3]){ should == [uri('c.html'), 4 ] }
      its([4]){ should == [uri('d.html'), 2 ] }
    end
  end
end

