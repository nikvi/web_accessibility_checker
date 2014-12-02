# runReports.rb
require './config/waveApiConfig'
require_relative './parseCsv.rb'
require_relative './databaseAccess.rb'
require_relative './queryWave.rb'
require_relative  './models/submit.rb'


class RunReports
# generates the formatted url used to access Wave
def self.format_url_data(data)
	query_urls = Array.new
	data["array"].each do |x| 
    	str = "#{WaveConfig::WAVE_API_URL}key=#{WaveConfig::WAVE_API_KEY}&url=#{x}&reporttype=#{WaveConfig::REPORT_TYPE}" 
    	query_urls.push str
  	end
	return {"urls" => query_urls, "name" => data["website"], "site" => data["ip"] }
end

def run_reports_csv(file_name,source,url_count=5)
	qv = QueryWaveAPI.new
	parser  = ParseCSV.new(file_name,source)
	data    = parser.get_urls(url_count)
    qv.query_wave(format_url_data(data))
end

#def run_reports_web()
	#db          = DBAccess.new()
	#report_data = db.get_requested_urls()
	#report_data.each do |dt|
	#	@qv.query_wave(format_url_data(dt))
  	#end	
#end

def RunReports.run_report_db(rep_id)
	ActiveRecord::Base.transaction do
		 qv = QueryWaveAPI.new
		 rep = Submit.find(rep_id)
		 report_req  = {
	      "website" => rep.report_name,
	      "ip"      => rep.web_url,
	      "array"   => (rep.pg_urls).split(',')
	    }
	    qv.query_wave(format_url_data(report_req))
	    rep.update_attributes(report_run: 'true')
	end
end

end
