require 'rails_helper'

RSpec.describe RecommendationsController, :type => :controller do
render_views

	describe "contrôle d'accès" do
	
		it "devrait refuser l'accès pour 'create'" do
			post :create
			expect(response).to redirect_to(signin_path)
		end
		
		it "devrait refuser l'accès pour 'destroy'" do
			delete :destroy, :id => 1
			expect(response).to redirect_to(signin_path)
		end
	end
	
	describe "POST 'create'" do

		before(:each) do
      	@user1 = test_sign_in(FactoryGirl.create(:user))
      	@friend = FactoryGirl.create(:user, :email => "autree@gmail.com")
      	@user1.friendships.create(:friend_id => @friend.id, :status => "accepted")
    	end

    	it "devrait créer une recommendation" do
        	expect { post :create, :recommendation => { :receiver_id => @friend, :content => "la recommendation", :category => "Film", :item => "un titre de film", :group => "new" } }.to change(Recommendation, :count).by(1)
        	expect(response).to be_redirect 
        	reco1 = @user1.sent_recommendations.find_by_id(1)
        	expect(reco1.sender_id).to eq(@user1.id)
        	expect(reco1.receiver_id).to eq(@friend.id)
        	reco2 = @friend.recommendations.find_by_sender_id(@user1.id)
        	expect(reco2.content).to eq("la recommendation")
    	end
  	end
  	
	describe "DELETE 'destroy'" do
	
		before(:each) do
      	@user1 = test_sign_in(FactoryGirl.create(:user))
      	@friend = FactoryGirl.create(:user, :email => "autree@gmail.com")
      	@user1.friendships.create(:friend_id => @friend.id, :status => "accepted")
      	post :create, :recommendation => { :receiver_id => @friend, :content => "la recommendation", :category => "Film", :item => "un titre de film", :group => "new" }
      	@reco = @friend.recommendations.find_by_sender_id(@user1.id)
      	test_sign_in(@friend)
    	end		
    	
    	it "devrait détruire une recommendation" do
			expect { delete :destroy, :id => @reco }.to change(Recommendation, :count).by(-1)
  			expect(response).to be_redirect
    	end
	end
	
	describe "Update" do
	
		before(:each) do
      	@user1 = test_sign_in(FactoryGirl.create(:user))
      	@friend = FactoryGirl.create(:user, :email => "autree@gmail.com")
      	@user1.friendships.create(:friend_id => @friend.id, :status => "accepted")
      	post :create, :recommendation => { :receiver_id => @friend, :content => "la recommendation", :category => "Film", :item => "un titre de film", :group => "new" }
      	@reco = @friend.recommendations.find_by_sender_id(@user1.id)
    	end	
    	
    	it "devrait changer le groupe en old" do
    		test_sign_in(@friend)
    		put :update, :id => @reco.id
    		@reco.reload
    		expect(@reco.group).to eq("todolist")
    	end	
	end
end
