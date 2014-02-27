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
end
