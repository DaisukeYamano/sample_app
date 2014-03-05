require 'spec_helper'

feature "認証" do
  subject { page }
  before { visit signin_path }

  scenario "ページを表示" do
    expect(page).to have_content('Sign in')
    expect(page).to have_title('Sign in')
  end

  context "情報未入力でサインインした場合" do    

    scenario "エラーメッセージが表示される" do
      click_button "Sign in"
      expect(page).to have_error_message('Invalid')      
      click_link "Home"
      expect(page).to_not have_selector('div.alert.alert-error')
    end
  end

  context "正しい情報を入力した場合" do

    let(:user) { FactoryGirl.create(:user) }
    before do
      valid_signin(user)
    end

    scenario "サインインできている" do
      expect(page).to have_title(user.name)
      expect(page).to have_link('Profile',  href: user_path(user))
      expect(page).to have_link('Sign out', href: signout_path)
      expect(page).to_not have_link('Sign in', href: signin_path)
    end

    scenario "サインイン後、サインアウト" do
      click_link "Sign out"
      expect(page).to have_link('Sign in')      
    end
  end
end
