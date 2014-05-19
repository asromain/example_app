# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe "User pages" do

  before do
    @user = User.new(name: "Utilisateur test", email: "test@exemple.com", password: "test123", password_confirmation: "test123")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }

  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) } 
  it { should respond_to(:microposts) } 
  it { should respond_to(:feed) }

  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }

  it { should be_valid }
  it { should_not be_admin }

  # Following
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  # Pour admin
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  # Nom pas renseigné
  describe "Le nom n'est pas renseigne" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  # Nom trop long
  describe "Le nom est trop long" do
    before { @user.name = 'a'*51 }
    it { should_not be_valid }
  end

  # Format email invalide
  describe "Format email invalide" do
    it "devrait etre invalide" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  # Format email valide
  describe "Format email valide" do
    it "devrait etre valide" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  # Validation d'unicité
  describe "Email doit etre unique" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  # Mot de passe non present
  describe "Mot de passe non present" do
    before { @user.password = @user.password_confirmation = " "}
    it { should_not be_valid }
  end

  # Mot de passe ne correspond pas
  describe "Mot de passe ne correspond pas" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # Mot de passe de confirmation est nil
  describe "Mot de passe de confirmation est nil" do 
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  # Authentification
  describe "Retourne valeur authentification methode" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    # Mot de passe valide
    describe "Avec mot de passe valide" do
      it { should == found_user.authenticate(@user.password) }
    end
    # Mot de passe
    describe "Avec mot de passe invalide" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid")}
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
    # Mot de passe trop court
    describe "Mot de passe trop court" do
      short = "a" * 5
      before { @user.password = @user.password_confirmation = short}
      it { should be_invalid }
    end
  end

  # Remember token (connexion)
  describe "Se rappel de la connexion : remember_token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.dup
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil 
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }  
    end
  end
end
