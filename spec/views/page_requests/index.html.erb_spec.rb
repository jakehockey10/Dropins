require 'spec_helper'

describe "page_requests/index" do
  before(:each) do
    assign(:page_requests, [
      stub_model(PageRequest,
        :path => "Path",
        :page_duration => 1.5,
        :view_duration => 1.5,
        :db_duration => 1.5,
        :index => "Index"
      ),
      stub_model(PageRequest,
        :path => "Path",
        :page_duration => 1.5,
        :view_duration => 1.5,
        :db_duration => 1.5,
        :index => "Index"
      )
    ])
  end

  it "renders a list of page_requests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Path".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Index".to_s, :count => 2
  end
end
