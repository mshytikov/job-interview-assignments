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

  describe ".parse" do
    subject { described_class.parse(state_str) }

    context "with correct arguments" do
      let(:state_str) { "1 2 N" }
      it { is_expected.to be_a(Mer::Rover) }
      its(:x) { is_expected.to eq(1) }
      its(:y) { is_expected.to be(2) }
      its(:orientation) { is_expected.to eq(:north) }
    end

    context "with invalid orientation" do
      variations = [
        "1 2 n",
        "a 2 N",
        "1 b N",
      ]
      variations.each do |state_str|
        describe "like '#{state_str}'" do
          let(:state_str) { state_str }
          it "raises error" do
            expect { subject }.to raise_error(ArgumentError, /rover state/)
          end
        end
      end
    end
  end

  describe "#move" do
    variations =  {
      north: [0,  1],
      west:  [-1, 0],
      south: [0, -1],
      east:  [1,  0],
    }

    variations.each_pair do |orientation, expected_location|
      let(:x) { 0 }
      let(:y) { 0 }
      context "when x=0, y=0 and current orientation is '#{orientation}'" do
        let(:orientation) { orientation }
        it "moves to #{expected_location}" do
          expect { subject.move }
            .to change { [subject.x, subject.y] }
            .from([0, 0]).to(expected_location)
        end
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

  describe "#orientation_lebel" do
    variations = {
      north: "N",
      west:  "W",
      south: "S",
      east:  "E"
    }

    variations.each_pair do |orientation, expected_label|
      context "when orientation is '#{orientation}'" do
        let(:orientation) { orientation }
        its(:orientation_label) { is_expected.to eq(expected_label) }
      end
    end
  end
end
