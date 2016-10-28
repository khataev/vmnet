# require 'open-uri'
require 'nokogiri'

class DollarIndex
	@@index = nil
	@@baseurl = "https://www.federalreserve.gov/releases/h10/Summary/indexb_b.htm"
	@@address = URI("#@@baseurl")

	def self.load
		@@index = {}
		doc = Nokogiri::XML(open(@@address)) 
		rows = doc.remove_namespaces!.css("table.statistics").xpath("tr")
		rows.each do |row|
			@@index[row.xpath("th").text.strip] = row.xpath("td").text == "ND" ? nil : row.xpath("td").text.to_f
		end		
	end

	def self.data
		load unless @@index
		@@index
	end

end