require 'spec_helper'

describe Micropost do

  let(:user) { create(:user) }
  before { @micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id) }

  subject { @micropost }
  
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  
  it { should be_valid }
  
  describe "ユーザーidがない場合" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "記事が未入力の場合" do
    before { @micropost.content =" " }
    it { should_not be_valid }
  end
  
  describe "記事が長過ぎる場合" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end
