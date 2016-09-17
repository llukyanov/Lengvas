require 'test_helper'
 
class AutoListingTest < ActiveSupport::TestCase
	test "autoplius listing parsing" do
		source = "autoplius"
		page_num = 1
		mechanize = Mechanize.new
		page = mechanize.get('http://en.autoplius.lt/ads/used-cars?order_by=3&order_direction=DESC&page_nr=#{page_num}')
		rand_i = rand(10)
		listing = page.search('.item')[rand_i]
		parsing = AutoListing.extract_make_model_body_type(listing, source)
		
		expect(obj).to be_nil
		assert_not_equal(nil, parsing)
	end

=begin
	test "autogidas listing parsing" do
	end

	test "alio listing parsing" do
	end
=end	

end