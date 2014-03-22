require 'spec_helper'
describe "Static pages" do

  describe "Home page" do
    it "should have the content 'Example App'" do
      visit '/static_pages/home'
      page.should have_content('Example App')
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
  end

  describe "About page" do
    it "should have the content 'A propos (about)'" do
      visit '/static_pages/about'
      page.should have_content('A propos (about)')
    end
  end

end
