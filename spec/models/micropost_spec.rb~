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
 	
	describe "from_users_followed_by" do

    	before(:each) do
      	@other_user = FactoryGirl.create(:user, :email => "user2@gmail.com")
      	@third_user = FactoryGirl.create(:user, :email => "user3@gmail.com")

      	@user_post  = @user.microposts.create!(:content => "foo")
      	@other_post = @other_user.microposts.create!(:content => "bar")
      	@third_post = @third_user.microposts.create!(:content => "baz")

      	@user.follow!(@other_user)
    	end

    	it "devrait avoir une méthode de classea from_users_followed_by" do
      expect(Micropost).to respond_to(:from_users_followed_by)
    	end

    	it "devrait inclure les micro-messages des utilisateurs suivis" do
      expect(Micropost.from_users_followed_by(@user)).to include(@other_post)
    	end

    	it "devrait inclure les propres micro-messages de l'utilisateur" do
      expect(Micropost.from_users_followed_by(@user)).to include(@user_post)
    	end

    	it "ne devrait pas inclure les micro-messages des utilisateurs non suivis" do
      expect(Micropost.from_users_followed_by(@user)).not_to include(@third_post)
    	end
  	end
end
