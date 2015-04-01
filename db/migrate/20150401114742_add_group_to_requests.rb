class AddGroupToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :group, :string
  end
end
