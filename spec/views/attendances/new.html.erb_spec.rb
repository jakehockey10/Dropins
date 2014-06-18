require 'spec_helper'

describe 'attendances/new' do
  before(:each) do
    assign(:attendance,
           stub_model(Attendance,
                      user_id: 1,
                      dropin_id: 1
    ).as_new_record)
  end

  it 'renders new attendance form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', attendances_path, 'post' do
      assert_select 'input#attendance_user_id[name=?]', 'attendance[user_id]'
      assert_select 'input#attendance_dropin_id[name=?]', 'attendance[dropin_id]'
    end
  end
end
