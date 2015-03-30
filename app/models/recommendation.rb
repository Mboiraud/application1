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
#  category    :string(255)
#  item        :string(255)
#

class Recommendation < ActiveRecord::Base

	belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
	belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
	
	validates :content, :length => { :maximum => 200 }
	validates :sender, :presence => true
	validates :receiver, :presence => true
	validates :category, :presence => true, inclusion: { in: %w(film musique)}
	validates :item, :presence => true
	validate :must_be_friends
	
	default_scope { order('recommendations.created_at DESC') }
	
		def must_be_friends
			return unless errors.blank?
			unless sender.friend?(receiver, sender) or sender == receiver
				errors.add(:base, 'vous devez être amis')
			end
		end
end
