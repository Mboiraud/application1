# == Schema Information
#
# Table name: recommendations
#
#  id             :integer          not null, primary key
#  sender_id      :integer
#  receiver_id    :integer
#  content        :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  category       :string(255)
#  item           :string(255)
#  fromrequest_id :integer
#  group          :string(255)
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
		Recommendation.create!(:sender_id => @user.id, :receiver_id => @friend.id, :content => @content, :category => "Film", :item => "un titre de film", :group => "new")
	end
	
	describe "associations avec l'utilisateur" do
	
		before(:each) do
			@recommendation = Recommendation.create!(:sender_id => @user.id, :receiver_id => @friend.id, :content => @content, :category => "Film", :item => "un titre de film", :group => "new")
		end
		
		it "devrait avoir un attribut :sender" do
			expect(@recommendation).to respond_to(:sender)
		end	
		
		it "devrait avoir un attribut :receiver" do
			expect(@recommendation).to respond_to(:receiver)
		end	
		
		it "devrait avoir un attribut :category" do
			expect(@recommendation).to respond_to(:category)
		end
		
		it "devrait avoir un attribut :group" do
			expect(@recommendation).to respond_to(:group)
		end
		
		it "devrait avoir les bons utilisateurs associés" do
			expect(@recommendation.sender_id).to eq(@user.id)
			expect(@recommendation.receiver_id).to eq(@friend.id)
			expect(@recommendation.sender).to eq(@user)
			expect(@recommendation.receiver).to eq(@friend)
		end	
	end
	
	describe "validations" do
	
		before(:each) do
			@attr = { 	:sender_id => @user.id, 
							:receiver_id => @friend.id, 
							:content => @content, 
							:category => "Film" , 
							:item => "un titre de film",
							:group => "new" }
		end
		
		it "devrait être valide" do
			expect(Recommendation.new(@attr)).to be_valid
		end
		
		it "requiert un sender" do
			expect(Recommendation.new(@attr.merge(:sender_id => nil))).not_to be_valid
		end
		
		it "requiert un sender qui existe" do
			expect(Recommendation.new(@attr.merge(:sender_id => 3))).not_to be_valid
		end
		
		it "requiert un receiver" do
			expect(Recommendation.new(@attr.merge(:receiver_id => nil))).not_to be_valid
		end
		
		it "requiert un receiver qui existe" do
			expect(Recommendation.new(@attr.merge(:receiver_id => 3))).not_to be_valid
		end
		
		it "devrait rejeter un contenu trop long" do
			expect(Recommendation.new(@attr.merge(:content => "a" * 201))).not_to be_valid
		end
		
		it "requiert une category valide" do
			expect(Recommendation.new(@attr.merge(:category => "mauvaise cat"))).not_to be_valid
		end
		
		it "requiert un item" do
			expect(Recommendation.new(@attr.merge(:item => nil))).not_to be_valid
		end
		
		it "requiert un group" do
			expect(Recommendation.new(@attr.merge(:group => nil))).not_to be_valid
		end
		
		it "requiert un group valide" do
			expect(Recommendation.new(@attr.merge(:group => "mauvais groupe"))).not_to be_valid
		end
			
		it "devrait refuser si les deux ne sont pas amis" do
			@friendship = @user.friendships.find_by_friend_id(@friend.id)
			expect(@friendship.id).to eq(1)
			expect { @friendship.destroy }.to change(Friendship, :count).by(-1)
			expect(Recommendation.new(:sender_id => @user.id, :receiver_id => @friend.id, :content => @content, :item => "titre de film", :group => "new", :category => "Film")).not_to be_valid
		end
		
		describe "de l'attribut fromrequest_id" do
			
			it "devrait créer une recommandation from une request valide" do
				@request1 = Request.create!(:sender_id => @friend.id, :receiver_id => @user.id, :content => @content, :category => "Film", :group => "new")
				@reco1 = Recommendation.create!(:sender_id => @user.id, :receiver_id => @friend.id, :content => @content, :category => "Film", :item => "un titre de film", :fromrequest_id => @request1.id, :group => "new")
				@reco1.changerequest
				@request1.reload
				expect(@reco1.fromrequest_id).to eq(1)
				expect(@request1.group).to eq("old")
				expect(@request1.id).to eq(1)
			end
		end
	end
end
