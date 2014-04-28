require 'spec_helper'

describe "AuthenticationPages" do

	subject { page }

	describe "signin page" do

		before { visit signin_path }
		it { should have_selector('h1', 	text: 'Se connecter') }

		describe "avec information invalide" do

			before { click_button "Se connecter" }
			it { should have_selector('title', 	text: 'Connexion') } 
			it { should have_selector('div.alert.alert-error', text: "Invalid") }
		end

		describe "avec information valide" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email",    with: user.email
				fill_in "Password", with: user.password
				click_button "Se connecter"
			end

			it { should have_selector('title', text: user.name) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Se deconnecter', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
		end
	end

end
