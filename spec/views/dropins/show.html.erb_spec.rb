require 'spec_helper'

describe "dropins/show" do
  before(:each) do
    @dropin = assign(:dropin, stub_model(Dropin))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
