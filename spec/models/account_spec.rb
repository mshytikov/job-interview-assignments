require 'spec_helper'

describe Account do
  describe ".new" do
    its(:balance) { should be_zero }
  end
end
