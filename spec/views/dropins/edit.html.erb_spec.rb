require 'spec_helper'

describe "dropins/edit" do
  before(:each) do
    @dropin = assign(:dropin, stub_model(Dropin))
  end

  it "renders the edit dropin form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", dropin_path(@dropin), "post" do
    end
  end
end
