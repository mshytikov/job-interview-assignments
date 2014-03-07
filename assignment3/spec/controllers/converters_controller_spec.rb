require 'spec_helper'

describe ConvertersController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'convert'" do
    shared_examples_for "successful convert response" do
      subject { response }
      it { should be_success }
      its("body") { should == expected_body.to_json }
    end

    shared_examples_for "invalid parameter response" do
      subject { response }
      its(:status) { should == 422 }
      its("body") { should == expected_body.to_json }
    end

    describe "succesfull cases" do
      context "with one value" do
        let(:expected_body) {
          {
            from:   :celsius,
            to:     :fahrenheit,
            values: { 5.0 => 41.0 }
          }
        }
        before { get 'convert', { format: 'json', from: 'celsius', to: 'fahrenheit', values: "5" } }
        it_behaves_like "successful convert response"
      end

      context "with multiple value" do
        let(:expected_body) {
          {
            from:   :celsius,
            to:     :fahrenheit,
            values: { 5.0 =>  41.0, 0.0 => 32.0 }
          }
        }
        before { get 'convert', { format: 'json', from: 'celsius', to: 'fahrenheit', values: "5, 0" } }
        it_behaves_like "successful convert response"

      end
    end

    describe "unsuccessful cases" do
      context "with invalid 'from' parameter" do
        let(:expected_body) { {:error => "undefined conversion from 'unknown_conversion' to 'fahrenheit'"} }
        before{ get 'convert', { format: 'json', from: 'unknown_conversion', to: 'fahrenheit', values: "1" }  }
        it_behaves_like "invalid parameter response"
      end

      context "with invalid 'to' parameter" do
        let(:expected_body) { {:error => "undefined conversion from 'celsius' to 'unknown_conversion'"} }
        before{  get 'convert', { format: 'json', from: 'celsius', to: 'unknown_conversion', values: "1" } }
        it_behaves_like "invalid parameter response"
      end

      context "with invalid 'values' parameter" do
        let(:expected_body) { {:error => 'invalid value for Float(): "abc"'} }
        before{ get 'convert', { format: 'json', from: 'celsius', to: 'fahrenheit', values: "abc" } }
        it_behaves_like "invalid parameter response"
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
