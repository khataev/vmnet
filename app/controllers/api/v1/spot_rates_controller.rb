require 'date'

class Api::V1::SpotRatesController < ApplicationController
  protect_from_forgery except: :usdrub_tom
  respond_to :json

  before_action :init, only: :usdrub_tom

  @@date_format = '%Y%m%d'

  def usdrub_tom
    ans = {
        rates: {}
    }
    if @start_date && @end_date
      ans.merge!({start_date: @start_date, end_date: @end_date})
      # TODO: Refactor with mass select at once instead of multiple selects
      @start_date.upto(@end_date) { |day| ans[:rates][day.to_s] = usdcur.rate(day) } if usdcur
    else
      ans[:error] = "Error parsing start or end date"
    end

    ans[:error] = "Error geting data from MOEX USDRUB_TOM service" unless usdcur

    # ans = { rate: usdcur.rate(nil), start_date: @start_date, end_date: @end_date }
    respond_with ans, callback: params[:callback]
  end

  private

  def init
    begin
      @start_date = Date.strptime(params[:start_date], @@date_format) if params[:start_date]
      @end_date = Date.strptime(params[:end_date], @@date_format) if params[:end_date]
    rescue
    end
  end


  def usdcur
    @spot_usd ||= SpotUsd.new
  end
end