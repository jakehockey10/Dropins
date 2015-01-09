require 'spec_helper'

describe Attendance do

  before do
    @attendance = FactoryGirl.create(:attendance)
  end

  subject { @attendance }

  it { should respond_to(:user_id) }
  it { should respond_to(:dropin_id) }
  it { should respond_to(:paid) }

  it { should be_valid }

  describe 'when user_id is not present' do
    before { @attendance.user_id = nil }
    it { should_not be_valid }
  end

  describe 'when dropin_id is not present' do
    before { @attendance.dropin_id = nil }
    it { should_not be_valid }
  end
end