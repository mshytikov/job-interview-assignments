shared_examples_for "page without errors" do
  it { should_not have_selector('div.alert.alert-error') }
end
