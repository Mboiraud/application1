require 'rails_helper'

RSpec.describe RelationshipsController, :type => :controller do
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
      	@followed = FactoryGirl.create(:user, :email => "autree@gmail.com")
    	end

    	it "devrait créer une relation" do
        	expect { post :create, :relationship => { :followed_id => @followed } }.to change(Relationship, :count).by(1)
        	expect(response).to be_redirect 
    	end
  	end

  	describe "DELETE 'destroy'" do

    	before(:each) do
      	@user = test_sign_in(FactoryGirl.create(:user))
      	@followed = FactoryGirl.create(:user, :email => "autre@gmail.com")
      	@user.follow!(@followed)
      	@relationship = @user.relationships.find_by_followed_id(@followed)
    	end

    	it "devrait détruire une relation" do
        	expect { delete :destroy, :id => @relationship }.to change(Relationship, :count).by(-1)
        	expect(response).to be_redirect
    	end
  	end
end
