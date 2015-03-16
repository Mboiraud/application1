require 'rails_helper'
#require 'spec_helper'


describe PagesController do
	render_views
	
	before(:each) do 
		@basetitre = "Application de Brasco"
	end

	describe "GET 'home'" do
	
		describe "quand pas identifié" do
		
			before(:each) do
				get :home
			end
			
			it "devrait réussir" do
		   	expect(response).to be_success	
			end

			it "devrait avoir le bon titre" do
		   	expect(response.body).to have_title("#{@basetitre} | Accueil")
			end
		end
		
		describe "quand identifié" do
		
			before(:each) do
				@user = test_sign_in(FactoryGirl.create(:user))
				other_user = FactoryGirl.create(:user, :email => "user2@gmail.com")
				other_user.follow!(@user)
			end
			
			it "devrait avoir le bon compte d'auteurs et de lecteurs" do
				get :home
				expect(response.body).to have_selector("h1[class='micropost']", :text => "Quoi de neuf ?")
				expect(response.body).to have_selector("a[href='#{following_user_path(@user)}']", :text => "0 auteurs suivis")
				expect(response.body).to have_selector("a[href='#{followers_user_path(@user)}']", :text => "1 lecteur")
			end
		end
	end
	
	describe "GET 'contact'" do
    	it "devrait réussir" do
      	get 'contact'
      	expect(response).to be_success
    	end
    	
		it "devrait avoir le bon titre" do
      	get 'contact'
      	expect(response.body).to have_title("#{@basetitre} | Contact")
		end
  end

	describe "GET 'about'" do
		it "devrait réussir" do
      	get 'about'
      	expect(response).to be_success
		end
		
		it "devrait avoir le bon titre" do
      	get 'home'
      	expect(response.body).to have_title("#{@basetitre} | Accueil")
		end	
	end
	
	describe "GET 'help'" do
		it "devrait réussir" do
      	get 'help'
      	expect(response).to be_success
		end
		
		it "devrait avoir le bon titre" do
      	get 'help'
      	expect(response.body).to have_title("#{@basetitre} | Aide")
		end	
	end
end
