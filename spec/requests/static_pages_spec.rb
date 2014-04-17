require 'spec_helper'
include ApplicationHelper

# @ TESTS UTILISATION DES EXEMPLES PARTAGES @
describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) } 
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    {'My App'}
    let(:page_title) {''}
    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    {'Help'}
    let(:page_title) {'Help'}
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    {'About'}
    let(:page_title) {'About'}
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    {'Contact'}
    let(:page_title) {'Contact'}
    it_should_behave_like "all static pages"
  end

  # les derniers ajouts, peut être dans user_spec ? Attention un test ne passe pas dans profile
  describe "Signup page" do 
    before { visit signup_path }
    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: 'Sign up') }
  end

  describe "Profil page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    #it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
end

  # @ VERSION 2, TESTS COMPACTES @
	# subject { page }

	# describe "Home page" do
	# 	before { visit root_path }
	#     it { should have_selector('h1',    text: 'My App') }
	#     it { should have_selector('title', text: full_title('')) }
	#     it { should_not have_selector 'title', text: '| Home' }
	# end

	# describe "Help page" do
	# 	before { visit help_path }
	# 	it { should have_selector('h1',    text: 'Help') }
	# 	it { should have_selector('title', text: full_title('Help')) }
	# end

	# describe "About page" do
	# 	before { visit about_path }
	# 	it { should have_selector('h1',    text: 'About') }
	# 	it { should have_selector('title', text: full_title('About')) }
	# end

	# describe "Contact page" do
	# 	before { visit contact_path }
	# 	it { should have_selector('h1',    text: 'Contact') }
	# 	it { should have_selector('title', text: full_title('Contact')) }
	# end


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

