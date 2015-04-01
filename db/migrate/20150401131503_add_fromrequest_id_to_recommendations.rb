class AddFromrequestIdToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :fromrequest_id, :integer
  end
end
