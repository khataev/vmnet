require 'open-uri'
require 'nokogiri'
require 'date'

# Оболочка над API ЦБ РФ: http://www.cbr.ru/scripts/Root.asp?PrtId=SXML
class Currency
	@@baseurl = "http://www.cbr.ru/scripts/XML_val.asp"
	@@query   = URI.encode_www_form("d" => "0")
	@@address = URI("#@@baseurl?#@@query")
	@@list = nil
	@@rates = nil
	

	def self.all
		load if @@list.nil?
		@@list
	end

	def self.load
		@@list = []
		@@rates = {}
		doc = Nokogiri::XML(open(@@address)) #{|f| p f.content_type, f.charset, f.read.encoding }
		doc.encoding = "UTF-8"
		doc.xpath("//Valuta/Item").each { |item|
			c = Currency.new
			c.id = item.xpath("@ID").text
			c.name = item.xpath("Name/text()")
			c.engname = item.xpath("EngName/text()")
			c.nominal = item.xpath("Nominal/text()")
			@@list << c
		}
		#@@list.each { |c|
		#	puts "#{c.id}, #{c.name}, #{c.engname}, #{c.nominal}"
		#}
	end

	def rate_req(date)		
		baseurl = 'http://www.cbr.ru/scripts/XML_daily.asp' << (date.nil? ? '' : date.strftime('?date_req=%d/%m/%Y') )
		address = URI("#{baseurl}")
		list = []
		doc = Nokogiri::XML(open(address))

		doc.encoding = "UTF-8"
		#doc.xpath("//Valuta/Item").each{ |item|
		#	a = item.xpath("@ID").text
		#	puts a.inspect
		#	res = 0
		#	res = 1 if a == @id.to_s
		#	puts "'#{a}', '#@id', '#{res}'"
		#}
		doc
	end

	def rate(date)
		key = (date.nil? ? DateTime.now.to_date : date).to_s.to_sym
		if @@rates.has_key? key 
			doc = @@rates[key] 
		else 
			doc = rate_req(date)
			@@rates[key] = doc
		end	

		rate_node = doc.xpath("//ValCurs/Valute").select{ |item|
			item.xpath("@ID").text == @id
		}.first
		#puts rate_node
		(rate_node.search('Value').text.sub(',','.').to_f / rate_node.search('Nominal').text.to_f).round(4) unless rate_node.nil?

	end

	attr_accessor :id, :name, :engname, :nominal

end