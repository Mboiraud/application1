require 'rails_helper'

describe "LayoutLinks", :type => :feature do

	let(:basetitre) {'Keepitup | '}

	it "devrait trouver une page Accueil à 'home'" do
      	visit 'home'
      	expect(page).to have_title(basetitre + 'Accueil')
	end
	
	it "devrait trouver une page Accueil à '/'" do
      	visit '/'
      	expect(page).to have_title(basetitre + 'Accueil')
	end

	it "devrait trouver une page A Propos à '/about'" do
      	visit '/about'
      	expect(page).to have_title(basetitre + 'À Propos')
	end
	
	it "devrait trouver une page Inscription à '/signup'" do
      	visit '/signup'
      	expect(page).to have_title(basetitre + 'Inscription')
	end
	
	describe "quand pas identifié" do
		it "devrait avoir un lien de connexion" do
			visit root_path
			expect(page).to have_selector("a[href='/signin']", :text => "S'identifier")
		end
	end
	
	describe "quand identifié" do
	
		before(:each) do
			@user = FactoryGirl.create(:user)
			visit signin_path
			fill_in 'Email', with: @user.email
			fill_in 'Mot de passe', with: @user.password
			click_button "S'identifier"
		end
		
		it "devrait avoir un lien de déconnexion" do
			visit root_path
			expect(page).to have_selector("a[href='/signout']", :text => "Déconnexion")
		end
		
		it "devrait avoir un lien vers le profil" do
			visit root_path
			expect(page).to have_selector("a[href= '#{user_path(@user)}']", :text => "profil")
		end
		
		it "devrait avoir un bouton 'recommander' foncitonnel" do
			visit '/recommendations/new'
			expect(page).to have_title(basetitre + 'Faire une recommandation')
		end
	end
end

