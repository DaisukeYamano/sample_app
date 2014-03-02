require 'spec_helper'

feature "UserPages" do
  subject { page }

  context "Signup page" do
    before { visit signup_path }

    scenario { should have_content('Sign up') }
    scenario { should have_title(full_title('Sign up')) }
  end
end
