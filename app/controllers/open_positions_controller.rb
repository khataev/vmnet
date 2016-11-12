require 'open-uri'
class OpenPositionsController < ApplicationController
	before_action :set_headers, only: :show


  def show
  	date_format = '%Y%m%d'
    date = params[:date].nil? ? DateTime.now.to_date : Date.strptime(params[:date], date_format)
    csv = OpenPositions.get(date)

    send_data csv,
              type: 'text/csv; charset=utf-8; header=present',
              disposition: "attachment; filename=open_positions_#{date}.csv"
  end

  def set_headers
  	response.headers["Access-Control-Allow-Origin"] = "micexopen.khataev.com"
    # response.headers["Access-Control-Allow-Origin"] = "*"
  end
end
