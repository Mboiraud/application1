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
 		end
 	end	
end
