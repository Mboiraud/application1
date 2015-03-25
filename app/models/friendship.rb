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

class Friendship < ActiveRecord::Base

belongs_to :user
belongs_to :friend, :class_name => "User"

validates :user_id, :presence => true
validates :friend_id, :presence => true
validates :status, :presence => true, inclusion: { in: %w(pending accepted)}

end
