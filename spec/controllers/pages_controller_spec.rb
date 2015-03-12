require 'rails_helper'
#require 'spec_helper'


describe PagesController do
	render_views
	
	before(:each) do 
		@basetitre = "Application de Brasco"
	end

	describe "GET 'home'" do
		it "devrait réussir" do
      	get 'home'
      	expect(response).to be_success	
		end

		it "devrait avoir le bon titre" do
      	get 'home'
      	expect(response.body).to have_title("#{@basetitre} | Accueil")
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
