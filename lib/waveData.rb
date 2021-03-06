#waveData.rb
# Public: JSON data is converted to a Wave Data class for ease of retrieval and storage
#
# @version: 1.00
# @author: Nikki Vinaya
class WaveData

	attr_reader  :submit_id, :report_name, :page_url, :wave_url, :page_title, :categories 

	def initialize(submit_id,page_url,page_title,wave_url,categories=Array.new())
		@submit_id  = submit_id
		@page_url     = page_url
	    @page_title   = page_title
	    @wave_url     = wave_url
	    @categories   = categories
	end


	def createCategories(alerts_map,type)
	    alerts_array = Array.new()
		alerts_map.each_value do |value|
			al_hash = { 'c_name'       => type, 
				        'c_desc_name'  => value['description'], 
				        'c_desc_title' => value['id'], 
				        'c_count'      => value['count'] }
			alerts_array << al_hash
		end
		@categories.concat(alerts_array)
	 end
	 
end