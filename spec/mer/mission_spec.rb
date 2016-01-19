require 'spec_helper'

describe Mer::Mission do
  describe ".new" do
    let(:instructions) { [:left, :right, :move] }
    subject { described_class.new(instructions) }

    it { is_expected.to respond_to(:instructions) }
    its(:instructions) { is_expected.to eq(instructions) }
  end
end
