class CreateAutoListings < ActiveRecord::Migration
  def change
    create_table :auto_listings do |t|
    	t.string :source, :index => true
    	t.string :url
    	t.string :image_url
    	t.string :date
		t.string :listing_id, :index => true
    	
    	t.string :make, :index => true
    	t.string :model, :index => true
    	t.string :vin
    	t.string :type, :index => true
    	t.integer :year
    	t.string :fuel_type
    	t.string :transmision
    	t.string :engine_liters
    	t.integer :power
    	t.integer :mileage, :index => true
    	t.integer :mileage_units, :default => "km"
    	t.integer :price, :index => true
    	t.string :price_currency, :default => "euro"

    	t.string :city
    	t.string :country

    	t.timestamps
    end
  end
end
