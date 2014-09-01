require 'spec_helper'

describe 'Static pages' do

  let(:base_title) { 'Dropins Beta' }

  subject { page }

  shared_examples_for 'all static pages' do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe 'Home page' do
    before { visit root_path }
    let(:heading) { 'Dropins beta' }
    let(:page_title) { '' }

    it_should_behave_like 'all static pages'
    it { should_not have_title('| Home') }

    describe 'for signed-in users' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: 'Lorem ipsum')
        FactoryGirl.create(:micropost, user: user, content: 'Dolor sit amet')
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe 'follower/following counts' do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link('0 following', href: following_user_path(user)) }
        it { should have_link('1 followers', href: followers_user_path(user)) }
      end
    end
  end

  describe 'Help page' do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like 'all static pages'
  end

  describe 'About page' do
    before { visit about_path }
    let(:heading) { 'About Dropins' }
    let(:page_title) { 'About Dropins' }

    it_should_behave_like 'all static pages'
  end

  describe 'Contact page' do
    before { visit contact_path }
    let(:heading) { 'Send us a message!' }
    let(:page_title) { 'Contact' }

    it_should_behave_like 'all static pages'
  end

  it 'should have the right links on the layout' do
    visit root_path
    click_link 'About'
    expect(page).to have_title(full_title('About Dropins'))
    click_link 'Help'
    expect(page).to have_title(full_title('Help'))
    click_link 'Contact'
    expect(page).to have_title(full_title('Contact Us'))
    first(:link, 'Dropins').click
    click_link 'Sign up'
    expect(page).to have_title('Sign up')
    click_link 'Dropins Beta'
    expect(page).to have_title('Dropins Beta')
  end
end