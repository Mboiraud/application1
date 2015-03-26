class RecommendationsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy, :new]

	def new
  		@titre = "Faire une recommendation"
  		@sent_recommendation = Recommendation.new
	end
	
	def create
		@recommendation = current_user.sent_recommendations.build(recommendation_params)
		if @recommendation.save
			flash[:sucess] = "Recommendation envoyée"
			redirect_to root_path
		else
			flash[:fail] = "Recommendation non envoyée"
		end
	end
	
	def destroy
		@recommendation = current_user.recommendations.find_by_id(params[:id])
		@recommendation.destroy
		redirect_to root_path
	end
	
	def recommendation_params
		params.require(:recommendation).permit(:content, :sender_id, :receiver_id)
	end
end