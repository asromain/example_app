require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "Signup page" do
		before { visit signup_path }
		it { should have_selector('h1',    text: "S'inscrire") } 
		it { should have_selector('title', text: "Inscription") }
	end

	describe "Profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('h1',    text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

	describe "Signup" do

		before { visit signup_path }

		let(:submit) { "Creer mon compte" }

		describe "Avec information invalide" do
			it "sans creer un nouvel utilisateur avec .not_to" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "Avec information valide" do
			before do
				fill_in "Name", 		with: "Exemple"
				fill_in "Email",		with: "exemple@user.com"
				fill_in "Password",		with: "111111"
				fill_in "Confirmation",	with: "111111"
			end

			it "doit creer un compte" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
		end
	end
end

