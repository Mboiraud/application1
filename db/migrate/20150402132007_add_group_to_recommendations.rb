class AddGroupToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :group, :string
  end
end
