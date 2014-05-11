require 'spec_helper'

describe "rinks/edit" do
  before(:each) do
    @rink = assign(:rink, stub_model(Rink,
      :latitude => 1.5,
      :longitude => 1.5,
      :address => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit rink form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", rink_path(@rink), "post" do
      assert_select "input#rink_latitude[name=?]", "rink[latitude]"
      assert_select "input#rink_longitude[name=?]", "rink[longitude]"
      assert_select "input#rink_address[name=?]", "rink[address]"
      assert_select "input#rink_name[name=?]", "rink[name]"
    end
  end
end
