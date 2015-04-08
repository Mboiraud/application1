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
	validates :category, :presence => true, inclusion: { in: ["Film", "Musique", "Série", "Livre BD", "Bar restaurant", "Contenu web", "Evenement", "Jeux vidéo", "Lieux culturels", "autre"]}
	validates :group, :presence => true, inclusion: { in: %w(new old)}
	validate :must_be_friends
	
	default_scope { order('requests.created_at DESC') }
	
		def must_be_friends
			return unless errors.blank?
			unless sender.friend?(receiver, sender) or sender == receiver
				errors.add(:base, 'vous devez être amis')
			end
		end
	
	def goodpicture
		if self.category == "Film"
			goodpicture = "Film.jpg"
		elsif self.category == "Musique"
			goodpicture = "Musique.jpg"
		elsif self.category == "Série"
			goodpicture = "Série.jpg"
		elsif self.category == "Livre BD"
			goodpicture = "Livre BD.jpg"
		elsif self.category == "Bar restaurant"
			goodpicture = "Bar restaurant.jpg"
		elsif self.category == "Contenu web"
			goodpicture = "Contenu web.jpg"
		elsif self.category == "Evenement"
			goodpicture = "Evenement.jpg"
		elsif self.category == "Jeux vidéo"
			goodpicture = "Jeux vidéo.jpg"
		elsif self.category == "Lieux culturels"
			goodpicture = "Lieux culturels.jpeg"
		elsif self.category == "autre"
			goodpicture = "Autre.jpg"
		end
	end
end
