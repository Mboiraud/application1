require 'rails_helper'

RSpec.describe RequestsController, :type => :controller do
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

    	it "devrait créer une request" do
        	expect { post :create, :request => { :receiver_id => @friend, :content => "la demande", :category => "Film", :group => "new" } }.to change(Request, :count).by(1)
        	expect(response).to be_redirect 
        	req1 = @user1.sent_requests.find_by_id(1)
        	expect(req1.sender_id).to eq(@user1.id)
        	expect(req1.receiver_id).to eq(@friend.id)
        	req2 = @friend.requests.find_by_sender_id(@user1.id)
        	expect(req2.content).to eq("la demande")
    	end
  	end
  	
	describe "DELETE 'destroy'" do
	
		before(:each) do
      	@user1 = test_sign_in(FactoryGirl.create(:user))
      	@friend = FactoryGirl.create(:user, :email => "autree@gmail.com")
      	@user1.friendships.create(:friend_id => @friend.id, :status => "accepted")
      	post :create, :request => { :receiver_id => @friend, :content => "la recommendation", :category => "Film", :group => "new" }
      	@req = @friend.requests.find_by_sender_id(@user1.id)
      	test_sign_in(@friend)
    	end		
    	
    	it "devrait détruire une request" do
			expect { delete :destroy, :id => @req }.to change(Request, :count).by(-1)
  			expect(response).to be_redirect
    	end
	end
end
