require 'spec_helper'

describe Relationship do
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }
  
  subject { relationship }
  
  it { should be_valid }
  
  describe "フォロワー" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should eq follower }
    its(:followed) { should eq followed }
  end

  describe "フォローしているユーザーがいない場合" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe "フォロワーがいない場合" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
end
