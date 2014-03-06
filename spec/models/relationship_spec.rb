require 'spec_helper'

describe Relationship do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  describe 'follower methods' do
    it { should respond_to(:follower) }
    it { should respond_to(:followed)}
  end

  describe 'when followed_id is not present' do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe 'when follower_id is not present' do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end

  #describe "following associations" do
  #  it "should also destroy associated relationships" do
  #    temp_relationship = relationship
  #    follower.destroy
  #    expect(temp_relationship).not_to be_nil
  #    expect(Relationship.where(id: temp_relationship.id)).to be_nil
  #  end
  #end
end
