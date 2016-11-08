require 'open-uri'
require 'nokogiri'
require 'date'

# Оболочка над API ЦБ РФ: http://www.cbr.ru/scripts/Root.asp?PrtId=SXML
class Currency
  @@list, @@rates = nil, nil

  # Returns entire currencies list
  def self.all
    begin
      load if @@list.nil?
      Rails.logger.debug 'Currencies list loaded correctly'
    rescue
      Rails.logger.debug 'Currencies list load error'
    end
    @@list
  end

  # Load Currencies list
  def self.load
    @@list = []
    @@rates = {}
    baseurl = "http://www.cbr.ru/scripts/XML_val.asp"
    query = URI.encode_www_form("d" => "0")
    address = URI("#{baseurl}?#{query}")
    doc = Nokogiri::XML(open(address)) #{|f| p f.content_type, f.charset, f.read.encoding }
    doc.encoding = "UTF-8"
    doc.xpath("//Valuta/Item").each do |item|
      c = Currency.new
      c.id = item.xpath("@ID").text
      c.name = item.xpath("Name/text()")
      c.engname = item.xpath("EngName/text()")
      c.nominal = item.xpath("Nominal/text()")
      @@list << c
    end
  end

  # Load currency rate on date
  def rate_req(date)
    begin
      baseurl = 'http://www.cbr.ru/scripts/XML_daily.asp' << (date.nil? ? '' : date.strftime('?date_req=%d/%m/%Y'))
      address = URI("#{baseurl}")

      doc = Nokogiri::XML(open(address))

      doc.encoding = "UTF-8"
      doc
    rescue
      Rails.logger.debug "Currency #{:id} load rate on date #{date} error"
    end
  end

  def rate(date)
    date = date.nil? ? DateTime.now.to_date : date
    key = date.to_s.to_sym
    if @@rates.has_key? key
      doc = @@rates[key]
    elsif row = RatesHistory.find_by_date(date)
      doc = Nokogiri::XML(row.rates)
      @@rates[key] = doc
    else
      doc = rate_req(date)
      doc and @@rates[key] = doc and RatesHistory.create!(date: date, rates: doc)
    end

    rate_node = doc.xpath("//ValCurs/Valute").select { |item| item.xpath("@ID").text == @id }.first
    #puts rate_node
    (rate_node.search('Value').text.sub(',', '.').to_f / rate_node.search('Nominal').text.to_f).round(4) unless rate_node.nil?

  end

  attr_accessor :id, :name, :engname, :nominal

end