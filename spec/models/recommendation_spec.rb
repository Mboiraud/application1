# == Schema Information
#
# Table name: recommendations
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  content     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Recommendation, :type => :model do

	before(:each) do
		@user = FactoryGirl.create(:user)
		@friend = FactoryGirl.create(:user, :nom => "jeanmichelami", :email => "jma@gmail.com")
		@content = "la reco de la detente" 
		@user.friendships.create(:friend_id => @friend.id, :status => "accepted")
	end
	
	it "dervait créer une instance recommendation avec les bons attributs" do
		Recommendation.create!(:sender_id => @user.id, :receiver_id => @friend.id, :content => @content)
	end
	
	describe "associations avec l'utilisateur" do
	
		before(:each) do
			@recommendation = Recommendation.create!(:sender_id => @user.id, :receiver_id => @friend.id, :content => @content)
		end
		
		it "devrait avoir un attribut :sender" do
			expect(@recommendation).to respond_to(:sender)
		end	
		
		it "devrait avoir un attribut :receiver" do
			expect(@recommendation).to respond_to(:receiver)
		end	
		
		it "devrait avoir les bons utilisateurs associés" do
			expect(@recommendation.sender_id).to eq(@user.id)
			expect(@recommendation.receiver_id).to eq(@friend.id)
			expect(@recommendation.sender).to eq(@user)
			expect(@recommendation.receiver).to eq(@friend)
		end	
	end
	
	describe "validations" do
	
		it "requiert un sender" do
			expect(Recommendation.new(:sender_id => nil, :receiver_id => @friend.id, :content => @content)).not_to be_valid
		end
		
		it "requiert un sender qui existe" do
			expect(Recommendation.new(:sender_id => 3, :receiver_id => @friend.id, :content => @content)).not_to be_valid
		end
		
		it "requiert un receiver" do
			expect(Recommendation.new(:sender_id => @user.id, :content => @content)).not_to be_valid
		end
		
		it "requiert un receiver qui existe" do
			expect(Recommendation.new(:sender_id => @user.id, :receiver_id => 3, :content => @content)).not_to be_valid
		end
		
		it "requiert un contenu" do
			expect(Recommendation.new(:sender_id => @user.id, :receiver_id => @friend.id)).not_to be_valid
		end
		
		it "devrait rejeter un contenu trop long" do
			expect(Recommendation.new(:sender_id => @user.id, :receiver_id => @friend.id, :content => "a" * 201)).not_to be_valid
		end
			
		it "devrait refuser si les deux ne sont pas amis" do
			@friendship = @user.friendships.find_by_friend_id(@friend.id)
			expect(@friendship.id).to eq(1)
			expect { @friendship.destroy }.to change(Friendship, :count).by(-1)
			expect(Recommendation.new(:sender_id => @user.id, :receiver_id => @friend.id, :content => @content)).not_to be_valid
		end
	end
end
