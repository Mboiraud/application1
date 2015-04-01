# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  nom                :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  
	before(:each) do
		@attr = { 	:nom => "Example User", 
						:email => "user@example.com", 
						:password => "secret", 
						:password_confirmation => "secret" }
	end

	it "devrait créer une nouvelle instance user dotée des attributs valides" do
		User.create!(@attr)
	end
	
	it "exige un nom" do
		no_name_guy = User.new(@attr.merge(:nom => ""))
		expect(no_name_guy).not_to be_valid
	end
	
	it "exige un email" do
		no_mail_guy = User.new(@attr.merge(:email => ""))
		expect(no_mail_guy).not_to be_valid
	end
	
	it "devrait rejeter les noms trop longs" do
		long_name = "a" *51
		long_name_guy = User.new(@attr.merge(:nom => long_name))
		expect(long_name_guy).not_to be_valid
	end
	
	it "devrait accepter une adresse email valide" do
		adresses = %w[user@foo.com user_ar_foo@foo.org example.user@foo.jp]
		adresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
			expect(valid_email_user).to be_valid
		end
	end

	it "devrait rejeter une adresse email invalide" do
		adresses = %w[user@foocom user_ar_foofoo.org example.user@foo.]
		adresses.each do |address|
			invalid_email_user = User.new(@attr.merge(:email => address))
			expect(invalid_email_user).not_to be_valid
		end
	end
	
	it "devrait rejeter un email double" do
		#le before each crée un user
		User.create!(@attr)
		user_with_duplicate_email = User.new(@attr)
		expect(user_with_duplicate_email).not_to be_valid
	end
	
	it "devrait rejeter une adresse email invalide jusqu'à la casse" do
		upcased_email = @attr[:email].upcase
		User.create!(@attr.merge(:email => upcased_email))
		user_with_duplicate_email = User.new(@attr)
		expect(user_with_duplicate_email).not_to be_valid
	end
	
	describe "password validation" do	
	
		it "devrait exiger un mot de passe" do
			expect(User.new(@attr.merge(:password => "", :password_confirmation => ""))).not_to be_valid
		end	
		
		it "devrait exiger une confirmation du mot de passe qui correspond" do
			expect(User.new(@attr.merge(:password_confirmation => "invalid"))).not_to be_valid
		end
		
		it "devrait rejeter les mots de passe trop longs" do
			long = "a" * 41
			expect(User.new(@attr.merge(:password => long, :password_confirmation => long))).not_to be_valid
		end
		
		it "devrait rejeter les mots de passe trop courts" do
			court = "a" * 4
			expect(User.new(@attr.merge(:password => court, :password_confirmation => court))).not_to be_valid
		end
	end
		
	describe "password encryption" do
	
		before(:each) do 
			@user = User.create!(@attr)
		end
		
		it "devrait avoir un attribut mot de passe crypté" do
			expect(@user).to respond_to(:encrypted_password)
		end
		
		it "devrait définir le mot de passe crypté" do
			expect(@user.encrypted_password).not_to be_blank
		end
		
		describe "Méthode has_password?" do
		
			it "doit retourner true si les mots de passe correspondent" do
				expect(@user.has_password?(@attr[:password])).to be_truthy
			end
			
			it "doit retourner false si les mots de passe divergent" do
				expect(@user.has_password?("invalid")).to be_falsey
			end
		end
		
		describe "authenticate method" do
		
			it "devrait retourner nul en cas d'inéquation entre email/mot de passe" do
				wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
				expect(wrong_password_user).to be_nil
			end
			
			it "devrait retourner nil quand un email ne correspond à aucun utilisateur" do
				nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
				expect(nonexistent_user).to be_nil
			end
			
			it "devrait retourner l'utilisateur si email/mot de passe correspondent" do
				good_user = User.authenticate(@attr[:email], @attr[:password])
				expect(good_user).to  eq(@user)
			end
		end
	end
	
	describe "Attribut admin" do

		before(:each) do
			@user = User.create!(@attr)
    	end

		it "devrait confirmer l'existence de `admin`" do
      	expect(@user).to respond_to(:admin)
    	end

    	it "ne devrait pas être un administrateur par défaut" do
      	expect(@user).not_to be_admin
    	end

    	it "devrait pouvoir devenir un administrateur" do
      	@user.toggle!(:admin)
      	expect(@user).to be_admin
    	end
  	end
 
=begin  	
  	describe "Les associations au micro-message" do
 	
 		before(:each) do
 			@user = User.create(@attr)
 		end
 		
 		it "devrait avoir un attribut 'microposts'" do
 			expect(@user).to respond_to(:microposts)
 		end
 	end
 	
 	describe "micropost associations" do
 		
 		before(:each) do
 			@user = User.create(@attr)
 			@mp1 = FactoryGirl.create(:micropost, :user => @user, :created_at => 1.day.ago)
 			@mp2 = FactoryGirl.create(:micropost, :user => @user, :created_at => 1.hour.ago)
 		end
 		
 		it "devrait avoir un attribut 'microposts'" do
 			expect(@user).to respond_to(:microposts)
 		end 
 		
 		it "devrait avoir les bons microposts dans le bon ordre" do
 			expect(@user.microposts).to be == [@mp2, @mp1]
 		end
 		
 		it "devrait détruire les micros messages associés" do
 			@user.destroy
 			[@mp1, @mp2].each do |micropost|
 				expect(Micropost.find_by_id(micropost.id)).to be_nil
 			end
 		end
 	end
 	
 	describe "Association micro-messages" do
 	
 		before(:each) do
 			@user = User.create(@attr)
 			@mp1 = FactoryGirl.create(:micropost, :user => @user, :created_at => 1.day.ago)
 			@mp2 = FactoryGirl.create(:micropost, :user => @user, :created_at => 1.hour.ago)
 		end
 		
 		describe "Etat de l'alimentation" do
 		
 			it "devrait avoir une méthode 'feed'" do
				expect(@user).to respond_to(:feed)
			end
		
 			it "devrait inclure les micro-messages de l'utilisateur" do
 				expect(@user.feed.include?(@mp1)).to be_truthy
 				expect(@user.feed.include?(@mp2)).to be_truthy
 			end
 			
 			it "ne devrait pas inclure les micro-messages d'un autre utilisateur" do
 				user2 = FactoryGirl.create(:user, :email => "user2@gmail.com")
 				mp3 = FactoryGirl.create(:micropost, :user => user2)
 				expect(@user.feed.include?(mp3)).not_to be_truthy
			end
 			
#relationships pour suivre des utilisateurs
 			
      	it "devrait inclure les micro-messages des utilisateurs suivis" do
        		followed = FactoryGirl.create(:user, :email => "user2@gmail.com")
        		mp3 = FactoryGirl.create(:micropost, :user => followed)
        		@user.follow!(followed)
        		expect(@user.feed).to include(mp3)
      	end

		end
 	end
=end	
 	describe "friendships" do
 		
 		before(:each) do
 			@user = User.create!(@attr)
 			@friend = FactoryGirl.create(:user)
 		end
 		
 		it "devrait avoir une méthode 'friendships'" do
 			expect(@user).to respond_to(:friendships)
 		end
 		
 		it "devrait avoir une méthode 'friends'" do
 			expect(@user).to respond_to(:friends)
 		end
 		
 		it "devrait avoir une méthode 'inverse_friendships'" do
 			expect(@user).to respond_to(:inverse_friendships)
 		end
 		
 		it "devrait avoir une méthode 'inverse_friends'" do
 			expect(@user).to respond_to(:inverse_friends)
 		end
 		
 		it "devrait ajouter un nouvel ami 1er sens" do
 			@user.friendships.create(:friend_id => @friend.id, :status => "accepted")
 			expect(@user).to be_friend(@user, @friend)
 			expect(@user.friend?(@user, @friend)).to be_truthy
 		end
 		
 		it "devrait ajouter un nouvel ami 2eme sens" do
 			@user.friendships.create(:friend_id => @friend.id, :status => "accepted")
 			expect(@friend).to be_friend(@user, @friend)
 			expect(@friend).to be_friend(@friend, @user)
 		end
 		
 		it "devrait supprimer un ami 1er sens" do
 			@user.friendships.create(:friend_id => @friend.id, :status => "accepted")
 			@user.friendships.find_by_friend_id(@friend).destroy
 			expect(@user).not_to be_friend(@user, @friend)
 		end
 		
 		it "devrait supprimer un ami 2eme sens" do
 			@user.friendships.create(:friend_id => @friend.id, :status => "accepted")
 			@friend.inverse_friendships.find_by_user_id(@user).destroy
 			expect(@user).not_to be_friend(@user, @friend)
 		end
 		
 		it "devrait avoir une méthode request!" do
			expect(@user).to respond_to(:request!) 		
 		end
 		
 		it "devrait créer une demande d'ami" do
 			expect { @user.request!(@friend) }.to change(Friendship, :count).by(1)
 			expect(@user.friendships.find_by_friend_id(@friend).status).to eq("pending")
 			expect(@friend.inverse_friendships.find_by_user_id(@user).status).to eq("pending")
 			expect(@user).not_to be_friend(@user, @friend)
 		end
 		
 		it "devrait avoir une méthode pendingfriend?" do
 			@user.request!(@friend)
 			expect(@user).to be_pendingfriend(@user, @friend)
 			expect(@friend).not_to be_pendingfriend(@friend, @user)
 		end
 	end
 	
 	describe "recommendations" do
 	
 		before(:each) do
 			@man = User.create!(@attr)
 			@friend = FactoryGirl.create(:user)
 			@man.friendships.create(:friend_id => @friend.id, :status => "accepted")
 			@reco1 = FactoryGirl.create(:recommendation , :sender => @man, :receiver => @friend, :created_at => 1.day.ago)
 			@reco2 = FactoryGirl.create(:recommendation , :sender => @man, :receiver => @friend, :created_at => 1.hour.ago)
 		end
 		
 		it "devrait avoir un attribut recommendations ou sent_recommendation" do
 			expect(@man).to respond_to(:sent_recommendations)
 			expect(@friend).to respond_to(:recommendations)
 		end
 		
 		it "devrait inclure la recommendation chez les utilisateurs" do
 			expect(@man.sent_recommendations.include?(@reco1)).to be_truthy
 			expect(@friend.recommendations.include?(@reco1)).to be_truthy
 		end
 		
 		it "devrait avoir les bonnes recommendations dans le bon ordre" do
 			expect(@friend.recommendations).to eq([@reco2, @reco1])
 		end
 		
 		it "devrait détruire les recommendations" do
 			@friend.destroy
 			[@reco1, @reco2].each do |micropost|
 				expect(Recommendation.find_by_id(micropost.id)).to be_nil
 			end
 		end
 	end
 	
 	describe "requests" do
 	
 		before(:each) do
 			@man = User.create!(@attr)
 			@friend = FactoryGirl.create(:user)
 			@man.friendships.create(:friend_id => @friend.id, :status => "accepted")
 			@req1 = FactoryGirl.create(:request , :sender => @man, :receiver => @friend, :created_at => 1.day.ago)
 			@req2 = FactoryGirl.create(:request , :sender => @man, :receiver => @friend, :created_at => 1.hour.ago)
 		end
 		
 		it "devrait avoir un attribut requests ou sent_requests" do
 			expect(@man).to respond_to(:sent_requests)
 			expect(@friend).to respond_to(:requests)
 		end
 		
 		it "devrait inclure la request chez les utilisateurs" do
 			expect(@man.sent_requests.include?(@req1)).to be_truthy
 			expect(@friend.requests.include?(@req2)).to be_truthy
 		end
 		
 		it "devrait avoir les bonnes requests dans le bon ordre" do
 			expect(@friend.requests).to eq([@req2, @req1])
 		end
 		
 		it "devrait détruire les requests" do
 			@friend.destroy
 			[@req1, @req2].each do |micropost|
 				expect(Request.find_by_id(micropost.id)).to be_nil
 			end
 		end
 	end
end

