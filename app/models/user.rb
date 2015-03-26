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

class User < ActiveRecord::Base
	attr_accessor :password
	
	has_many :microposts, :dependent => :destroy
	
	has_many :friendships, :dependent => :destroy
	has_many :friends, :through => :friendships
	has_many :inverse_friendships, :foreign_key => "friend_id",
												:class_name => "Friendship",
												:dependent => :destroy
	has_many :inverse_friends, :through => :inverse_friendships, :source => :user
	
	has_many :recommendations, :foreign_key => "receiver_id",
										:dependent => :destroy
	has_many :sent_recommendations, :class_name => "Recommendation", :foreign_key => "sender_id"

	validates :nom, 	:presence => true,
							:length => { :maximum => 50 }
							
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
														
	validates :email, :presence => true,
							:format => { :with =>  email_regex},
							:uniqueness => { :case_sensitive => false }
							
	validates :password, :presence => true,
								:confirmation => true,
								:length =>  { :within => 6..40 }
								
	before_save :encrypt_password
	
	def has_password?(password_soumis)
		encrypted_password == encrypt(password_soumis)
	end
	
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
	
	def feed
		Micropost.where("user_id = ?", id)
	end

	def friend?(user, friend)
		user.friendships.where(:friend_id => friend.id).where(:status => "accepted").first or friend.friendships.where(:friend_id => user.id).where(:status => "accepted").first
	end
	
	def pendingfriend?(user, friend)
		user.friendships.where(:friend_id => friend.id).where(:status => "pending").first 
	end
	
	def request!(friend)
		friendships.create!(:friend_id => friend.id, :status => "pending")
	end
	
	private
	
		def encrypt_password 
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end
		
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
	
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
		
		def self.authenticate(email, submitted_password)
			user = find_by_email(email)
			return nil if user.nil?
			return user if user.has_password?(submitted_password)
		end
		
		def self.authenticate_with_salt(id, cookie_salt)
			user = find_by_id(id)
			(user && user.salt == cookie_salt) ? user : nil
		end
end
