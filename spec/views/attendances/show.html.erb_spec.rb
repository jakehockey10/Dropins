require 'spec_helper'

describe "attendances/show" do
  before(:each) do
    @attendance = assign(:attendance, stub_model(Attendance,
      :user_id => 1,
      :dropin_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
