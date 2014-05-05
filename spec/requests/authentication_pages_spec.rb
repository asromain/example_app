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

			it { should have_link('Users',       href: users_path) }
			it { should have_link('Profile',     href: user_path(user)) }
			it { should have_link('Settings',    href: edit_user_path(user)) }
			it { should have_link('Deconnexion', href: signout_path) }

			it { should_not have_link('Connexion', href: signin_path) }
		end
	end

	describe "autorisation" do

		describe "pour utilisateurs non connectes" do
			let(:user) { FactoryGirl.create(:user) }

			describe "dans le controleur user" do

				describe "visite de la page edit" do
					before { visit edit_user_path(user) }
					it { should have_selector('title', text: 'Connexion') }
				end

				describe "envoyer a l'action update" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end

				describe "visiting user page index" do
					before { visit users_path }
					it { should have_selector('title', text: 'Connexion') }
				end
			end

			describe "en attente de visiter page protegee" do
				before do
					visit edit_user_path(user)
					fill_in "Email",    with: user.email
					fill_in "Password", with: user.password
					click_button "Connexion"
				end

				describe "apres s'etre connecte" do
					it "devrait donner la page protegee" do
						page.should have_selector('title', text: 'Editer')
					end
				end
			end

			describe "in the microposts controller" do

				describe "submitting to the create action" do
					before { post microposts_path }
					specify { response.should redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before { delete micropost_path(FactoryGirl.create(:micropost)) }
					specify { response.should redirect_to(signin_path) }
				end
			end
 		end

		describe "mauvais utilisateurs" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user }

			describe "visite de la page Users#edit" do
				before { visit edit_user_path(wrong_user) }
				it { should_not have_selector('title', text: full_title('Mise a jour du profil')) }
			end

			describe "envoyer un PUT request a Users#update action" do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end
		end

	end 
end
