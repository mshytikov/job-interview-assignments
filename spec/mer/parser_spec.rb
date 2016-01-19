require 'spec_helper'

describe Mer::Parser do
  describe ".parse_file" do
    let(:mission_path) { "spec/fixtures/mission.txt" }

    it "yields plateau, rover, mission" do
      expect { |b| described_class.parse_file(mission_path, &b) }.to(
        yield_successive_args(
          [Mer::Plateau, Mer::Rover, Mer::Mission],
          [Mer::Plateau, Mer::Rover, Mer::Mission]
        )
      )
    end

    it "do lazy initialization" do
      expect(Mer::Plateau).to(
        receive(:new).ordered.once.with(5, 10)
        .and_call_original
      )
      expect(Mer::Rover).to(
        receive(:new).ordered.once.with(1, 2, :north)
        .and_call_original
      )
      expect(Mer::Mission).to(
        receive(:new).ordered.once.with([:left, :move, :right])
        .and_call_original
      )
      expect(Mer::Rover).to(
        receive(:new).ordered.once.with(2, 1, :south)
        .and_call_original
      )
      expect(Mer::Mission).to(
        receive(:new).ordered.once.with([:right, :move, :left])
        .and_call_original
      )

      described_class.parse_file(mission_path) {}
    end
  end

  describe ".parse_plateau" do
    subject { described_class.parse_plateau(spec) }

    context "with correct size" do
      let(:spec) { "10 20" }
      it { is_expected.to be_a(Mer::Plateau) }
      its(:x_side) { is_expected.to eq(0..10) }
      its(:y_side) { is_expected.to eq(0..20) }
    end

    context "with invalid size" do
      let(:spec) { "-1 20" }
      it { expect { subject }.to raise_error(ArgumentError, /plateau size/) }
    end
  end

  describe ".parse_rover" do
    subject { described_class.parse_rover(spec) }

    context "with correct arguments" do
      let(:spec) { "1 2 N" }
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
          let(:spec) { state_str }
          it "raises error" do
            expect { subject }.to raise_error(ArgumentError, /rover state/)
          end
        end
      end
    end
  end

  describe ".parse_mission" do
    subject { described_class.parse_mission(spec) }

    context "with correct instructions" do
      let(:spec) { "LMRL" }
      it { is_expected.to be_a(Mer::Mission) }
      its(:instructions) { is_expected.to eq([:left, :move, :right, :left]) }
    end

    context "with invalid instructions" do
      let(:spec) { "LMIR" }
      it "raises error" do
        expect { subject }.to raise_error(ArgumentError, /mission instruction/)
      end
    end
  end
end
