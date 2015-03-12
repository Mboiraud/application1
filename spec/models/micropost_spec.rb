# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Micropost, :type => :model do

	before(:each) do
		@user = FactoryGirl.create(:user)
 		@attr = { :content => "value for content"}
 	end
 	
 	it "devrait créer une nouvelle instance avec les attributs valides" do
 		@user.microposts.create!(@attr)
 	end
 	
 	describe "associations avec l'utilisateur" do
 	
 		before(:each) do
 			@micropost = @user.microposts.create(@attr)
 		end
 		
 		it "devrait avoir un attribut user" do
 			expect(@micropost).to respond_to(:user)
 		end
 		
 		it "devrait avoir le bon utilisateur associé" do
 			expect(@micropost.user_id).to be == @user.id
 			expect(@micropost.user).to be == @user
 		end
 	end
 	
 	describe "validations" do
 	
 		it "requiert un identifiant d'utilisateur" do
 			expect(Micropost.new(@attr)).not_to be_valid
 		end
 		
 		it "requiert un contenu non vide" do
 			expect(@user.microposts.build(:content => "  ")).not_to be_valid
 		end
 		
 		it "devrait rejeter un contenu trop long" do
 			expect(@user.microposts.build(:content => "a" * 141)).not_to be_valid
 		end
 	end
end
