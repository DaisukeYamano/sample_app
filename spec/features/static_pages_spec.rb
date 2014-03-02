require 'spec_helper'

feature "StaticPages" do

  subject { page }

  context "Home pages" do
    before { visit root_path }

    scenario { should have_content('Sample App') }
    scenario { should have_title(full_title('')) }
    scenario { should_not have_title('| Home') }
  end

  context "Help page" do
    before { visit help_path }
    
    scenario { should have_content('Help') }
    scenario { should have_title(full_title('Help')) }
  end
  
  context "About page" do
    before { visit about_path }

    scenario { should have_content('About Us') }
    scenario { should have_title(full_title('About')) }
  end
  
  context "Contact page" do
    before { visit contact_path }

    scenario { should have_content('Contact') }
    scenario { should have_title(full_title('Contact')) }
  end
end
