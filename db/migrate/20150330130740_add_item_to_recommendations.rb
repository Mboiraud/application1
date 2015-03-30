class AddItemToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :item, :string
  end
end
