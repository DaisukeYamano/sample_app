# coding: utf-8

require 'spec_helper'

feature "ユーザーページ" do
  subject { page }
  before { visit signup_path }

  context "ユーザー登録" do

    context "無効な情報" do
      scenario "登録" do
        expect { click_button "Create my account" }.not_to change(User, :count)
        expect(page).to have_title(full_title('Sign up'))
        expect(page).to have_content('error')
      end
    end

    context "正しい情報" do
      let(:user) { build(:user) }

      scenario { should have_content('Sign up') }
      scenario { should have_title(full_title('Sign up')) }
      scenario "登録" do
        expect do
          fill_in "Name",         with: user.name
          fill_in "Email",        with: user.email
          fill_in "Password",     with: user.password
          fill_in "Confirm Password", with: user.password_confirmation
          click_button "Create my account"
        end.to change(User, :count).by(1)

        # ユーザー登録後
        expect(page).to have_link('Sign out')
        expect(page).to have_title(user.name)
        expect(page).to have_selector('div.alert.alert-success', text: 'Welcome')
      end
    end
  end

  context "profile" do
    let(:user) { create(:user) }
    let!(:m1) { create(:micropost, user_id: user.id, content: "Foo") }
    let!(:m2) { create(:micropost, user_id: user.id, content: "Bar") }
    before { visit user_path user }

    scenario { should have_content(user.name) }
    scenario { should have_title(user.name) }
    
    context "マイクロポストが表示されること" do
      scenario { should have_content(m1.content) }
      scenario { should have_content(m2.content) }
      scenario { should have_content(user.microposts.count) }
    end
  end

  context "編集" do
    let(:user) { create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    context "ページが表示されること" do
      scenario { should have_content("Update your profile") }
      scenario { should have_title("Edit user") }
      scenario { should have_link('change',href: 'http://gravatar.com/emails') }
    end

    scenario "無効な情報" do
      click_button "Save changes"
      expect(page).to have_content('error')
    end

    context "正しい情報で更新できること" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }

      scenario "更新の確認" do
        expect do
          fill_in "Name",     with: new_name
          fill_in "Email",    with: new_email
          fill_in "Password", with: user.password
          fill_in "Confirm Password", with: user.password
          click_button "Save changes"
        end.to change(User, :count).by(0)

        expect(page).to have_title(new_name)
        expect(page).to have_selector('div.alert.alert-success')
        expect(page).to have_link('Sign out', href: signout_path)
        expect(user.reload.name).to eq new_name
        expect(user.reload.email).to eq new_email
      end
    end
    
    context "編集不可項目", type: :request do
      let(:params) do
        { user: { admin: true, password: user.password, 
                    password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        path user_path(user), params
      end
      scenario { expect(user.reload).not_to be_admin }
    end
  end

  context "インデックス" do
    let(:user) { create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    scenario { should have_title('All users') }
    scenario { should have_content('All users') }

    scenario "ユーザーリストの表示" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end

    context "ページネーション" do
      before(:all) { 30.times { create(:user) } }
      after(:all) { User.delete_all }

      scenario { should have_selector('div.pagination') }
      scenario "１ページ分のユーザ" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    context "削除リンク" do
      scenario { should_not have_link('delete') }

      context "管理ユーザーの場合" do
        let(:admin) { create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
  
        scenario { should have_link('delete', href: user_path(User.first)) }
        scenario "ユーザーを削除" do
          expect { click_link('delete', match: :first) }.to change(User, :count).by(-1)
        end
        scenario { should_not have_link('delete', href: user_path(admin)) }        
      end
    end
  end
end
