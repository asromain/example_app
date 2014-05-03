class UsersController < ApplicationController

# page show.html.erb
	def show   
		@user = User.find(params[:id])
	end

# page new.html.erb
	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])  
		if @user.save
			sign_in @user
			flash[:success] = "Bienvenue sur mon site"
			redirect_to @user
		else
			render 'new'
		end
	end

# page edit.html.erb
	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "Profil mis a jour"
			sign_in @user
			redirect_to @user
		else 
			render 'edit'
		end
	end

# Tout ce qui est apres correspond a la methode private
	private 
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end
end
