require 'spec_helper'

describe "dropins/new" do
  before(:each) do
    assign(:dropin, stub_model(Dropin).as_new_record)
  end

  it "renders new dropin form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", dropins_path, "post" do
    end
  end
end
