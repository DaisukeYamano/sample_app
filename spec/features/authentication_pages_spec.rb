require 'spec_helper'

feature "認証" do
  subject { page }

  context "サインインページ" do
    before { visit signin_path }
    scenario { should have_content('Sign in') }
    scenario { should have_title('Sign in') }
  end

  context "サインイン" do
    before { visit signin_path }

    context "不正な情報の場合" do
      before { click_button "Sign in" }

      scenario { should have_title('Sign in') }
      scenario { should have_error_message('Invalid') }

      context "サインインに失敗後、他のページを表示" do
        before { click_link "Home" }
        scenario { should_not have_selector('div.alert.alert-error') }
      end
    end

    context "正しい情報の場合" do
      let(:user) { create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      scenario { should have_title(user.name) }
      scenario { should have_link('Users',        href: users_path) }
      scenario { should have_link('Profile',      href: user_path(user)) }
      scenario { should have_link('Setting',     href: edit_user_path(user)) }
      scenario { should have_link('Sign out',     href: signout_path) }
      scenario { should_not have_link('Sign in',  href: signin_path)}

      context "サインアウト後" do
        before { click_link "Sign out" }
        scenario { should have_link('Sign in' )}
      end
    end
  end

  context "認証" do

    context "サインインしていないユーザー" do
      let(:user) { create(:user) }
      
      context "認証が必要なページにアクセス" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
  
        context "その後サインイン" do
          scenario { should have_title('Edit user') }
        end
      end
  
      context "ユーザーコントローラ内" do
  
        context "ユーザー編集ページを表示" do
          before { visit edit_user_path(user) }
          scenario { should have_title('Sign in') }
        end
  
        context "アップデートアクションを直接発行", type: :request do
          before { patch user_path(user) }
          scenario "サインインページへリダイレクトされること" do
            expect(response).to redirect_to(signin_path)
          end
        end
  
        context "インデックスページを表示" do
          before { visit users_path }
          scenario { should have_title('Sign in') }
        end
        
        context "フォローページを表示" do
          before { visit following_user_path(user) }
          scenario { should have_title('Sign in') }
        end
        
        context "フォロワーページを表示" do
          before { visit followers_user_path(user) }
          scenario { should have_title('Sign in') }
        end
      end

      context "リレーションシップコントローラ" do
        context "create を直接発行", type: :request do
          before { post relationships_path }
          scenario { expect(response).to redirect_to(signin_path) }
        end
        
        context "destroy を直接発行", type: :request do
          before { delete relationship_path(1) }
          scenario { expect(response).to redirect_to(signin_path) }
        end
      end
  
      context "マイクロポスト" do
  
        context "マイクロポストで" do
          context "POSTリクエストを直接発行", type: :request do
            before { post microposts_path }
            scenario "サインインページへリダイレクトされること" do
              expect(response).to redirect_to(signin_path)
            end
          end
  
          context "DELETEリクエストを直接発行", type: :request do
            before { delete micropost_path(create(:micropost)) }
            scenario "サインインページへリダイレクトされること" do
              expect(response).to redirect_to(signin_path)
            end
          end
        end
      end
  
      context "悪質なユーザー" do
        let(:user) { create(:user) }
        let(:wrong_user) { create(:user, email: "wrong@example.com") }
        before { sign_in user, no_capybara: true }
  
        context "GETリクエストを直接発行した場合", type: :request do
          before { get edit_user_path(wrong_user) }
          scenario "ルートページへリダイレクトされること" do
            expect(response.body).not_to match(full_title('Edit user'))
            expect(response).to redirect_to(root_path)
          end
        end
  
        context "PATCHリクエストを直接発行した場合", type: :request do
          before { patch user_path(wrong_user) }
          scenario "ルートページへリダイレクトされること" do
            expect(response).to redirect_to(root_path)
          end
        end
      end
  
      context "フレンドリーフォワーディング" do
        let(:user) { create(:user) }
        before do
          visit edit_user_path(user)
          sign_in user
        end
  
        scenario "ユーザー編集ページを表示" do
          expect(page).to have_title('Edit user')
        end
      end
  
      context "権限のないユーザー" do
        let(:user) { create(:user) }
        let(:non_admin) { create(:user) }
  
        before { sign_in non_admin, no_capybara: true }
  
        context "DELETEリクエストを直接発行する", type: :request do
          before { delete user_path(user) }
          scenario "ルートページにリダイレクトすること" do
            expect(response).to redirect_to(root_path)
          end
        end
      end
    end
  end
end
