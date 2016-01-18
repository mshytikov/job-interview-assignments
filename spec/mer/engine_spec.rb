require 'spec_helper'

describe Mer::Engine do
  let(:plateau) { Mer::Plateau.new(5, 5) }
  let(:rover) { Mer::Rover.new(1, 2, :north) }
  let(:mission) { Mer::Mission.parse("LMLMLMLMM") }
  let(:logger) { instance_double("Logger") }

  subject(:engine) {
    described_class.new(
      plateau: plateau,
      rover: rover,
      mission: mission,
      logger: logger
    )
  }

  describe "#run" do
    context "when all can be performed" do
      it "performs mission" do
        allow(logger).to receive(:info)
        expect { subject.run }
          .to change { [rover.x, rover.y, rover.orientation] }
          .from([1, 2, :north]).to([1, 3, :north])
      end

      it "otputs coordinates of rover" do
        expect(logger).to receive(:info).once.with("1 3 N")
        subject.run
      end
    end

    context "when some instructions can't be performed" do
      let(:mission) { Mer::Mission.parse("MMMMLM") }
      it "otputs warning and final coordinates of rover " do
        expect(logger)
          .to receive(:warn).once.with("Skipping instruction: move")

        expect(logger).to receive(:info).once.with("0 5 W")

        subject.run
      end
    end

    context "when some initial position of rover is invalid" do
      let(:rover) { Mer::Rover.new(6, 20, :north) }
      it "raises error" do
        expect { subject.run }.to raise_error(Mer::RoverPositionError)
      end
    end
  end
end
