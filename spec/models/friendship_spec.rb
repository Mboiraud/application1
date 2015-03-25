# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  status     :string(255)
#

require 'rails_helper'

RSpec.describe Friendship, :type => :model do

	before(:each) do
		@user = FactoryGirl.create(:user)
		@friend = FactoryGirl.create(:user, :email => "friend@gmail.com")
		@friendship = @user.friendships.build(:friend_id => @friend.id, :status => "accepted")
	end
	
	it "devrait créer une friendship" do
		@friendship.save!
	end
	
	describe "validations" do
	
		it "devrait exiger un attribut user_id" do
			@friendship.user_id = nil
			expect(@friendship).not_to be_valid
		end
		
		it "devrait exiger un attribut friend_id" do
			@friendship.friend_id = nil
			expect(@friendship).not_to be_valid
		end
		
		it "devrait exiger un attribut status" do
			@friendship.status = nil
			expect(@friendship).not_to be_valid
		end
		
		it "devrait exiger un attribut status valide" do
			@friendship.status = "mauvaisstatus"
			expect(@friendship).not_to be_valid
		end
	end
end
