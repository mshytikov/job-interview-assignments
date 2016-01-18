require 'spec_helper'

describe Mer::Mission do
  describe ".new" do
    let(:instructions) { [:left, :right, :move] }
    subject { described_class.new(instructions) }

    it { is_expected.to respond_to(:instructions) }
    its(:instructions) { is_expected.to eq(instructions) }
  end

  describe ".parse" do
    subject { described_class.parse(instructions_str) }

    context "with correct instructions" do
      let(:instructions_str) { "LMRL" }
      it { is_expected.to be_a(Mer::Mission) }
      its(:instructions) { is_expected.to eq([:left, :move, :right, :left]) }
    end

    context "with invalid instructions" do
      let(:instructions_str) { "LMIR" }
      it "raises error" do
        expect { subject }.to raise_error(ArgumentError, /instruction: 'I'/)
      end
    end
  end
end
