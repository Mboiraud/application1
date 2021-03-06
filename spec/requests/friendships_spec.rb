require 'rails_helper'

RSpec.describe "Friendships", :type => :feature do

	before(:each) do
		@user = FactoryGirl.create(:user)
		@friend = FactoryGirl.create(:user, :nom => "jeanmichelami", :email => "friend@gmail.com")
		visit signin_path
		fill_in 'Email', with: @user.email
		fill_in 'Mot de passe', with: @user.password
		click_button "S'identifier"
		click_link "Utilisateur"
		click_link "jeanmichelami"
	end
	
	it "devrait ajouter une demande d'ami" do
		expect { click_button "Ajouter comme ami" }.to change(Friendship, :count).by(1)
		expect(@user).to be_pendingfriend(@user, @friend)
	end
	
	it "devrait pouvoir accepter une demande d'ami" do
		click_button "Ajouter comme ami"
		click_link "Déconnexion"
		visit signin_path
		fill_in 'Email', with: @friend.email
		fill_in 'Mot de passe', with: @friend.password	
		click_button "S'identifier"
		click_link "Utilisateur"
		first(:link, 'maxime boiraud').click
		click_button "accepter"
		expect(@friend).to be_friend(@user, @friend)
	end
end
