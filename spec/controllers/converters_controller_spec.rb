require 'spec_helper'

describe ConvertersController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'convert'" do
    shared_examples_for "successful convert request" do
      subject { response }
      it { should be_success }
      its("body") { should == expected_body.to_json }
    end

    describe "succesfull cases" do
      context "with one value" do
        let(:expected_body) {
          {
            from:   :celsius,
            to:     :fahrenheit,
            values: { 5 => 41 }
          }
        }
        before { get 'convert', { format: 'json', from: 'celsius', to: 'fahrenheit', values: "5" } }
        it_behaves_like "successful convert request"
      end

      context "with multiple value" do
        let(:expected_body) {
          {
            from:   :celsius,
            to:     :fahrenheit,
            values: { 4 =>  41, 0 => 32 }
          }
        }
        before { get 'convert', { format: 'json', from: 'celsius', to: 'fahrenheit', values: "5, 0" } }
        it_behaves_like "successful convert request"

      end
    end

    describe "unsuccessful cases" do
      context "with invalid 'values' parameter" do
        it "raise error" do
          expect{
            get 'convert', { format: 'json', from: 'celsius', to: 'fahrenheit', values: "abc" } 
          }.to raise_error ArgumentError
        end
      end

      context "without required  params" do
        context "without 'from' " do
          it "raise error" do
            expect{
              get 'convert', { format: 'json',  to: 'celsius', values: "1" } 
            }.to raise_error  ActionController::ParameterMissing
          end
        end
        context "without 'to' " do
          it "raise error" do
            expect{
              get 'convert', { format: 'json', from: 'celsius', values: "1" } 
            }.to raise_error  ActionController::ParameterMissing
          end
        end

        context "without 'values' " do
          it "raise error" do
            expect{
              get 'convert', { format: 'json', form: 'fahrenheit', to: 'celsius'} 
            }.to raise_error  ActionController::ParameterMissing
          end
        end
      end

    end
  end
end
