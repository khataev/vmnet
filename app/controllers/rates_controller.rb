#require_relative 'currency'

class RatesController < ApplicationController
	def index
		@currencies = Currency.all

	end

	def show
		id = params[:id]
		if id
			@currency = @currencies.select {|c| c.id == id}.first
			@rate = @currency.rate
		end
	end
end
