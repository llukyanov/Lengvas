class AutoModel < ActiveRecord::Base
	belongs_to :auto_maker

	def AutoModel.populate_entries
		data = File.read('lib/tasks/Make-Model.csv')
		csv = CSV.parse(data, :headers => false)

		csv.each do |entry|
			maker = entry.first
			model = entry.last
			maker_lookup = AutoMaker.find_by_name(maker)
			
			if maker_lookup == nil
				maker_lookup = AutoMaker.create!(:name => maker)
			end

			AutoModel.create!(:name => model, :auto_maker_id => maker_lookup.id)
		end

	end
end