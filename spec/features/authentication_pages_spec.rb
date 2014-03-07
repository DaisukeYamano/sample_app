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
    
    context "認証が必要なページにアクセスした場合" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit edit_user_path(user)
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      
      
      context "認証が必要なページが表示される" do
        scenario { should have_title('Edit user') }
      end

      context "ログアウトし再度サインイン" do
        before do
          click_link "Sign out"
          visit signin_path
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        scenario { should have_title(user.name) }
      end
    end
  end

  context "正しい情報を入力した場合" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    scenario "サインインできている" do
      expect(page).to have_title(user.name)
      expect(page).to have_link('Users', href: users_path)
      expect(page).to have_link('Profile',  href: user_path(user))
      expect(page).to have_link('Setting',  href: edit_user_path(user))
      expect(page).to have_link('Sign out', href: signout_path)
      expect(page).to_not have_link('Sign in', href: signin_path)
    end

    scenario "サインイン後、サインアウト" do
      click_link "Sign out"
      expect(page).to have_link('Sign in')      
    end
  end

  context "GET, PATCHメソッドを直接発行された場合" do
    let(:user) { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
    before { sign_in user, no_capybara: true }
    
    context "GETリクエストを直接発行", type: :request do
      before { get edit_user_path(wrong_user) }
      scenario "ルートページへリダイレクトされること" do
        expect(response.body).not_to match(full_title('Edit user'))
        expect(response).to redirect_to(root_path)
      end
    end

    context "PATCHリクエストを直接発行", type: :request do
      before { patch user_path(wrong_user) }
      scenario "ルートページへリダイレクトされること" do
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  context "フレンドリーフォワーディング" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit edit_user_path(user)
      sign_in user
    end
    
    scenario "ユーザー編集ページを表示" do
      expect(page).to have_title('Edit user')
    end    
  end
  
  context "インデックスページ" do
    subject { page }
    before { visit users_path }
    scenario { should have_title('Sign in') }
  end
  
  context "権限のないユーザー" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_admin) { FactoryGirl.create(:user) }

    before { sign_in non_admin, no_capybara: true }
    
    context "DELETEリクエストを直接発行する", type: :request do
      before { delete user_path(user) }
      scenario "ルートページにリダイレクトすること" do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
