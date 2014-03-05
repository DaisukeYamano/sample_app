# coding: utf-8

require 'spec_helper'

feature "ユーザーページ" do
  subject { page }
  before { visit signup_path }
  let(:submit) { "Create my account" }

  context "情報未入力" do
    scenario "登録" do
      expect { click_button submit }.not_to change(User, :count)
      expect(page).to have_title(full_title('Sign up'))
      expect(page).to have_content('error')
    end    
  end

  context "情報入力" do
    let(:user) { FactoryGirl.build(:user) }

    scenario { should have_content('Sign up') }
    scenario { should have_title(full_title('Sign up')) }
    scenario "登録" do
      expect do
        fill_in "Name",         with: user.name
        fill_in "Email",        with: user.email
        fill_in "Password",     with: user.password
        fill_in "Confirmation", with: user.password_confirmation
        click_button submit
      end.to change(User, :count).by(1)

      # ユーザー登録後
#      user = User.find_by(email: user.email)
      expect(page).to have_link('Sign out')
      expect(page).to have_title(user.name)
      expect(page).to have_selector('div.alert.alert-success', text: 'Welcome')
    end    
  end

  context "ユーザープロフィール" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit user_path(user)
    end
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
end
