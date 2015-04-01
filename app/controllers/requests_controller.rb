class RequestsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy, :new]

	def new
  		@titre = "Faire une demande"
  		@request = Request.new
  		@request.group = "new"
	end
	
	def create
		@request = current_user.sent_requests.build(request_params)
		if @request.save
			flash[:sucess] = "Demande envoyée"
			redirect_to root_path
		else
			#flash[:fail] = "Recommendation non envoyée"
			render '/requests/new'
		end
	end
	
	def destroy
		@request = current_user.requests.find_by_id(params[:id])
		@request.destroy
		redirect_to root_path
	end
	
	def request_params
		params.require(:request).permit(:content, :sender_id, :receiver_id, :category, :group)
	end
end
