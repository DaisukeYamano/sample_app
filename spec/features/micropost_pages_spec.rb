require 'spec_helper'

feature "マイクロポスト" do
  subject { page }

  let(:user) { create(:user) }
  before { sign_in user }
  
  context "新規作成" do
    before { visit root_path }
    
    context "間違った情報" do
      scenario "登録できないこと" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      context "エラーメッセージが表示されること" do
        before { click_button "Post" }
        scenario { should have_content('error') }
      end
    end

    context "正しい情報" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      scenario "登録できること" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  
  context "delete" do
    before do
      create(:micropost, user: user)
      visit root_path
    end
    
    scenario "削除できること" do
      expect { click_link "delete" }.to change(Micropost, :count).by(-1)
    end
  end
end
