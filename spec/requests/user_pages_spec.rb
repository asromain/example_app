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

	describe "Edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
      		sign_in user
      		visit edit_user_path(user)
    	end

		describe "page" do
			it { should have_selector('h1',    text: "Mise a jour du profil") }
			it { should have_selector('title', text: "Editer") }
			it { should have_link("Modifier",  href: 'http://gravatar.com/emails') }
		end

		describe "Avec info invalide" do
			before { click_button "Sauver" }
			it { should have_content('error') }
		end

		describe "Avec info valide" do
      		let(:new_name)  { "New Name" }
      		let(:new_email) { "new@example.com" }
      		before do
        		fill_in "Name",             with: new_name
       		 	fill_in "Email",            with: new_email
        		fill_in "Password",         with: user.password
        		fill_in "Confirm Password", with: user.password
        		click_button "Sauver"
     		end

      		it { should have_selector('title', text: new_name) }
     		it { should have_selector('div.alert.alert-success') }
     		it { should have_link('Deconnexion', href: signout_path) }
     		specify { expect(user.reload.name).to  eq new_name }
     		specify { expect(user.reload.email).to eq new_email }
   	 	end
	end

	describe "index" do
		before do
			sign_in FactoryGirl.create(:user)
			FactoryGirl.create(:user, name:"Bob", email: "bob@example.com")
			FactoryGirl.create(:user, name:"Ben", email: "ben@example.com")
			visit users_path
		end

		it { should have_selector('title', text: "Tous les utilisateurs") }
		it { should have_selector('h1',    text: "Tous les utilisateurs") }

		it "devrait lister chaque utilisateur" do
			User.all.each do |user|
				page.should have_selector('li', text: user.name)
			end
		end
	end
end

