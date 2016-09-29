#run with following command: rspec spec/models/auto_listing_spec.rb
require 'rails_helper'

describe AutoListing do
	mechanize = Mechanize.new
	it "can be pulled from autoplius" do
		source = "autoplius"
		page_num = (rand(10)+1).to_s
		p "Page number: #{page_num}"
		page = mechanize.get('http://en.autoplius.lt/ads/used-cars?order_by=3&order_direction=DESC&page_nr='+page_num)
	
		i = 0
		page.search('.item').each do |listing|
			if not AutoListing.new_car_autoplius_listing(listing)
				listing_url = AutoListing.extract_listing_url(listing, source)
				
				p "Entry: #{i}, Listing url: #{listing_url}"

				listing_id = AutoListing.extract_listing_id(listing, source)
				listing_image_url = AutoListing.extract_image_url(listing, source)
				listing_posting_time = AutoListing.extract_posting_time(listing, source)
				listing_location = AutoListing.extract_location(listing, source)				
				listing_auto_details = AutoListing.extract_make_model_body_type(listing, source)
				listing_make = listing_auto_details["Make"]
				listing_model = listing_auto_details["Model"]
				listing_body_type = listing_auto_details["Bodytype"]
				listing_year = AutoListing.extract_manufacture_date(listing, source)
				listing_fuel = AutoListing.extract_fuel_type(listing, source)
				listing_transmission = AutoListing.extract_transmission(listing, source)
				listing_engine_literage = AutoListing.extract_engine_literage(listing, source)
				listing_power = AutoListing.extract_power(listing, source)				
				listing_mileage = AutoListing.extract_mileage(listing, source)		
				listing_price = AutoListing.extract_price(listing, source)

				expect(listing_url).to_not eq(nil)
				expect(listing_id).to_not eq(nil)
				expect(listing_image_url).to_not eq(nil)
				expect{ listing_posting_time }.not_to raise_error
				expect(listing_location).to_not eq(nil)
				expect(listing_make).to_not eq(nil)
				expect(listing_model).to_not eq(nil)
				expect(listing_body_type).to_not eq(nil)
				expect(listing_year).to_not eq(nil)
				expect(listing_fuel).to_not eq(nil)
				expect(listing_transmission).to_not eq(nil)
				expect(listing_engine_literage).to_not eq(nil)
				expect{ listing_power }.not_to raise_error
				expect{ listing_mileage }.not_to raise_error
				expect(listing_price).to_not eq(nil)
			end
			i += 1
		end
  end

  it "can be pulled from autogidas" do
  	source = "autogidas"
  	page_num = (rand(10)+1).to_s
  	p "Page number: #{page_num}"
  	page = mechanize.get("http://en.autogidas.lt/automobiliai/#{page_num}-psl/?f_50=ivedimo_laika_asc")

  	i = 0
  	page.search('.item-link').each do |listing|
		listing_url = AutoListing.extract_listing_url(listing, source)
		
		p "Entry: #{i}, #{listing_url}"

		listing_id = AutoListing.extract_listing_id(listing, source)
		listing_image_url = AutoListing.extract_image_url(listing, source)
		listing_posting_time = AutoListing.extract_posting_time(listing, source)
		listing_location = AutoListing.extract_location(listing, source)
		listing_auto_details = AutoListing.extract_make_model_body_type(listing, source)
		listing_make = listing_auto_details["Make"]
		listing_model = listing_auto_details["Model"]
		listing_body_type = listing_auto_details["Bodytype"]
		listing_year = AutoListing.extract_manufacture_date(listing, source)
		listing_fuel = AutoListing.extract_fuel_type(listing, source)
		listing_transmission = AutoListing.extract_transmission(listing, source)
		listing_engine_literage = AutoListing.extract_engine_literage(listing, source)
		listing_power = AutoListing.extract_power(listing, source)				
		listing_mileage = AutoListing.extract_mileage(listing, source)		
		listing_price = AutoListing.extract_price(listing, source)

		expect(listing_url).to_not eq(nil)
		expect(listing_id).to_not eq(nil)
		expect(listing_image_url).to_not eq(nil)
		expect{ listing_posting_time }.not_to raise_error
		expect(listing_location).to_not eq(nil)
		expect(listing_make).to_not eq(nil)
		expect(listing_model).to_not eq(nil)
		expect(listing_body_type).to_not eq(nil)
		expect(listing_year).to_not eq(nil)
		expect(listing_fuel).to_not eq(nil)
		expect(listing_transmission).to_not eq(nil)
		expect(listing_engine_literage).to_not eq(nil)
		expect{ listing_power }.not_to raise_error
		expect{ listing_mileage }.not_to raise_error
		expect(listing_price).to_not eq(nil)

		i += 1
  	end
  end

  it "can be pulled from alio" do
  	source = "alio"
  	page_num = (rand(10)+1).to_s
  	p "Page number: #{page_num}"
  	page = mechanize.get("http://www.alio.lt/paieska.html?category_id=613&order=A.ad_id%7CDESC&page=#{page_num}")

  	i = 0 
  	page.search(".main_a_c_b").each do |listing|
		listing_url = AutoListing.extract_listing_url(listing, source)
		
		p "Entry: #{i}, #{listing_url}"

		listing_id = AutoListing.extract_listing_id(listing, source)
		listing_image_url = AutoListing.extract_image_url(listing, source)
		listing_posting_time = AutoListing.extract_posting_time(listing, source)
		listing_location = AutoListing.extract_location(listing, source)
		listing_auto_details = AutoListing.extract_make_model_body_type(listing, source)
		listing_make = listing_auto_details["Make"]
		listing_model = listing_auto_details["Model"]
		listing_body_type = listing_auto_details["Bodytype"]
		listing_year = AutoListing.extract_manufacture_date(listing, source)
		listing_fuel = AutoListing.extract_fuel_type(listing, source)
		listing_transmission = AutoListing.extract_transmission(listing, source)
		listing_engine_literage = AutoListing.extract_engine_literage(listing, source)
		listing_power = AutoListing.extract_power(listing, source)				
		listing_mileage = AutoListing.extract_mileage(listing, source)		
		listing_price = AutoListing.extract_price(listing, source)

		expect(listing_url).to_not eq(nil)
		expect(listing_id).to_not eq(nil)
		expect{ listing_image_url }.not_to raise_error
		expect{ listing_posting_time }.not_to raise_error
		expect(listing_location).to_not eq(nil)
		expect(listing_make).to_not eq(nil)
		expect(listing_model).to_not eq(nil)
		expect{ listing_body_type }.not_to raise_error
		expect{ listing_year }.not_to raise_error
		expect{ listing_fuel }.not_to raise_error
		expect{ listing_transmission }.not_to raise_error
		expect{ listing_engine_literage }.not_to raise_error
		expect{ listing_power }.not_to raise_error
		expect{ listing_mileage }.not_to raise_error
		expect(listing_price).to_not eq(nil)

		i += 1
  	end
  end 

end