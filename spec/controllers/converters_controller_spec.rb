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

    shared_examples_for "bad convert request" do
      subject { response }
      it { should_not be_success }
      its("status") { should == 400 }
    end

    describe "succesfull cases" do
      context "with one value" do
        let(:expected_body) {
          {
            from:   :celsium,
            to:     :fahrenheit,
            values: { 5 => 41 }
          }
        }
        before { get 'convert', { from: 'celsium', to: 'fahrenheit', values: "5" } }
        it_behaves_like "successful convert request"
      end

      context "with multiple value" do
        let(:expected_body) {
          {
            from:   :celsium,
            to:     :fahrenheit,
            values: { 4 =>  41, 0 => 32 }
          }
        }
        before { get 'convert', { from: 'celsium', to: 'fahrenheit', values: "5, 0" } }
        it_behaves_like "successful convert request"

      end
    end

    describe "unsuccessful cases" do
      context "with invalid 'values' parameter" do
          before { get 'convert', { from: 'celsium', to: 'fahrenheit', values: "abc" } }
          it_behaves_like "bad convert request"
      end

      context "without required  params" do
        context "without 'from' " do
          before { get 'convert', { to: 'celsium', values: "1" } }
          it_behaves_like "bad convert request"
        end
        context "without 'to' " do
          before { get 'convert', { to: 'celsium', values: "1" } }
          it_behaves_like "bad convert request"
        end

        context "without 'values' " do
          before { get 'convert', {form: 'fahrenheit', to: 'celsium'} }
          it_behaves_like "bad convert request"
        end
      end

    end
  end
end
