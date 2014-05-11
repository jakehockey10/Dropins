require 'spec_helper'

describe "rinks/index" do
  before(:each) do
    assign(:rinks, [
      stub_model(Rink,
        :latitude => 1.5,
        :longitude => 1.5,
        :address => "Address",
        :name => "Name"
      ),
      stub_model(Rink,
        :latitude => 1.5,
        :longitude => 1.5,
        :address => "Address",
        :name => "Name"
      )
    ])
  end

  it "renders a list of rinks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
