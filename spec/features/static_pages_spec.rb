require 'spec_helper'

feature "StaticPages" do
  
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  
  context "Home pages" do
    scenario "should have the content 'Sample App'" do
       visit '/static_pages/home'
       expect(page).to have_content 'Sample App'
    end
    
    scenario "should have a custome page title" do
      visit '/static_pages/home'
      expect(page).to have_title("#{base_title} | Home")
    end
  end
  
  context "Help page" do
    scenario "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    scenario "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title} | Help")
    end
  end
  
  context "About page" do
    scenario "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    scenario "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("#{base_title} | About")
    end
  end
end
