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
		let!(:m1)  { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		let!(:m2)  { FactoryGirl.create(:micropost, user: user, content: "Bar") }

		before { visit user_path(user) }

		it { should have_selector('h1',    text: user.name) }
		it { should have_selector('title', text: user.name) }

		describe "microposts" do
			it { should have_content(m1.content) }
			it { should have_content(m2.content) }
			it { should have_content(user.microposts.count) } 
		end
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
		
		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			sign_in user
			visit users_path
		end

		it { should have_selector('title', text: "Tous les utilisateurs") }
		it { should have_selector('h1',    text: "Tous les utilisateurs") }

		describe "pagination" do
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all)  { User.delete_all }

			it { should have_selector('div.pagination') }

			it "devrait lister chaque utilisateur" do
				User.paginate(page: 1).each do |user| 
					page.should have_selector('li', text: user.name)
				end
			end
		end

		describe "delete links" do

      		it { should_not have_link('supprimer') }

      		describe "as an admin user" do
        		let(:admin) { FactoryGirl.create(:admin) }
        			before do
          				sign_in admin
          				visit users_path
        			end

        		it { should have_link('supprimer', href: user_path(User.first)) }
        		it "should be able to delete another user" do
          			expect { click_link('supprimer') }.to change(User, :count).by(-1)
        		end
        		it { should_not have_link('supprimer', href: user_path(admin)) }
        	end
      	end

      	describe "following/followers" do
		    let(:user) { FactoryGirl.create(:user) }
		    let(:other_user) { FactoryGirl.create(:user) }
		    before { user.follow!(other_user) }

		    describe "followed users" do
		      before do
		        sign_in user
		        visit following_user_path(user)
		      end

		      it { should have_selector('h3', text: 'Following') }
		      it { should have_link(other_user.name, href: user_path(other_user)) }
		    end

		    describe "followers" do
		      before do
		        sign_in other_user
		        visit followers_user_path(other_user)
		      end

		      it { should have_selector('h3', text: 'Followers') }
		      it { should have_link(user.name, href: user_path(user)) }
		    end
  		end
	end
end

