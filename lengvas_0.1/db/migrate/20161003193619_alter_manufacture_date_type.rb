class AlterManufactureDateType < ActiveRecord::Migration
  def up
    remove_column :auto_listings, :manufacture_date
    add_column :auto_listings, :manufacture_date, :datetime
  end

  def down
    remove_column :auto_listings, :manufacture_date
    add_column :auto_listings, :manufacture_date, :integer
  end  
end
