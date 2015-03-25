require 'rails_helper'

RSpec.describe FriendshipsController, :type => :controller do
render_views

  	describe "Le contrôle d'accès" do

    	it "devrait exiger l'identification pour créer" do
      	post :create
      	expect(response).to redirect_to(signin_path)
    	end

    	it "devrait exiger l'identification pour détruire" do
      	delete :destroy, :id => 1
      	expect(response).to redirect_to(signin_path)
    	end
	end
	
	describe "POST 'create'" do

		before(:each) do
      	@user = test_sign_in(FactoryGirl.create(:user))
      	@friend = FactoryGirl.create(:user, :email => "autree@gmail.com")
    	end

    	it "devrait créer une relation 1" do
        	expect { post :create, :friendship => { :friend_id => @friend, :status => "accepted" } }.to change(Friendship, :count).by(1)
        	expect(response).to be_redirect 
    	end
  	end
  	
  	describe "DELETE 'destroy'" do
  	
  		before(:each) do
  			@user = test_sign_in(FactoryGirl.create(:user))
      	@friend = FactoryGirl.create(:user, :email => "autree@gmail.com")
      	post :create, :friendship => { :friend_id => @friend , :status => "accepted"}
      	@friendship = @user.friendships.find_by_friend_id(@friend)
      	@friendship2 = @friend.inverse_friendships.find_by_user_id(@user)
  		end
  		
  		it "devrait détruire une relation1" do
  			expect { delete :destroy, :id => @friendship }.to change(Friendship, :count).by(-1)
  			expect(response).to be_redirect
  		end
  		
  		it "devrait détruire une relation2" do
  			expect { delete :destroy, :id => @friendship2 }.to change(Friendship, :count).by(-1)
  			expect(response).to be_redirect
  		end  		
  	end
  	
  	describe "PUT 'update'" do
  	
  		before(:each) do
  			@user = test_sign_in(FactoryGirl.create(:user))
      	@friend = FactoryGirl.create(:user, :email => "autree@gmail.com")
      	@other = FactoryGirl.create(:user, :email => "autreefr@gmail.com")
      	post :create, :friendship => { :friend_id => @friend , :status => "pending"}
      	@friendship = @user.friendships.find_by_friend_id(@friend)
      	@friendship2 = @friend.inverse_friendships.find_by_user_id(@user)
  		end
  		
  		it "devrait changer la friendship" do
  			test_sign_in(@friend)
  			expect(@user).not_to be_friend(@user, @friend)
  			put :update, :id => @friendship2, :friendship => { :status => "accepted" }
  			expect(@friend).to be_friend(@user, @friend)
  		end
  		
  		it "ne devrait pas changer la friendship car mauvais utilisateur" do
  			test_sign_in(@user)
  			expect(@user).not_to be_friend(@user, @friend)
  			put :update, :id => @friendship2, :friendship => { :status => "accepted" }
  			expect(@friend).not_to be_friend(@user, @friend)
  		end
  	end
end

