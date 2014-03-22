require 'spec_helper'
describe "Static pages" do

  # TEST INTEGRATION WITHOUT SELECTOR
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

  # TEST INTEGRATION USING SELECTORS
  describe "All pages with selectors" do 
    # pour page Home
    it "should have right title 'Home'" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "Ruby on Rails Tutorial Example App | Home")
    end
    it "should have the h1 'Example App'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Example App')
    end
    # pour page Help
    it "should have right title 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "Ruby on Rails Tutorial Example App | Help")
    end
    it "should have the h1 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end
    # pour page About
    it "should have right title 'A propos (about)'" do
      visit '/static_pages/about'
      page.should have_selector('title', :text => "Ruby on Rails Tutorial Example App | About")
    end
    it "should have the h1 'A propos (about)'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'A propos (about)')
    end
  end

end
