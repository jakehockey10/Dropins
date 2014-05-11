require 'spec_helper'

describe "rinks/show" do
  before(:each) do
    @rink = assign(:rink, stub_model(Rink,
      :latitude => 1.5,
      :longitude => 1.5,
      :address => "Address",
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/Address/)
    rendered.should match(/Name/)
  end
end
