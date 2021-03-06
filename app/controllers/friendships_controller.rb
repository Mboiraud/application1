class FriendshipsController < ApplicationController
  	before_filter :authenticate
  	before_filter :correct_user, :only => :update

  	def create
    	#@friend = User.find(friendship_params[:friend_id])
    	@friendship = current_user.friendships.create(:friend_id => friendship_params[:friend_id], :status => friendship_params[:status])
		redirect_to user_path(@friendship.friend_id)
  	end

  	def destroy
    	@friendship = current_user.friendships.find_by_id(params[:id]) || current_user.inverse_friendships.find(params[:id])
		@friendship.destroy
		redirect_to user_path(@friendship.friend_id)
  	end

	def update
		@friendship = current_user.inverse_friendships.find_by_id(params[:id])
		@friendship.update_attributes(params.require(:friendship).permit(:status))
		redirect_to user_path(@friendship.user_id)
	end
  
  	def friendship_params
		params.require(:friendship).permit(:id, :user_id, :friend_id, :status)
	end
	
	private
		
		def correct_user
			@id = Friendship.find_by_id(params[:id]).friend_id
			@user = User.find(@id)
			redirect_to(root_path) unless current_user?(@user)
		end
end

