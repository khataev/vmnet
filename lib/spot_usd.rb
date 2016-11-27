require 'open-uri'
require 'nokogiri'
require 'date'

# Оболочка над API ММВБ: http://www.moex.com/iss/history/engines/currency/markets/selt/boards/CETS/securities/USD000UTSTOM.xml
# Преднамеренно подогнал обработку сервиса, возвращающего данные за период к уже решенному частному случаю - на дату, чтобы не заморачиваться пока с алгоритмом
class SpotUsd

  # Load currency rate on date
  def rate_req_period(from, till)
    begin
      query = URI.encode_www_form from: from.strftime('%Y-%m-%d'), till: till.strftime('%Y-%m-%d')
      baseurl = 'http://www.moex.com/iss/history/engines/currency/markets/selt/boards/CETS/securities/USD000UTSTOM.xml'  
      address = URI("#{baseurl}?#{query}")

      doc = Nokogiri::XML(open(address))

      doc.encoding = "UTF-8"
      doc
    rescue
      Rails.logger.debug "USDRUB_TOM load error, from: #{from}, till: #{till}"
    end
  end

  def rate_req(date)
    rate_req_period(date, date)
  end

  def rate(date)
    @@rates ||= {}
    date = date.nil? ? DateTime.now.to_date : date
    key = date.to_s.to_sym
    if @@rates.has_key? key
      doc = @@rates[key]
    elsif row = SpotRatesHistory.find_by_date(date)
      doc = Nokogiri::XML(row.rates)
      @@rates[key] = doc
    else
      doc = rate_req(date)
      save_to_db = true
      doc and @@rates[key] = doc # SpotRatesHistory.create!(date: date, rates: doc)
    end
    # byebug
    rate_node = doc.xpath("//document/data/rows/row")
    SpotRatesHistory.create!(date: date, rates: doc) if save_to_db && rate_node.size > 0
    #puts rate_node
    rate_node.xpath('@CLOSE').text.sub(',', '.').to_f unless rate_node.nil?

  end

  attr_accessor :id, :name, :engname, :nominal

end