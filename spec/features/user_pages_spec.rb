# coding: utf-8

require 'spec_helper'

feature "UserPages" do
  subject { page }

  context "サインアップ" do
    before { visit signup_path }
    let(:submit) { "Create my account" }      

    scenario { should have_content('Sign up') }
    scenario { should have_title(full_title('Sign up')) }
    
    scenario "未入力で登録" do
      expect { click_button submit }.not_to change(User, :count)
      expect(page).to have_title(full_title('Sign up'))
      expect(page).to have_content('error')
    end

    scenario "情報を入力して登録" do
      expect do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
        click_button submit
      end.to change(User, :count).by(1)
  
      expect(page).to have_title('Example User')
      expect(page).to have_selector('div.alert.alert-success', text: 'Welcome')
    end
  end
  
  context "ユーザープロフィール" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
end
