require 'date'

class Api::V1::RatesController < ApplicationController
	protect_from_forgery except: :usd
	respond_to :json

	before_action :init

	@@usd_id = 'R01235'
	@@eur_id = 'R01239'
	@@date_format = '%Y%m%d'

	def usd
		ans = {}
		if @start_date && @end_date
			ans.merge!({start_date: @start_date, end_date: @end_date})
			@start_date.upto(@end_date) do |day|
				ans[day.to_s] = usdcur.rate(day)
			end
		else
			ans[:error] = "Error parsing start or end date"
		end

		ans[:error] = "Error geting data from CBR service" unless @currencies

		# ans = { rate: usdcur.rate(nil), start_date: @start_date, end_date: @end_date }
		respond_with ans, callback: params[:callback]
	end

	private

	def init
		begin
			@currencies = Currency.all
			@start_date = Date.strptime(params[:start_date],@@date_format) if params[:start_date]
			@end_date = Date.strptime(params[:end_date],@@date_format) if params[:end_date]
		rescue
		end
	end

	def usdcur
		@usd_currency = @currencies.select {|c| c.id == @@usd_id}.first
	end

	def eurcur
		@eur_currency = @currencies.select {|c| c.id == @@eur_id}.first
	end
end