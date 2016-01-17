require 'spec_helper'

describe Mer::Mission do
  subject { described_class.new(instructions) }

  describe ".new" do
    context "with correct instructions" do
      let(:instructions) { "LMRL" }
      its(:instructions) { is_expected.to eq([:left, :move, :right, :left]) }
    end

    context "with invalid instructions" do
      let(:instructions) { "LMIR" }
      it "raises error" do
        expect { subject }.to raise_error(ArgumentError, /instruction: 'I'/)
      end
    end
  end
end

