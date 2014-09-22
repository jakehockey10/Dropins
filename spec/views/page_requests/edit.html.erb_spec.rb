require 'spec_helper'

describe "page_requests/edit" do
  before(:each) do
    @page_request = assign(:page_request, stub_model(PageRequest,
      :path => "MyString",
      :page_duration => 1.5,
      :view_duration => 1.5,
      :db_duration => 1.5,
      :index => "MyString"
    ))
  end

  it "renders the edit page_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", page_request_path(@page_request), "post" do
      assert_select "input#page_request_path[name=?]", "page_request[path]"
      assert_select "input#page_request_page_duration[name=?]", "page_request[page_duration]"
      assert_select "input#page_request_view_duration[name=?]", "page_request[view_duration]"
      assert_select "input#page_request_db_duration[name=?]", "page_request[db_duration]"
      assert_select "input#page_request_index[name=?]", "page_request[index]"
    end
  end
end
