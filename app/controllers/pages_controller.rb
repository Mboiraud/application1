class PagesController < ApplicationController
  	def home
  		@titre = "Accueil"
			if signed_in?
  				#@micropost = Micropost.new 
  				#@feed_items = current_user.feed.paginate(:page => params[:page])
  				#@recommendations = current_user.recommendations
  				@feed2_items = current_user.feed2#.paginate(:page => params[:page])
  					current_user.recommendations.each do |recom|
   					recom.changerequest
					end
  			end
  	end

  	def contact
  		@titre = "Contact"
  	end
  
  	def about
  		@titre = "À Propos"
  	end
  	
  	def todolist
  		@titre = "To do list"
  	end
end
