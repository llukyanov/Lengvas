class FixAutoListingDateColumnName < ActiveRecord::Migration
  def change
  	rename_column :auto_listings, :date, :listing_time
  	rename_column :auto_listings, :type, :bodytype
  	rename_column :auto_listings, :year, :manufacture_date
  	rename_column :auto_listings, :transmision, :transmission
  end
end
