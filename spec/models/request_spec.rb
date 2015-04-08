# == Schema Information
#
# Table name: requests
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  category    :string(255)
#  content     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  group       :string(255)
#

require 'rails_helper'

RSpec.describe Request, :type => :model do
	before(:each) do
		@user = FactoryGirl.create(:user)
		@friend = FactoryGirl.create(:user, :nom => "jeanmichelami", :email => "jma@gmail.com")
		@content = "la request de la detente" 
		@user.friendships.create(:friend_id => @friend.id, :status => "accepted")
	end
	
	it "dervait créer une instance request avec les bons attributs" do
		Request.create!(:sender_id => @user.id, :receiver_id => @friend.id, :content => @content, :category => "Film", :group => "new")
	end
	
	describe "associations avec l'utilisateur" do
	
		before(:each) do
			@request = Request.create!(:sender_id => @user.id, :receiver_id => @friend.id, :content => @content, :category => "Film", :group => "new")
		end
		
		it "devrait avoir un attribut :sender" do
			expect(@request).to respond_to(:sender)
		end	
		
		it "devrait avoir un attribut :receiver" do
			expect(@request).to respond_to(:receiver)
		end	
		
		it "devrait avoir un attribut :category" do
			expect(@request).to respond_to(:category)
		end
		
		it "devrait avoir les bons utilisateurs associés" do
			expect(@request.sender_id).to eq(@user.id)
			expect(@request.receiver_id).to eq(@friend.id)
			expect(@request.sender).to eq(@user)
			expect(@request.receiver).to eq(@friend)
		end	
	end
	
	describe "validations" do
		
		before(:each) do
			@attr = { 	:sender_id => @user.id,
							:receiver_id => @friend.id,
							:content => @content,
							:category => "Film",
							:group => "new" }
		end
		
		it "devrait être valide" do
			expect(Request.new(@attr)).to be_valid
		end
		
		it "requiert un sender" do
			expect(Request.new(@attr.merge(:sender_id => nil))).not_to be_valid
		end
		
		it "requiert un sender qui existe" do
			expect(Request.new(@attr.merge(:sender_id => 3))).not_to be_valid
		end
		
		it "requiert un receiver" do
			expect(Request.new(@attr.merge(:receiver_id => nil))).not_to be_valid
		end
		
		it "requiert un receiver qui existe" do
			expect(Request.new(@attr.merge(:receiver_id => 3))).not_to be_valid
		end
		
		it "devrait rejeter un contenu trop long" do
			expect(Request.new(@attr.merge(:content => "a" * 201))).not_to be_valid
		end
		
		it "requiert une category valide" do
			expect(Request.new(@attr.merge(:category => "mauvaise cat"))).not_to be_valid
		end
		
		it "requiert un group" do
			expect(Request.new(@attr.merge(:group => nil))).not_to be_valid
		end
		
		it "requiert un group qui existe" do
			expect(Request.new(@attr.merge(:group => "mauvais group"))).not_to be_valid
		end
			
		it "devrait refuser si les deux ne sont pas amis" do
			@friendship = @user.friendships.find_by_friend_id(@friend.id)
			expect(@friendship.id).to eq(1)
			expect { @friendship.destroy }.to change(Friendship, :count).by(-1)
			expect(Request.new(@attr)).not_to be_valid
		end
	end
end
