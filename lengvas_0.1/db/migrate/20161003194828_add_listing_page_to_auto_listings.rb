class AddListingPageToAutoListings < ActiveRecord::Migration
  def change
    add_column :auto_listings, :listing_page, :integer
  end
end
