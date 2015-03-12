require 'rails_helper'

RSpec.describe MicropostsController, :type => :controller do
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
			@user = test_sign_in(FactoryGirl.create(:user))
		end
		
		describe "échec" do
		
			before(:each) do
				@attr = { :content => "" }
			end
			
			it "ne devrait pas créer de nouveau message" do
				expect { post :create, :micropost => @attr }.not_to change(Micropost, :count)
			end
			
			it "devrait retourner la page d'accueil" do
				post :create, :micropost => @attr
				expect(response).to render_template('pages/home')
			end
		end
		
		describe "succès" do
		
			before(:each) do
				@attr = { :content => "le tweet de brasco" }
			end
			
			it "devrait créer un micro-message" do
				expect { post :create, :micropost => @attr }.to change(Micropost, :count).by(1)
			end
			
			it "devrait rediriger vers la page d'accueil" do
				post :create, :micropost => @attr
				expect(response).to redirect_to(root_path)
			end
			
			it "devrait avoir un message flash" do
				post :create, :micropost => @attr
				expect(flash[:success]).to be =~ /Micropost created/i
			end	
		end
	end
	
	describe "DELETE 'destroy'" do
	
		describe "pour un utilisateur non auteur du message" do
		
			before(:each) do
				@user = FactoryGirl.create(:user)
				@wrong_user = FactoryGirl.create(:user, :email => "wronguser@gmail.com")
				test_sign_in(@wrong_user)
				@micropost = FactoryGirl.create(:micropost, :user => @user)
			end
			
			it "devrait refuser la suppression du message" do
				delete :destroy, :id => @micropost
				expect(response).to redirect_to(root_path)
			end
		end
		
		describe "pour l'auteur du message" do
			
			before(:each) do 
				@user = test_sign_in(FactoryGirl.create(:user))
				@micropost = FactoryGirl.create(:micropost, :user => @user)
			end
				
			it "devrait détruire le micro message" do
				expect { delete :destroy, :id => @micropost }.to change(Micropost, :count).by(-1)
			end
		end
	end
end

