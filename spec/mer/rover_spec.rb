require 'spec_helper'

describe Mer::Rover do

  shared_examples "rotating" do |direction, rotations|
    rotations.each_pair do |current, expected|
      context "when current orientation is '#{current}'" do
        let(:orientation) { current }
        it "rotates to #{expected}" do
          expect { subject.public_send(direction) }
            .to change{ subject.orientation }.from(current).to(expected)
        end
      end
    end
  end

  let(:x) { 10 }
  let(:y) { 20 }
  let(:orientation) { :west }
  subject { described_class.new(x, y, orientation) }

  describe ".new" do
    context "with correct arguments" do
      its(:x) { is_expected.to be(x) }
      its(:y) { is_expected.to be(y) }
      its(:orientation) { is_expected.to be(orientation) }
    end

    context "with invalid orientation" do
      let(:orientation) { "west" }
      it "raises error" do
        expect { subject }.to raise_error(ArgumentError, /orientation/)
      end
    end
  end


  describe "#left" do
    it_behaves_like "rotating", :left, {
      north: :west,
      west:  :south,
      south: :east,
      east:  :north,
    }
  end

  describe "#right" do
    it_behaves_like "rotating", :right, {
      north: :east,
      east:  :south,
      south: :west,
      west:  :north,
    }
  end
end
