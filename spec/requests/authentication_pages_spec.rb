require 'spec_helper'

describe "AuthenticationPages" do

	subject { page }

	describe "signin page" do

		before { visit signin_path }

		describe "avec information invalide" do

			before { click_button "Connexion" }
			it { should have_selector('title', 	text: 'Connexion') } 
			it { should have_selector('h1', 	text: 'Se connecter') }
			it { should have_selector('div.alert.alert-error', text: "Invalid") }

			describe "Apres la visite d'une autre page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "avec information valide" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			describe "signout" do
				before { click_link 'Deconnexion' }
				it { should have_link('Connexion') }
			end

			it { should have_selector('title', text: user.name) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should have_link('Deconnexion', href: signout_path) }
			it { should_not have_link('Connexion', href: signin_path) }
		end
	end

end
