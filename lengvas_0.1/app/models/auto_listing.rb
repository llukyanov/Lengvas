class AutoListing < ActiveRecord::Base

	def AutoListing.scrape_autoplius
		latest_autoplius_id = AutoListing.where("source = ?", "autoplius").order("listing_id DESC").first.listing_id
		page = mechanize.get('http://en.autoplius.lt/ads/used-cars?order_by=3&order_direction=DESC&page_nr=#{page}')
		latest_listing = page.search('.item').first
		latest_listing_id = latest_listing_url.gsub(".html","").split("-").last.to_i

		while listing_id > latest_autoplius_id
			
		end
	end

	#Scraping posts from autoplius
	def AutoListing.scrape_autoplius_page(page_num=1)
		source = "autoplius"
		mechanize = Mechanize.new

		page = mechanize.get('http://en.autoplius.lt/ads/used-cars?order_by=3&order_direction=DESC&page_nr=#{page_num}')

		#listing = page.search('.item').first
		page.search('.item').each do |listing|	
			listing_url = listing.children.children[1].first.last
			listing_id = listing_url.gsub(".html","").split("-").last.to_i

			if listing_id != nil and listing_id > 0
				listing_url = AutoListing.extract_listing_url(listing, source)
				listing_id = AutoListing.extract_listing_id(listing, source)
				listing_image_url = AutoListing.extract_image_url(listing, source)
				listing_posting_time = AutoListing.extract_posting_time(listing, source)
				listing_location = AutoListing.extract_location(listing, source)

				listing_make = 
				listing_model = 
				listing_body_type
				listing_year

				listing_fuel =
				listing_transmission = 
				listing_engine_literage = 
				listing_power = 
				listing_power_units

				listing_mileage = 
				listing_mileage_units = 
				listing_price = 
				listing_price_currency = 


				







	
				
				
				listing_is_private =  listing.children[7].children[3].children.last.text rescue "NA"#returns 'Private' or 'Dealer' or 'nothing'
				
				
				#---->
				#THIS NEEDS TO BE PARSED OUT FROM THE DESCRIPTIVE STRING 
				listing_description = listing.children[1].children[1].children.last.attributes["alt"].value
				descpition_arr = listing_description.split(", ")
				listing_make_lookup = AutoMaker.where("name LIKE (?)", descpition_arr.first.split.first+'%').first
				if listing_make_lookup != nil 
					listing_make = listing_make_lookup.name
				else
					listing_make = AutoMaker.create!(:name => descpition_arr.first.split.first).name
				end
				
				listing_body_type = 
				listing_model = descpition_arr.first.gsub(listing_make, "")	
				
				listing_engine_literage = descpition_arr[1].split.first.to_f rescue "NA"
				
				#---->

				listing_year = listing.children[3].children[5].children[1].children[1].text
				listing_fuel = listing.children[3].children[5].children[1].children[2].text
				listing_transmission = listing.children[3].children[5].children[1].children[3].text
				listing_power = listing.children[3].children[5].children[1].children[4].text #in kW
				listing_mileage = listing.children[3].children[5].children[1].children[5].text #string that includes units e.g '22 000 km'


				listing_price = listing.children[3].children[3].children[1].children.first.text rescue "NA"

				p "------------------------------"
				p "Listing URL: "+listing_url
				p "Listing ID: "+listing_id.to_s
				p "Listing image URL: "+listing_image_url
				p "Listing posting time: "+listing_posting_time
				p "Listing is private: "+listing_is_private
				p "Listing location: "+listing_location
				p "Listing description: "+listing_description
				p "Listing model: "+listing_model
				p "Listing engine literage: "+listing_engine_literage.to_s
				p "Listing year: "+listing_year
				p "Listing fuel: "+listing_fuel
				p "Listing transmission: "+listing_transmission
				p "Listing power: "+listing_power
				p "Listing mileage: "+listing_mileage
				p "Listing price: "+listing_price
			end
		end
	end

	def AutoListing.scrape_autogidas
		
	end

	def AutoListing.scrape_autogidas_page(page_num=1)
		origination = "autogidas"
		#Combi miniubs, Heavy minibus
		avaliable_body_types = {"box)" => "Commercial auto (with box)", "Convertible" => "Convertible", "Coupe" => "Coupe", "Cars" => "Custom Cars", "Hatchback" => "Hatchback", "Limousine" => "Limousine", "Minibus" => "Minibus", "Sedan" => "Sedan", "SUV" => "SUV", "Van" => "Van", "Wagon" => "Wagon"}
		mechanize = Mechanize.new

		page = mechanize.get('http://en.autogidas.lt/automobiliai/#{page_num}-psl/?f_50=ivedimo_laika_asc')

		#listing = page.search('.item-link').first
		page.search('.item-link').each do |listing|
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
			#fuel
			#transmission
			#power			
			listing_url = listing.attributes.first.last.value #this is the ending part of the url ie "/bmw-318-f30-universalas-2013-0128380676.html" . Need to append it to http://en.autogidas.lt/
			listing_id = listing.children[1].attributes["data-ad-id"].value.to_i

			if listing_id != nil and listing_id > 0
				listing_image_url = listing.children[1].children[5].children[1].children.first.attributes.values.first.value
				
				listing_posting_time = listing.children[1].children[1].children[3].children.text
				listing_is_private =  ""
				listing_location = listing.children[1].children[1].children[1].children.text
				
				#---->
				#THIS NEEDS TO BE PARSED OUT FROM THE DESCRIPTIVE STRING 
				listing_description = listing.children[1].children[5].children[3].children[1].children.text
				description_arr = listing_description.split
				listing_make_lookup = AutoMaker.where("name LIKE (?)", description_arr.first.split.first+'%').first
				if listing_make_lookup != nil 
					listing_make = listing_make_lookup.name
				else
					listing_make = AutoMaker.create!(:name => description_arr.first.split.first).name
				end

				listing_body_type_key = description_arr.last
				if listing_body_type_key == "minibus"
					if listing_description.include? "Combi minibus"
						listing_body_type = "Combi minibus"
					else
						listing_body_type = "Heavy minibus"
					end
				else
					listing_body_type = avaliable_body_types[listing_body_type_key]
				end
								
				listing_model = listing_description.gsub(listing_body_type, "").gsub(listing_make, "")
				
				
				#---->

				auto_details = listing.children[1].children[5].children[3].children[3].children[1].children.text
				auto_details_arr = auto_details.split(", ")
				listing_year =	auto_details_arr.first
				listing_transmission = auto_details_arr[1]
				listing_mileage = auto_details_arr[2] || ""

				auto_details_2 = listing.children[1].children[5].children[3].children[3].children[3].children.first.text
				auto_details_2_arr = auto_details_2.split(", ")
				listing_fuel = auto_details_2_arr[0]
				listing_engine_literage = auto_details_2_arr[1].split.first
				listing_power = auto_details_2_arr[2] || ""#in kW

				listing_price = listing.children[1].children[5].children[3].children[5].children.first.text.gsub(" ", "").gsub("\n","")

				p "------------------------------"
				p "Listing URL: "+listing_url
				p "Listing ID: "+listing_id.to_s
				p "Listing image URL: "+listing_image_url
				p "Listing posting time: "+listing_posting_time
				p "Listing is private: "+listing_is_private
				p "Listing location: "+listing_location
				p "Listing description: "+listing_description
				p "Listing body type: "+listing_body_type
				p "Listing make: "+listing_make
				p "Listing model: "+listing_model
				p "Listing engine literage: "+listing_engine_literage.to_s
				p "Listing year: "+listing_year
				p "Listing fuel: "+listing_fuel
				p "Listing transmission: "+listing_transmission
				p "Listing power: "+listing_power
				p "Listing mileage: "+listing_mileage
				p "Listing price: "+listing_price	
			end		
		end
	end

	def AutoListing.scrape_alio
		
	end

	def AutoListing.scrape_alio_page(page_num=1)
		origination = "alio"
		mechanize = Mechanize.new
		page = mechanize.get('http://www.alio.lt/paieska.html?category_id=613&order=A.ad_id%7CDESC&page=#{page_num}')
		
		#listing = page.search(".main_a_c_b").first
		page.search(".main_a_c_b").each do |listing|
			listing_url = listing.children[1].children[1].attributes["href"].value
			listing_id = listing_url.chomp(".html").split("/").last
			listing_id = listing_id.slice!(0..1).to_i
		
			if listing_id != nil and listing_id > 0
				listing_image_url = listing.children[1].children[1].children[1].attributes["src"].text
				listing_posting_time = listing.children[3].children[9].children[1].attributes["datetime"].value.to_datetime.utc #datetime utc format
				listing_location = listing.children[3].children[5].children.text

				listing_description = listing.children[1].children[1].children[1].attributes["title"].value
				description_arr = listing_description.split(", ")
				listing_make_lookup = AutoMaker.where("name LIKE (?)", description_arr.first.split.first+'%').first
				if listing_make_lookup != nil 
					listing_make = listing_make_lookup.name
				else
					listing_make = AutoMaker.create!(:name => description_arr.first.split.first).name
				end

				listing_model = description_arr.first.gsub(listing_make, "").gsub(" ", "")

				listing_year = listing.children[3].children[1].children[5].children[0].text.strip #of format year-month
				listing_transmission = listing.children[3].children[1].children[5].children[8].text.gsub(" ", "")
				listing_mileage = listing.children[3].children[1].children[5].children[10].text.gsub(" ", "") #has km on the end 
				listing_fuel = listing.children[3].children[1].children[5].children[2].text.gsub(" ", "")
				listing_engine_literage = listing.children[3].children[1].children[5].children[2].text
				listing_power = listing.children[3].children[1].children[5].children[6].text.gsub(" ", "") #has ag on the end
				listing_price = listing.children[3].children[1].children[3].children[1].children.text
			end
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

	def self.extract_listing_url(listing, source)
		if source == "autoplius"
			listing_url = listing.children.children[1].first.last
		elsif source == "autogidas"
			listing_url = listing.attributes.first.last.value
		elsif source == "alio"
			listing_url = listing.children[1].children[1].attributes["href"].value
		else
			listing_url = nil
		end

		return listing_url
	end

	def self.extract_listing_id(listing, source)
		if source == "autoplius"
			listing_id = listing_url.gsub(".html","").split("-").last.to_i
		elsif source == "autogidas"
			listing_id = listing.children[1].attributes["data-ad-id"].value.to_i
		elsif source == "alio"
			listing_url = listing.children[1].children[1].attributes["href"].value
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
			listing_image_url = listing.children.children[1].children.first.attributes.first.last.value
		elsif source == "autogidas"
			listing_image_url = listing.children[1].children[5].children[1].children.first.attributes.values.first.value
		elsif source == "alio"
			listing_image_url = listing.children[1].children[1].children[1].attributes["src"].text
		else
			listing_image_url = nil
		end

		return listing_image_url
	end

	def AutoListing.extract_posting_time(listing, source)
		if source == "autoplius"
			raw_posting_time = listing.children[7].children[3].children.first.text
			digits_units = AutoListing.digits_units_helper(raw_posting_time.downcase)
			listing_posting_time = AutoListing.format_posting_time(digits_units.first, digits_units.last)
		elsif source == "autogidas"
			raw_posting_time = listing.children[1].children[1].children[3].children.text
			digits_units = AutoListing.digits_units_helper(raw_posting_time.downcase)
			listing_posting_time = AutoListing.format_posting_time(digits_units.first, digits_units.last)
		elsif source == "alio"
			listing_posting_time = listing.children[3].children[9].children[1].attributes["datetime"].value.to_datetime.utc
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
		elsif units == "minutes" || units == "m"
			Time.now.utc - digits.minutes
		elsif units == "seconds" || untis == "s"
			Time.now.utc - digits.seconds
		else
			Time.now.utc - digits.days
		end
	end

	def AutoListing.extract_location(listing, source)
		#city
		if source == "autoplius"
			location = listing.children[3].children[5].children[1].children[6].text
		elsif source == "autogidas"
			location = listing.children[1].children[1].children[1].children.text
		elsif source == "alio"
			location = listing.children[3].children[5].children.text
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


		if source == "autoplius"
			listing_description = listing.children[1].children[1].children.last.attributes["alt"].value
			listing_description_arr = listing_description.split(", ")
			listing_make_lookup = AutoMaker.where("name LIKE (?)", listing_description_arr.first.split.first+'%').first
			
			if listing_make_lookup != nil 
				listing_make = listing_make_lookup.name
			else
				listing_make = AutoMaker.create!(:name => listing_description_arr.first.split.first).name
			end

			listing_model = listing_description_arr.first.gsub(listing_make, "")
			listing_body_type = autoplius_body_types[listing_description_arr.last]

		elsif source == "autogidas"
			listing_description = listing.children[1].children[5].children[3].children[1].children.text
			listing_description_arr = listing_description.split
			listing_make_lookup = AutoMaker.where("name LIKE (?)", description_arr.first.split.first+'%').first
			if listing_make_lookup != nil 
				listing_make = listing_make_lookup.name
			else
				listing_make = AutoMaker.create!(:name => description_arr.first.split.first).name
			end

			listing_body_type = autogidas_body_types[listing_description_arr.last]
		
		elsif source == "alio"
		
		else
			nil
		end

		return {"make" => listing_make, "model" => listing_model, "bodytype" => listing_bodytype]
	end

	def self.extract_year(listing, source)
		if source == "autoplius"
			raw_listing_year = listing.children[3].children[5].children[1].children[1].text #format is 2009-05
			raw_listing_year_arr = raw_listing_year.split("-")
			year = DateTime.new(raw_listing_year_arr.first.to_i, raw_listing_year_arr.last.to_i)
		elsif source == "autogidas"
			raw_listing_year = listing.children[1].children[5].children[3].children[3].children[1].children.text.split(", ").first
			raw_listing_year_arr = raw_listing_year.split("-")
			year = DateTime.new(raw_listing_year_arr.first.to_i, raw_listing_year_arr.last.to_i)
		elsif source == "alio"
			raw_listing_year = listing.children[3].children[1].children[5].children[0].text.strip.to_i
			year = DateTime.new(raw_listing_year)
		else
			nil
		end

		return year
	end

	def self.extract_price(listing, source)
		euro = "€"
		dollar = "$"
		if source == "autoplius"
			raw_text_price = listing.children[3].children[3].children[1].children.first.text
			listing_euro_price = raw_text_price.split("€").first.gsub(" ","").to_i
		elsif source == "autogidas"
			raw_text_price = listing.children[1].children[5].children[3].children[5].children.first.text.gsub(" ", "").gsub("\n","")
			listing_euro_price = raw_text_price.split("€").first.gsub(" ","").to_i
		elsif source == "alio"
			raw_text_price = listing.children[2].children[1].children[3].children.children.text
			listing_euro_price = raw_text_price.split("€").first.gsub(" ","").to_i
		else
			nil
		end	

		return listing_euro_price
	end

	def self.extract_mileage(listing, source)
		if source == "autoplius"
			listing_mileage_text = listing.children[3].children[5].children[1].children[5].text			
			listing_mileage = self.sanitize_listing_mileage_text(listing_mileage_text)
		elsif source == "autogidas"
			listing_description = listing.children[1].children[5].children[3].children[3].children[1].children.text
			listing_description_arr = listing_description.split(", ")
			listing_mileage_text = listing_description_arr.last.gsub(".", "")
			listing_mileage = self.sanitize_listing_mileage_text(listing_mileage_text)
		elsif source == "alio"
			listing_mileage_text = listing.children[2].children[1].children[5].children[10].text.gsub(" ", "")
			listing_mileage = self.sanitize_listing_mileage_text(listing_mileage_text)
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

	def self.extract_engine_literage(listing, source)
		if source == "autoplius"
			listing_description = listing.children[1].children[1].children.last.attributes["alt"].value
			listing_descpition_arr = listing_description.split(", ")
			listing_engine_literage = listing_descpition_arr[1].split.first.to_f
		elsif source == "autogidas"
			listing_description = listing.children[1].children[5].children[3].children[3].children[3].children.first.text
			listing_description_arr = listing_description.split(", ")
			listing_engine_literage = listing_description_arr[1].split.first
		elsif source == "alio"
			listing_engine_literage = listing.children[3].children[1].children[5].children[2].text
		else
			nil
		end

		return listing_engine_literage
	end

	def self.extract_fuel_type(listing, source)
		if source == "autoplius"
			listing_fuel_type = listing.children[3].children[5].children[1].children[2].text
		elsif source == "autogidas"
			listing_description = listing.children[1].children[5].children[3].children[3].children[3].children.first.text
			listing_description_arr = listing_description.split(", ")
			listing_fuel_type = listing_description_arr[0]					
		elsif source == "alio"
			lt_translator = {"Benzinas" => "Gasoline", "Dyzelinas" => "Diesel"}
			listing_fuel_lt = listing.children[2].children[1].children[5].children[2].text.gsub(" ","")
			listing_fuel_type = lt_translator[listing_fuel_lt]
		else
			nil
		end

		return listing_fuel_type
	end

	def self.extract_transmission(listing, source)
		if source == "autoplius"
			listing_transmission = listing.children[3].children[5].children[1].children[3].text
		elsif source == "autogidas"
			listing_description = listing.children[1].children[5].children[3].children[3].children[1].children.text
			listing_descpition_arr = listing_description.split(", ")
			listing_transmission = listing_descpition_arr[1]
		elsif source == "alio"
			lt_translator = {"Automatinė" => "Automatic", "Mechaninė" => "Mechanical"}
			listing_transmission_lt = listing.children[2].children[1].children[5].children[8].text.gsub(" ","")
			listing_transmission = lt_translator[listing_transmission_lt]
		else
			nil
		end

		return listing_transmission
	end

	def self.extract_power(listing, source)
		kw2hp = (1.0/1.34102)
		#1kw = 1.34102hp
		if source == "autoplius"
			listing_power_kw_text = listing.children[3].children[5].children[1].children[4].text #in kW
			listing_power_kw = listing_power_kw_text.split("kW").first.gsub(" ", "").to_i
			listing_power = (listing_power_kw * kw2hp).round(0)
		elsif source == "autogidas"
			listing_description = listing.children[1].children[5].children[3].children[3].children[3].children.first.text
			listing_description_arr = listing_description.split(", ")
			listing_power_kw_text = listing_description_arr[2]
			listing_power_kw = listing_power_kw_text.split("kW").first.gsub(" ", "").to_i
			listing_power = (listing_power_kw * kw2hp).round(0)
		elsif source == "alio"
			listing_power_text = listing.children[2].children[1].children[5].children[6].text
			listing_power = listing_power_text.gsub(" ", "").split("AG").first.to_i
		else
			nil
		end		

		return listing_power
	end


end