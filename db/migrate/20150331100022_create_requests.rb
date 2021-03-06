class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :category
      t.string :content

      t.timestamps
    end
    	add_index :requests, :receiver_id
  end
end
