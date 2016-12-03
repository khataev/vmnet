require 'csv'

class OpenPositions
    @@positions = {}
    @@date_format = '%Y%m%d'

    def self.get_req(date)
      # TODO: Refactor date conversion, multiple date_format
      date = date.strftime(@@date_format)
        baseurl = "http://moex.com/ru/derivatives/open-positions-csv.aspx?d=#{date}&t=1"
        open(baseurl).read
    end

    def self.get(date)
        @@positions = {}
        date = date.nil? ? DateTime.now.to_date : date      

        key = date.to_s.to_sym
        if @@positions.has_key? key
          csv = @@positions[key]
        elsif row = PositionsHistory.find_by_date(date)
          csv = row.positions
          @@positions[key] = csv
        else
          csv = OpenPositions.get_req(date)
          # byebug
          if csv.match /server overloaded/im
            csv = CSV.generate do |str|
                str << ["errorcode", "errormessage"]
                str << ["500", "MOEX Server Overloaded"]
            end
          else
            csv and CSV.parse(csv).size > 1 and @@positions[key] = csv and PositionsHistory.create!(date: date, positions: csv)
          end
        end     
        csv
    end
end