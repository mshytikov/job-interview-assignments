require 'spec_helper'

describe Mer::Plateau do
  describe ".new" do
    let(:x_max) { 10 }
    let(:y_max) { 20 }
    subject { described_class.new(x_max, y_max) }

    its(:x_side) { is_expected.to eq(0..10) }
    its(:y_side) { is_expected.to eq(0..20) }
  end

  describe ".parse" do
    subject { described_class.parse(size_str) }

    context "with correct size" do
      let(:size_str) { "10 20" }
      it { is_expected.to be_a(Mer::Plateau) }
      its(:x_side) { is_expected.to eq(0..10) }
      its(:y_side) { is_expected.to eq(0..20) }
    end

    context "with invalid size" do
      let(:size_str) { "-1 20" }
      it { expect { subject }.to raise_error(ArgumentError, /plateau size/) }
    end
  end

  describe "#include?" do
    subject { described_class.new(10, 20).include?(x, y) }

    variations = [
      [0,  0,  true],
      [10, 20, true],
      [5,  10, true],

      [0,   -1, false],
      [10,  -1, false],
      [0,   21, false],
      [10,  21, false],

      [-1,  0, false],
      [-1, 20, false],
      [11,  0, false],
      [11, 20, false],
    ]

    variations.each do |x, y, expected|
      context "when x='#{x}' and y='#{y}'" do
        let(:x) { x }
        let(:y) { y }
        it { is_expected.to be(expected) }
      end
    end
  end
end
