require 'spec_helper'

describe "dropins/index" do
  before(:each) do
    assign(:dropins, [
      stub_model(Dropin),
      stub_model(Dropin)
    ])
  end

  it "renders a list of dropins" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
