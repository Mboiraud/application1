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

class Request < ActiveRecord::Base

	belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
	belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
	
	validates :content, :length => { :maximum => 200 }
	validates :sender, :presence => true
	validates :receiver, :presence => true
	validates :category, :presence => true, inclusion: { in: %w(film musique)}
	validates :group, :presence => true, inclusion: { in: %w(new old)}
	validate :must_be_friends
	
	default_scope { order('requests.created_at DESC') }
	
		def must_be_friends
			return unless errors.blank?
			unless sender.friend?(receiver, sender) or sender == receiver
				errors.add(:base, 'vous devez être amis')
			end
		end
end