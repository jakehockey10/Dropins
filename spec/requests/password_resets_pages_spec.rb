require 'spec_helper'

describe 'Password Reset pages' do

  subject { page }

  describe 'new' do
    before { visit new_password_reset_path }

    it { should have_title('Reset Password') }
  end

  describe 'edit' do

  end

end
