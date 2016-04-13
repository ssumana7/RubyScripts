require 'net/http'
require 'uri'
require 'csv'
require "json"
#csvFile = CSV.open('D:\\ReadyPulse\\RubyScripts\\result_latest.csv','ab')
def checkLoadTime(str)
	url=URI.parse(str)
	 start_time = Time.now
	 response=Net::HTTP.get(url)
	 end_time = Time.now - start_time
	   if response==""
	     puts "no response"
	   else
	     puts "response time : #{end_time}"
	   end
	return end_time   
end

def parseJSON(jsonurl_app,jsonurl_app2,jsourls,curation_id)
	csvData = []
	response_time = []
	jsourls.each do |url|
		puts "in parsejson - #{url}"
		response_time.push(checkLoadTime(url))
	end	
	resp = Net::HTTP.get_response(URI.parse(jsonurl_app))
	data = resp.body
	result = JSON.parse(data)

	resp = Net::HTTP.get_response(URI.parse(jsonurl_app2))
	data = resp.body
	result_app2 = JSON.parse(data)
	csvData << curation_id << result["type"] << result["brand"]["id"] << result["brand"]["name"] << response_time.at(0) << response_time.at(1) << result["item_count"] << response_time.at(2) << response_time.at(3) << result_app2["item_count"]
	writeToCSV(csvData)   
end

def writeToCSV(csvData)
	puts "writetocsv"
	CSV.open('result_latest.csv','ab') do |csv|
		csv << csvData
	end
end

CSV.foreach('latest.csv') do |row|
		curation_id= row[0]
		url = row[1]
		newProd = url
		newProd_force = url + "?force=true"
		currProd = url + ""
		currProd = currProd.sub!('app2','app')
		currProd_force = currProd + "?force=true"
		
		jsonurl_app = "http://app.readypulse.com/api/v1/widgets/" + curation_id
		jsonurl_app2 = "http://app2.readypulse.com/api/v1/widgets/" + curation_id
		 
		jsonurls = [currProd,currProd_force,newProd,newProd_force]
		parseJSON(jsonurl_app,jsonurl_app2,jsonurls,curation_id) 	
end	