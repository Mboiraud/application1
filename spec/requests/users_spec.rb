require 'rails_helper'

RSpec.describe "Users", :type => :feature do

	describe "une inscription" do
	
		describe "ratée" do
			
			it "ne devrait pas créer un nouvel utilisateur" do
				visit signup_path
				fill_in 'Nom', with: ""
				fill_in 'Email', with: ""
				fill_in 'Password', with: ""
				fill_in 'Confirmation', with: ""
				expect { click_button 'Inscription' }.not_to change(User, :count)
				expect(page).to have_selector('div#error_explanation')
				expect(page).to have_selector("div[id = 'error_explanation']")
			end
		end
		
		describe "réussie" do
			
			it "devrait créer un nouvel utilisateur" do
				visit signup_path
				fill_in 'Nom', with: "maxboir"
				fill_in 'Email', with: "maxboir@gmail.com"
				fill_in 'Password', with: "secret"
				fill_in 'Confirmation', with: "secret"
				expect { click_button 'Inscription' }.to change(User, :count).by(1)
				expect(page).to have_selector('div.flash.success')
			end
		end
	end
	
	describe "indentification/déconnexion" do
	
		describe "l'échec" do
			it "ne devrait pas identifier l'utilisateur" do
				visit home_path
				click_link "S'identifier"
				fill_in 'Email', with: ""
				fill_in 'Mot de passe', with: ""
				click_button "S'identifier"
				expect(page).to have_selector("div[class='flash error']", :text => "Combinaison Email/mot de passe invalide.")
			end
		end
		
		describe "le succès" do
			it "devrait identifier un utilisateur puis le déconnecter" do
				@user = FactoryGirl.create(:user)
				visit home_path
				click_link "S'identifier"
				fill_in 'Email', with: @user.email
				fill_in 'Mot de passe', with: @user.password
				click_button "S'identifier"
				expect(page).to have_title("Application de Brasco | #{@user.nom}")
				click_link "Déconnexion"
				expect(page).to have_title("Application de Brasco | Accueil")		
			end
		end
	end
end


