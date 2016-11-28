class AddAdminToUsers < ActiveRecord::Migration
  def change
	remove_column :users, :is_admin, :boolean
	add_column :users, :admin, :boolean, null: false, default: false
  end
end
