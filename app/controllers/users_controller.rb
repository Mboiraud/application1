class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def new
  	@titre = "Inscription"
  	@user = User.new
  end
  
  def index
  	@titre = "Tous les utilisateurs"
  	@users = User.paginate(:page => params[:page])
  end
  
  def show
  	@user = User.find(params[:id])
  	@microposts = @user.microposts.paginate(:page => params[:page])
  	@titre = @user.nom
  end
  
  def create
  	@user = User.new(user_params)
  	if @user.save
  		sign_in @user
  		flash[:success] = "Bienvenue dans l'Application de Brasco!"
  		redirect_to @user
  	else
  		@titre = "Inscription"
  		render 'new'
  	end
  end
  
  def user_params
  	params.require(:user).permit(:nom, :email, :password, :password_confirmation)
  end

	def edit
		@titre = "Edition profil"
	end
	
	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params.require(:user).permit(:nom, :email, :password, :password_confirmation))
			flash[:success] = "Profil actualisé."
			redirect_to @user
		else
			@titre = "Edition profil"
			render 'edit'
		end
	end
	
	def destroy
    	User.find(params[:id]).destroy
    	flash[:success] = "Utilisateur supprimé."
    	redirect_to users_path
  	end
	
	private
	

		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end

end