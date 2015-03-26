require 'rails_helper'

RSpec.describe "Microposts", :type => :feature do

	before(:each) do
		user = FactoryGirl.create(:user)
		visit signin_path
		fill_in 'Email', with: user.email
		fill_in 'Mot de passe', with: user.password
		click_button "S'identifier"
	end
	
	describe "création" do
	
		describe "échec" do
		
			it "ne devrait pas créer un nouveau micro-message" do
				visit root_path
				fill_in 'micropost_content', with: ""
				expect { click_button "Soumettre" }.not_to change(Micropost, :count)
				expect(page.body).to have_selector("div[id = 'error_explanation']")
				expect(page.body).to have_title("Application de Brasco")
			end
		end
		
		describe "succès" do
		
			it "devrait créer un nouveau micro-message" do
				content = "texte de micropessage"
				visit root_path
				fill_in 'micropost_content', with: content
				expect { click_button "Soumettre" }.to change(Micropost, :count).by(1)
				expect(page.body).to have_selector("span", :text => "#{content}")
			end
		end
	end
end
