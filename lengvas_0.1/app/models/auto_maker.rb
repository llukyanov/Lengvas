class AutoMaker < ActiveRecord::Base
	has_many :auto_models, :dependent => :destroy

	def AutoMaker.populate_entries
		mechanize = Mechanize.new

		page = mechanize.get('http://en.autoplius.lt/')

		page.search('#make_id option').each do |entry|
			make = entry.children.text
			
			if make != nil and make.first != "-"
				AutoMaker.create!(:name => make)
			end

		end

	end


end