class UsersController < ApplicationController

	before_filter :signed_in_user, only: [:index, :edit, :update]
	before_filter :correct_user,   only: [:edit, :update]

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

# page users
	def index
		@users = User.paginate(page: params[:page])
	end

# Tout ce qui est apres correspond a la methode private
	private 
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		def signed_in_user
			unless signed_in?
				store_location
				redirect_to signin_url, notice: "Connectez-vous svp."
			end
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless  current_user?(@user)
		end
end
