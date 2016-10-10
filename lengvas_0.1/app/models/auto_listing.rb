class AutoListing < ActiveRecord::Base

	def AutoListing.scrape_autoplius(page_num=1)
		mechanize = Mechanize.new
		
		source = "autoplius"		
		page = mechanize.get("http://en.autoplius.lt/ads/used-cars?order_by=3&order_direction=DESC&page_nr=#{page_num}")		
		listings = page.search('.item')

		AutoListing.spider(listings, source, page_num)
	end

	def AutoListing.scrape_autogidas(page_num=1)
		mechanize = Mechanize.new
		
		source = "autogidas"		
		page = mechanize.get("http://en.autogidas.lt/automobiliai/#{page_num}-psl/?f_50=atnaujinimo_laika_asc")		
		listings = page.search('.item-link')

		AutoListing.spider(listings, source, page_num)
	end

	def AutoListing.scrape_alio(page_num=1)
		mechanize = Mechanize.new
		
		source = "alio"
		page = mechanize.get("http://www.alio.lt/paieska.html?category_id=613&order=A.ad_id%7CDESC&page=#{page_num}")
		listings = page.search(".main_a_c_b")
		
		AutoListing.spider(listings, source, page_num)
	end

	def AutoListing.spider(listings, source, page_num)
		listings_count = listings.count
		i = 0
		dupe_attempt_count = 0

		listings.each do |listing|
			i += 1
			dupe_attempt_count += AutoListing.create_new_auto_listing(listing, source, page_num) ? 0:1

			if dupe_attempt_count > 10
				break
			end

			if i == listings_count
				self.send("scrape_#{source}", page_num+1)#recursive namespace method call.
			end
		end
		p "Dupe attempts: #{dupe_attempt_count}"
	end

	def AutoListing.create_new_auto_listing(listing, source, page_num)
		listing_id = AutoListing.extract_listing_id(listing, source)

		if listing_id > 0 and not AutoListing.where("source = ? AND listing_id = ?", source, listing_id.to_s).any?
			listing_auto_details = AutoListing.extract_make_model_body_type(listing, source)
			if listing_auto_details != nil
				listing_url = AutoListing.extract_listing_url(listing, source)			
				listing_image_url = AutoListing.extract_image_url(listing, source)
				listing_posting_time = AutoListing.extract_posting_time(listing, source)
				listing_location = AutoListing.extract_location(listing, source)			
				listing_make = listing_auto_details["Make"]
				listing_model = listing_auto_details["Model"]
				listing_bodytype = listing_auto_details["Bodytype"]
				listing_manufacture_date = AutoListing.extract_manufacture_date(listing, source)
				listing_fuel = AutoListing.extract_fuel_type(listing, source)
				listing_transmission = AutoListing.extract_transmission(listing, source)
				listing_engine_literage = AutoListing.extract_engine_literage(listing, source)
				listing_power = AutoListing.extract_power(listing, source)
				listing_mileage = AutoListing.extract_mileage(listing, source)
				listing_price = AutoListing.extract_price(listing, source)

				AutoListing.create!(:source => source, :listing_id => listing_id, :url => listing_url, :image_url => listing_image_url,
					:listing_time => listing_posting_time, :make => listing_make, :model => listing_model, :bodytype => listing_bodytype, 
					:manufacture_date => listing_manufacture_date, :fuel_type => listing_fuel, :transmission => listing_transmission, 
					:engine_liters => listing_engine_literage, :power => listing_power, :mileage => listing_mileage, :price =>listing_price,
					:city => listing_location, :listing_page => page_num)
			else
				nil
			end
		else
			nil
		end
	end

	#listing url
	#listing id
	#image
	#posting time			
	#location			

	#make
	#model
	#body type

	#year
	#price
	#mileage
	#literage
	#fuel
	#transmission
	#power

	def AutoListing.extract_listing_title(listing, source)
		if source == "autoplius"
			listing_title = listing.search('*[@class="title-list"]').at('a').text
		elsif source == "autogidas"
			listing_title = listing.search('*[@class="description"]').at('[class="item-title"]').text
		elsif source == "alio"
			listing_title = listing.search('*[@class="title"]').text.strip
		else
			listing_title = nil
		end	

		return listing_title		
	end

	def AutoListing.extract_listing_url(listing, source)
		if source == "autoplius"
			listing_url = listing.search('*[@class="title-list"]').at('a')["href"]
		elsif source == "autogidas"
			listing_url = "en.autogidas.lt"+listing.attributes.first.last.value
		elsif source == "alio"
			listing_url = listing.search('*[@class="title"]').at('a')["href"]
		else
			listing_url = nil
		end

		return listing_url
	end

	def AutoListing.extract_listing_id(listing, source)
		if source == "autoplius"
			listing_id = listing.search('*[@class="title-list"]').at('a')["href"].gsub(".html","").split("-").last.to_i
		elsif source == "autogidas"
			listing_id = listing.search('*[@class="ad"]').first.attributes["data-ad-id"].text.to_i
		elsif source == "alio"
			listing_url = AutoListing.extract_listing_url(listing, source)
			listing_id = listing_url.chomp(".html").split("/").last
			listing_id.slice!(0..1)
			listing_id = listing_id.to_i
		else
			listing_id = nil
		end

		return listing_id		
	end

	def AutoListing.extract_image_url(listing, source)
		if source == "autoplius"
			listing_image_url = listing.search('img').first.attributes["src"].value rescue nil
		elsif source == "autogidas"
			listing_image_url = listing.search('*[@class="image"]').at('img').attributes["src"].value rescue nil
		elsif source == "alio"
			listing_image_url = listing.search('*[@class="image"]').at("img").attributes["data-src"].value rescue nil
		else
			listing_image_url = nil
		end

		return listing_image_url
	end

	def AutoListing.extract_posting_time(listing, source)
		if source == "autoplius"
			raw_posting_time = listing.search('*[@class="fr tools-right"]').text.split(".").first
			if raw_posting_time != nil and raw_posting_time.length > 0
				digits_units = AutoListing.digits_units_helper(raw_posting_time.downcase)
				listing_posting_time = AutoListing.format_posting_time(digits_units.first, digits_units.last)
			else
				listing_posting_time = nil
			end
		elsif source == "autogidas"
			raw_posting_time = listing.search('*[@class="inserted-before normal"]').text
			digits_units = AutoListing.digits_units_helper(raw_posting_time.downcase)
			listing_posting_time = AutoListing.format_posting_time(digits_units.first, digits_units.last)
		elsif source == "alio"
			listing_posting_time = listing.search('*[@class="modification"]').at('time')["datetime"].to_datetime.utc
		else
			nil
		end

		return listing_posting_time
	end

	#used to extract units and digits from string of type: "Before 5 h."
	def self.digits_units_helper(input)
		input_arr = input.gsub("before", "").gsub(".", "").split
		digits = input_arr.first
		units = input_arr.last
		return [digits.to_i, units]
	end

	#convert times of "before 1 hour" type to utc
	def self.format_posting_time(digits, units)
		if units == "hours" || units == "h"
			Time.now.utc - digits.hours
		elsif units == "min" ||  units == "minutes" || units == "m"
			Time.now.utc - digits.minutes
		elsif units == "sec" ||  units == "seconds" || units == "s"
			Time.now.utc - digits.seconds
		else
			Time.now.utc - digits.days
		end
	end

	def AutoListing.extract_location(listing, source)
		#city
		if source == "autoplius"
			location = listing.search('*[@title="City"]').text
		elsif source == "autogidas"
			location = listing.search('*[@class="city"]').text
		elsif source == "alio"
			location = listing.search('*[@class="description_more"]').text
		else
			nil
		end		
	end

	def AutoListing.extract_make_model_body_type(listing, source)
		autoplius_body_types = 
		{
			"commercial" => "Commercial", 
			"convertible / roadster" => "Convertible",
			"coupe" => "Coupe",
			"hatchback" => "Hatchback", 
			"limousine" => "Limousine",
			"minibus" => "Minibus",
			"mpv / minivan" => "Minivan", 
			"other" => "Other",
			"pick-up" => "Pick-up", 
			"saloon / sedan" => "Sedan", 
			"suv / off-road" => "SUV", 
			"wagon" => "Wagon"	
		}

		autogidas_body_types = 
		{
			"Commercial auto (with box)" => "Commercial",
			"box)" => "Commercial",
			"Convertible" => "Convertible",
			"Coupe" => "Coupe",
			"Hatchback" => "Hatchback",
			"Limousine" => "Limousine",
			"Combi minibus" => "Minibus",
			"Heavy minibus" => "Minibus",
			"minibus" => "Minibus",
			"Minibus" => "Minibus",
			"Van" => "Minivan",
			"Custom Cars" => "Other",
			"Cars" => "Other",
			"Pick-up" => "Pick-up",
			"Sedan" => "Sedan",
			"SUV" => "SUV",
			"Wagon" => "Wagon"
		}

		alio_body_types = 
		{
			"Komercinis" => "Commercial", 
			"Kabrioletas" => "Convertible",
			"Kupė" => "Coupe",
			"Hečbekas" => "Hatchback", 
			"Limuzinas" => "Limousine",
			"Minibus" => "Minibus",
			"Vienatūris" => "Minivan", 
			"Kitas" => "Other",
			"Pikapas" => "Pick-up", 
			"Sedanas" => "Sedan", 
			"Visureigis" => "SUV", 
			"Universalas" => "Wagon"
		}	


		listing_description = AutoListing.extract_listing_title(listing, source)

		if source == "autoplius"	
			listing_description_arr = listing_description.split(", ")
			listing_make = AutoListing.make_lookup(listing_description_arr.first.split.first)
			listing_model = listing_description_arr.first.gsub(listing_make.name, "").strip
			listing_body_type = autoplius_body_types[listing_description_arr.last.strip]
		elsif source == "autogidas"
			listing_description_arr = listing_description.split

			listing_make = AutoListing.make_lookup(listing_description_arr.first.split.first.strip)

			listing_body_type = autogidas_body_types[listing_description_arr.last.strip] || ""

			raw_model_text = listing_description.gsub(listing_make.name, "").gsub(listing_body_type, "")
			raw_model_leading_text = raw_model_text.split.first.strip rescue listing_body_type
			listing_model_lookup = AutoListing.model_lookup(raw_model_leading_text, listing_make.id)
			listing_model = listing_model_lookup.name
		elsif source == "alio"
			listing_description_arr = listing_description.split(", ")
			if listing_description_arr.count > 1
				listing_make = AutoListing.make_lookup(listing_description_arr.first.split.first.strip)
				listing_model = listing_description_arr.first.gsub(listing_make.name, "").strip
				listing_body_type = alio_body_types[listing_description_arr.last.strip]
			else
				nil
			end
		else
			nil
		end

		if listing_make != nil
			{"Make" => listing_make.name, "Model" => listing_model, "Bodytype" => listing_body_type}
		else
			nil
		end
	end

	def AutoListing.make_lookup(q)
		lookup = AutoMaker.where("name LIKE (?)", q+'%').first

		if lookup != nil 
			result = lookup
		else
			result = AutoMaker.create!(:name => q)
		end
	end

	def AutoListing.model_lookup(q, auto_maker_id)
		lookup = AutoModel.where("name LIKE (?) AND auto_maker_id = ?", q+'%', auto_maker_id).first

		if lookup != nil
			result = lookup
		else
			result = AutoModel.create!(:name => q, :auto_maker_id => auto_maker_id)
		end	

	end

	def AutoListing.extract_manufacture_date(listing, source)
		if source == "autoplius"
			manufacture_date_text = listing.search('*[@title="Date of manufacture"]').text
			manufacture_date_split = manufacture_date_text.split("-")
			year = manufacture_date_split.first.to_i
			if manufacture_date_split.length > 1
				month = manufacture_date_split.last.to_i
			else
				month = 1
			end

			if (year.is_a? Integer and year > 1900) && (month.is_a? Integer and month > 0)
				manufacture_date = DateTime.new(year, month)
			else
				nil
			end
		elsif source == "autogidas"
			raw_listing_year = listing.search('*[@class="item-description"]').at('[class="primary"]').text.split(", ").first
			raw_listing_year_arr = raw_listing_year.split("-")
			year = raw_listing_year_arr.first.to_i
			if raw_listing_year_arr.length > 1
				month = raw_listing_year_arr.last.to_i
			else
				month = 1
			end

			if (year.is_a? Integer and year > 1900) && (month.is_a? Integer and month > 0)
				manufacture_date = DateTime.new(year, month)
			else
				nil
			end
		elsif source == "alio"
			raw_listing_year = listing.search('*[@class="description"]').text.split(" | ").first
			raw_listing_year_arr = raw_listing_year.split("-")
			year = raw_listing_year_arr.first.to_i
			if year != 0
				if raw_listing_year_arr.length > 1
					month = raw_listing_year_arr.last.to_i
				else
					month = 1
				end

				if (year.is_a? Integer and year > 1900) && (month.is_a? Integer and month > 0)
					manufacture_date = DateTime.new(raw_listing_year_arr.first.to_i, month)
				else
					nil
				end
			else
				nil
			end
		else
			nil
		end
	end

	def AutoListing.extract_price(listing, source)
		euro = "€"
		dollar = "$"
		if source == "autoplius"
			raw_text_price = listing.search('*[@class="price-list"]').at("p").text
			listing_euro_price = raw_text_price.split("€").first.gsub(" ","").to_i
		elsif source == "autogidas"
			raw_text_price = listing.search('*[@class="item-price"]').text.gsub(" ", "").gsub("\n","")
			listing_euro_price = raw_text_price.split("€").first.gsub(" ","").to_i
		elsif source == "alio"
			raw_text_price = listing.search('*[@class="price"]').text
			listing_euro_price = raw_text_price.split("€").first.gsub(" ","").to_i
		else
			nil
		end	

		return listing_euro_price
	end

	def AutoListing.extract_mileage(listing, source)
		if source == "autoplius"
			listing_mileage_text = listing.search('*[@title="Mileage"]').text
			if listing_mileage_text.length > 0
				listing_mileage = self.sanitize_listing_mileage_text(listing_mileage_text)
			else
				listing_mileage = nil
			end
		elsif source == "autogidas"
			listing_description = listing.search('*[@class="item-description"]').at('[class="primary"]').text
			#mileage sometimes is not reported
			if listing_description.include? "km" or listing_description.include? "mi"
				listing_description_arr = listing_description.split(", ")
				listing_mileage_text = listing_description_arr.last.gsub(".", "")
				listing_mileage = self.sanitize_listing_mileage_text(listing_mileage_text)
			else
				listing_mileage = nil
			end
		elsif source == "alio"
			listing_mileage = nil
			listing_details_arr = listing.search('*[@class="description"]').text.split(" | ")
			if listing_details_arr.length == 7
				#all details present so mileage is entry 6
				listing_mileage_text = listing_details_arr[5]
				listing_mileage = self.sanitize_listing_mileage_text(listing_mileage_text)
			else
				#details missing, thus must itterarte through and check if a mileage entry is present.
				for entry in listing_details_arr
					if entry.include? "km" or entry.include? "mi"
						listing_mileage_text = entry
						listing_mileage = self.sanitize_listing_mileage_text(listing_mileage_text)
						break
					end
				end
			end
		else
			nil
		end

		return listing_mileage
	end

	def self.sanitize_listing_mileage_text(listing_mileage_text)
		km2mi = 0.621371
		mi2km = 1/km2mi
		if listing_mileage_text.last(2) == "km"
			listing_mileage = listing_mileage_text.split("km").first.gsub(" ", "").to_i
		else
			listing_mileage = listing_mileage_text.split("mi").first.gsub(" ", "").to_i * mi2km
		end

		return listing_mileage
	end

	def AutoListing.extract_engine_literage(listing, source)
		if source == "autoplius"
			listing_description = AutoListing.extract_listing_title(listing, source)
			listing_descpition_arr = listing_description.split(", ")
			listing_engine_literage = listing_descpition_arr[1].split.first.to_f
		elsif source == "autogidas"
			listing_description = listing.search('*[@class="item-description"]').at('[class="secondary"]').text
			listing_description_arr = listing_description.split(", ")
			if listing_description_arr.count > 1
				listing_engine_literage = listing_description_arr[1].split.first.to_f
			end
		elsif source == "alio"
			listing_engine_literage = nil
			listing_details_arr = listing.search('*[@class="description"]').text.split(" | ")
			if listing_details_arr.length == 7
				listing_engine_literage = listing_details_arr[2].strip.split.first.to_f
			else
				for entry in listing_details_arr
					if entry.include? "l" and (entry.include? " " and entry.length < 7)
						listing_engine_literage = entry.strip.split.first.to_f
						break
					end
				end
			end
		else
			nil
		end

		return listing_engine_literage
	end

	def AutoListing.extract_fuel_type(listing, source)
		if source == "autoplius"
			listing_fuel_type = listing.search('*[@title="Fuel type"]').text
		elsif source == "autogidas"
			fuel_type_normalizer = {"Gasoline" => "Gasoline", "Diesel" => "Diesel", "Petrol / Gas" => "Gasoline - Gas", "Gasoline/Electric" => "Hybrid"}
			listing_description = listing.search('*[@class="item-description"]').at('[class="secondary"]').text
			listing_description_arr = listing_description.split(", ")
			listing_fuel_type = fuel_type_normalizer[listing_description_arr[0]]
		elsif source == "alio"
			listing_fuel_type = nil
			lt_translator = {"Benzinas" => "Gasoline", "Dyzelinas" => "Diesel", "Benzinas - Dujos" => "Gasoline - Gas"}
			listing_details_arr = listing.search('*[@class="description"]').text.split(" | ")
			if listing_details_arr.length == 7
				listing_fuel_lt = listing_details_arr[1].strip
				listing_fuel_type = lt_translator[listing_fuel_lt]
			else
				for entry in listing_details_arr
					if lt_translator.keys.include? entry.strip
						listing_fuel_type = lt_translator[entry.strip]		
						break
					end
				end
			end
		else
			nil
		end

		return listing_fuel_type
	end

	def AutoListing.extract_transmission(listing, source)
		if source == "autoplius"
			listing_transmission = listing.search('*[@title="Gearbox"]').text
		elsif source == "autogidas"
			normalizer = {"Automatic" => "Automatic", "Mechanical" => "Manual"}
			listing_description = listing.search('*[@class="item-description"]').at('[class="primary"]').text
			listing_descpition_arr = listing_description.split(", ")
			listing_transmission = normalizer[listing_descpition_arr[1]]
		elsif source == "alio"
			listing_transmission = nil
			lt_translator = {"Automatinė" => "Automatic", "Mechaninė" => "Mechanical"}
			listing_details_arr = listing.search('*[@class="description"]').text.split(" | ")
			if listing_details_arr.length == 7
				listing_transmission_lt = listing_details_arr[4].strip
				listing_transmission = lt_translator[listing_transmission_lt]
			else
				for entry in listing_details_arr
					if lt_translator.keys.include? entry.strip
						listing_transmission = lt_translator[entry.strip]		
						break
					end
				end
			end
		else
			nil
		end

		return listing_transmission
	end

	def AutoListing.extract_power(listing, source)
		kw2hp = 1.34102
		#1kw = 1/1.34102hp
		if source == "autoplius"
			listing_power_kw_text = listing.search('*[@title="Power"]').text #in kW
			if listing_power_kw_text.length > 0
				listing_power_kw = listing_power_kw_text.split("kW").first.gsub(" ", "").to_i
				listing_power = (listing_power_kw * kw2hp).round(0)
			else
				listing_power_kw = nil
			end
		elsif source == "autogidas"
			listing_description = listing.search('*[@class="item-description"]').at('[class="secondary"]').text
			listing_description_arr = listing_description.split(", ")
			listing_power_kw_text = listing_description_arr[2]
			if listing_power_kw_text != nil
				listing_power_kw = listing_power_kw_text.split("kW").first.gsub(" ", "").to_i
				listing_power = (listing_power_kw * kw2hp).round(0)
			else
				listing_power = nil
			end
		elsif source == "alio"
			listing_power = nil
			listing_details_arr = listing.search('*[@class="description"]').text.split(" | ")
			if listing_details_arr.length == 7
				listing_power_text = listing_details_arr[3]
				listing_power = listing_power_text.gsub(" ", "").split("AG").first.to_i
			else
				for entry in listing_details_arr
					if entry.include? " AG"
						listing_power_text = entry
						listing_power = listing_power_text.gsub(" ", "").split("AG").first.to_i
						break
					end
				end
			end
		else
			nil
		end		

		return listing_power
	end

	

	def AutoListing.new_car_autoplius_listing(listing)
		listing.search('*[@class="new-cars-label"]').any?
	end

end