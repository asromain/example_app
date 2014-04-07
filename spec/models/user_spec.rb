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

describe User do

  before do
    @user = User.new(name: "Utilisateur test", email: "test@exemple.com")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should be_valid }

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
  describe "Format email invalite" do
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
  		user_with_same_email.save
  	end
  	it { should_not be_valid }
  end

end
