require 'spec_helper'

describe "page_requests/new" do
  before(:each) do
    assign(:page_request, stub_model(PageRequest,
      :path => "MyString",
      :page_duration => 1.5,
      :view_duration => 1.5,
      :db_duration => 1.5,
      :index => "MyString"
    ).as_new_record)
  end

  it "renders new page_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", page_requests_path, "post" do
      assert_select "input#page_request_path[name=?]", "page_request[path]"
      assert_select "input#page_request_page_duration[name=?]", "page_request[page_duration]"
      assert_select "input#page_request_view_duration[name=?]", "page_request[view_duration]"
      assert_select "input#page_request_db_duration[name=?]", "page_request[db_duration]"
      assert_select "input#page_request_index[name=?]", "page_request[index]"
    end
  end
end
