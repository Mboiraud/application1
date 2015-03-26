class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :content

      t.timestamps
    end
    add_index :recommendations, :receiver_id
  end
end
