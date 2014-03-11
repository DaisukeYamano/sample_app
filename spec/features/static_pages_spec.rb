require 'spec_helper'

feature "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    scenario { should have_content(heading) }
    scenario { should have_title(full_title(page_title)) }
  end

  context "Home pages" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    scenario { should_not have_title('| Home') }

    context "サインインユーザー" do
      let(:user) { create(:user) }
      before do
        create(:micropost, user: user, content: "Lorem ipsum")
        create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      scenario "ユーザーフィードが表示される" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      
      context "フォロワー/フォローカウント" do
        let(:other_user) { create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        
        scenario { should have_link("0 following", href: following_user_path(user)) }
        scenario { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  context "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
    
    it_should_behave_like "all static pages"
  end
  
  context "About page" do
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About' }
    
    it_should_behave_like "all static pages"
  end
  
  context "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }
    
    it_should_behave_like "all static pages"
  end

  scenario "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end
