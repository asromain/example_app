require 'spec_helper'
include ApplicationHelper

# @ TESTS UTILISATION DES EXEMPLES PARTAGES @
describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) } 
  end

  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem")
      FactoryGirl.create(:micropost, user: user, content: "Ipsum")
      sign_in user
      visit root_path
    end

    it "should render the user's feed" do
      user.feed.each do |item|
        expect(page).to have_selector("li##{item.id}", text: item.content)
      end
    end

    describe "follower/following counts" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        visit root_path
      end

      it { should have_link("0 following", href: following_user_path(user)) }
      it { should have_link("1 followers", href: followers_user_path(user)) }
    end
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

