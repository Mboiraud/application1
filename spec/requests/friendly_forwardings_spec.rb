require 'rails_helper'

RSpec.describe "FriendlyForwardings", :type => :feature do

	it "devrait rediriger vers la page voulue après identification" do
		user = FactoryGirl.create(:user)
		visit edit_user_path(user)
		fill_in 'Email', with: user.email
		fill_in 'Mot de passe', with: user.password
		click_button "S'identifier"
		expect(page.body).to have_title("Keepitup | Edition profil")
	end
end
