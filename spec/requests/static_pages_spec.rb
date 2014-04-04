require 'spec_helper'
include ApplicationHelper


describe "Static pages" do

	subject { page }

	describe "Home page" do
		before { visit root_path }
	    it { should have_selector('h1',    text: 'My App') }
	    it { should have_selector('title', text: full_title('')) }
	    it { should_not have_selector 'title', text: '| Home' }
	end

	describe "Help page" do
		before { visit help_path }
		it { should have_selector('h1',    text: 'Help') }
		it { should have_selector('title', text: full_title('Help')) }
	end

	describe "About page" do
		before { visit about_path }
		it { should have_selector('h1',    text: 'About') }
		it { should have_selector('title', text: full_title('About')) }
	end

	describe "Contact page" do
		before { visit contact_path }
		it { should have_selector('h1',    text: 'Contact') }
		it { should have_selector('title', text: full_title('Contact')) }
	end


  # @ ANCIENS EXEMPLES @

  # TEST INTEGRATION WITHOUT SELECTOR
  # describe "Home page" do
  #   it "should have the content 'Home'" do
  #     visit '/static_pages/home'
  #     page.should have_content('Home')
  #   end
  # end

  # # TEST INTEGRATION USING SELECTORS
  # #  pour page Home
  # describe "Home page" do 
  #   it "should have right title 'Home'" do
  #     visit '/static_pages/home'
  #     page.should have_selector('title', :text => "Ruby on Rails Tutorial New App")
  #   end
  #   it "should have the h1 'Home'" do
  #     visit '/static_pages/home'
  #     page.should have_selector('h1', :text => 'Home')
  #   end
  #   it "should not have a custom page title" do
  #     visit '/static_pages/home'
  #     page.should_not have_selector('title', :text => '| Home')
  #   end
  # end

end
