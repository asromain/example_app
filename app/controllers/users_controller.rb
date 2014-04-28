class UsersController < ApplicationController

  # page show.html.erb
  def show   
  	@user = User.find(params[:id])
  end

  # page new.html.erb
  def new
  	@title = "S'inscrire"
  end
  
end
