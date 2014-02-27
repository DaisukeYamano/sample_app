require 'spec_helper'

feature "StaticPages" do
  context "Home pages" do
    scenario "should have the content 'Sample App'" do
       visit '/static_pages/home'
       expect(page).to have_content 'Sample App'
    end
  end
  
  context "Help page" do
    scenario "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
  end
  
  context "About page" do
    scenario "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end
  end
end
