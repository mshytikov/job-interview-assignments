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

end
